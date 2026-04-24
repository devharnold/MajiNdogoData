-- Liniking Records to Employees where Subjective quality score = 10
-- Query that leads us into implementing CTEs
SELECT DISTINCT
	visits.location_id,
	visits.record_id,
	visits.visit_count,
	auditor_report.true_water_source_score AS auditor_score,
	water_quality.subjective_quality_score AS surveyor_score
FROM
	md_water_services.auditor_report
JOIN
	md_water_services.visits
	ON auditor_report.location_id = visits.location_id
JOIN
	md_water_services.water_quality
	ON visits.record_id = water_quality.record_id
WHERE visits.visit_count = 1
	AND water_quality.subjective_quality_score = 10;

SELECT DISTINCT
	employee_name
FROM
	md_water_services.employee;

-- CTE counts the total number of employees present in the incorrect records list
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
)
SELECT DISTINCT
	employee_name
FROM Incorrect_records;


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
)
SELECT DISTINCT
	employee_name,
	COUNT(*) AS incorrect_count
FROM Incorrect_records
GROUP BY
	employee_name
ORDER BY
	incorrect_count DESC;

USE md_water_services;


-- Finding the employees who have an above-average number of mistakes
CREATE VIEW Incorrect_records AS (
SELECT
	auditor_report.location_id,
	visits.record_id,
	employee.employee_name,
	auditor_report.true_water_source_score AS auditor_score,
	wq.subjective_quality_score AS surveyor_score,
	auditor_report.statements AS statements
FROM
	md_water_services.auditor_report
JOIN
	md_water_services.visits
	ON auditor_report.location_id = visits.location_id
JOIN
	water_quality as wq
	ON visits.record_id = wq.record_id
JOIN
	employee
	ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE
	visits.visit_count = 1
	AND auditor_report.true_water_source_score != wq.subjective_quality_score)
SELECT DISTINCT
	employee_name,
	location_id,
	statements
FROM Incorrect_records;
