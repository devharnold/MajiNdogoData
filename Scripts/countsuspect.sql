-- First create the suspect list as a CTE

CREATE VIEW suspect_list AS
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
	employee_name
FROM
	error_count
WHERE
	number_of_mistakes > (
		SELECT AVG(number_of_mistakes)
		FROM error_count
	);

SELECT *
FROM Incorrect_records
WHERE employee_name IN (
	SELECT employee_name
	FROM suspect_list
);