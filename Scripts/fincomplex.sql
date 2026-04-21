-- The final complex query (Source of Truth)

WITH error_count AS (
    -- Count how many mistakes each employee made
    SELECT
        employee_name,
        COUNT(*) AS number_of_mistakes
    FROM
        Incorrect_records
    GROUP BY
        employee_name
),

suspect_list AS (
    -- Select employees with above-average mistakes
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
)

-- Final query: get records linked to those employees
SELECT
    employee_name,
    location_id,
    statements
FROM
    Incorrect_records
WHERE
    employee_name IN (
        SELECT employee_name
        FROM suspect_list
    );