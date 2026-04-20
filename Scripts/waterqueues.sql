-- How long the survey took
SELECT
	MIN(time_of_record) AS start_date,
	MAX(time_of_record) AS end_date,
	DATEDIFF(MAX(time_of_record), MIN(time_of_record)) AS survey_duration_days
FROM
	md_water_services.visits;

-- The average total queue time for water
SELECT
    AVG(NULLIF(time_in_queue, 0)) AS avg_queue_time
FROM
    md_water_services.visits;

-- Average time in queue for different days
SELECT
	DAYNAME(time_of_record) AS day_of_week,
	ROUND(AVG(NULLIF(time_in_queue, 0)), 0) AS avg_queue_time
FROM
	md_water_services.visits
GROUP BY day_of_week;

-- What time of the day do people fetch water
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	ROUND(AVG(NULLIF(time_in_queue, 0)), 0) AS avg_queue_time
FROM
	md_water_services.visits
GROUP BY hour_of_day;

SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	DAYNAME(time_of_record),
	CASE
		WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
		ELSE NULL
	END AS Sunday
FROM
	md_water_services.visits
WHERE
-- excludes other sources with 0 queue times
	time_in_queue != 0;

SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	-- Sunday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
		ELSE NULL
	END
		), 0) AS Sunday,
		
	-- Monday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
		ELSE NULL
	END
		), 0) AS Monday,
		
	-- Tuesday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
		ELSE NULL
	END
		), 0) AS Tuesday,
		
	-- Wednesday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
		ELSE NULL
	END
		), 0) AS Wednesday,
		
	-- Thursday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
		ELSE NULL
	END
		), 0) AS Thursday,
		
	-- Friday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
		ELSE NULL
	END
		), 0) AS Friday,
		
	-- Saturday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
		ELSE NULL
	END
		), 0) AS Saturday,
		
FROM 
	md_water_services.visits
WHERE
	time_in_queue != 0
GROUP BY hour_of_day
ORDER BY hour_of_day;
	