-- Count the number of times the employees appear in the incorrect records list
WITH Incorrect_records AS (
	SELECT DISTINCT
		visits.location_id,
		visits.record_id,
		visits.visit_count,
		auditor_report.true_water_source_score AS auditor_score,
		water_quality.subjective_quality_score AS surveyor_score,
		employee.employee_name
	FROM
		md_water_services.auditor_report
	JOIN
		md_water_services.visits
		ON auditor_report.location_id = visits.location_id
	JOIN
		md_water_services.employee
		ON visits.assigned_employee_id = employee.assigned_employee_id
	JOIN
		md_water_services.water_quality
		ON visits.record_id = water_quality.record_id
	WHERE visits.visit_count = 1
		AND water_quality.subjective_quality_score = 10
),
error_count AS (
	SELECT
		employee_name,
		COUNT(*) AS error_count
	FROM
		Incorrect_records
	GROUP BY
		employee_name
)

SELECT
	AVG(error_count) AS average_error_count_per_employee
FROM
	error_count;


WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
	SELECT
		employee_name,
		COUNT(employee_name) AS number_of_mistakes
	FROM
		Incorrect_records
/* Incorrect_records is a view that joins the audit report to the database
for records where the auditor and
employees scores are different*/
	GROUP BY
		employee_name)
-- Query
SELECT * FROM error_count;

WITH error_count AS (
	SELECT
		employee_name,
		COUNT(*) AS number_of_mistakes
	FROM
		Incorrect_records
	GROUP BY
		employee_name
)

SELECT
	employee_name,
	number_of_mistakes
FROM
	error_count
WHERE
	number_of_mistakes > (
		SELECT AVG(number_of_mistakes)
		FROM error_count
	)
ORDER BY
	number_of_mistakes DESC;