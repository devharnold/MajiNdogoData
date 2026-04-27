-- Join the results from the well_pollution table
SELECT DISTINCT
	water_source.type_of_water_source,
	location.town_name,
	location.province_name,
	location.location_type,
	water_source.number_of_people_served,
	visits.time_in_queue,
	well_pollution.results
FROM	
	md_water_services.visits
LEFT JOIN
	md_water_services.well_pollution
	ON well_pollution.source_id = visits.source_id
INNER JOIN
	md_water_services.location
	ON location.location_id = visits.location_id
INNER JOIN
	md_water_services.water_source
	ON water_source.source_id = visits.source_id
WHERE
	visits.visit_count = 1;


-- We want to analyze the data in the results set. Therefore a view would come in handy
-- The view assembles data from different tables to simplify analysis
CREATE VIEW combined_analysts_table AS
	SELECT
		water_source.type_of_water_source,
		location.town_name,
		location.province_name,
		location.location_type,
		water_source.number_of_people_served AS people_served,
		visits.time_in_queue,
		well_pollution.results
	FROM
		md_water_services.visits
	LEFT JOIN
		well_pollution
		ON well_pollution.source_id = visits.source_id
	INNER JOIN
		md_water_services.location
		ON location.location_id = visits.location_id
	INNER JOIN
		md_water_services.water_source
		ON water_source.source_id = visits.source_id
	WHERE
		visits.visit_count = 1;

-- Breaking our data into towns or provinces and source types (Another CTE)
-- CTE that calculates the population of a province
-- The case statements create columns for each type of source
-- The results are aggregated and percentages are calculated
-- province totals is a CTE that calculates the SUM of all the people surveyed by GROUP province
WITH province_totals AS (
	SELECT
		province_name,
		SUM(people_served) AS total_people_served
	FROM
		combined_analysts_table
	GROUP BY
		province_name
)
SELECT
	ct.province_name,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'river'
		THEN ct.people_served ELSE 0 END) * 100.0 / pt.total_people_served, 0) AS river,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'shared_tap'
		THEN ct.people_served ELSE 0 END) * 100.0 / pt.total_people_served, 0) AS shared_tap,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'tap_in_home'
		THEN ct.people_served ELSE 0 END) * 100.0 / pt.total_people_served, 0) AS tap_in_home,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'tap_in_home_broken'
		THEN ct.people_served ELSE 0 END) * 100.0 / pt.total_people_served, 0) AS tap_in_home_broken,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'well'
		THEN ct.people_served ELSE 0 END) * 100.0 / pt.total_people_served, 0) AS well

FROM
	combined_analysts_table ct
JOIN
	province_totals pt
	ON ct.province_name = pt.province_name

GROUP BY
	ct.province_name, pt.total_people_served

ORDER BY
	ct.province_name;

-- Calculates the SUM of all the people surveyed by group province
WITH province_totals AS (
	SELECT
		province_name,
		SUM(people_served) AS total_people_served
	FROM
		combined_analysts_table
	GROUP BY
		province_name
)
SELECT *
FROM province_totals;


WITH town_totals AS (
	SELECT province_name, town_name, SUM(people_served) AS total_ppl_svd
	FROM combined_analysts_table
	GROUP BY province_name, town_name
)
SELECT
	ct.province_name,
	ct.town_name,
	ROUND((SUM(CASE
		WHEN type_of_water_source = 'river'
		THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_svd, 0) AS river,
	
	ROUND((SUM(CASE
		WHEN type_of_water_source = 'shared_tap'
		THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_svd, 0) AS shared_tap,
		
	ROUND((SUM(CASE
		WHEN type_of_water_source = 'tap_in_home'
		THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_svd, 0) AS tap_in_home,
	
	ROUND((SUM(CASE
		WHEN type_of_water_source = 'tap_in_home_broken'
		THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_svd, 0) AS tap_in_home_broken,
		
	ROUND((SUM(CASE
		WHEN type_of_water_source = 'well'
		THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_svd, 0) AS well

FROM
	combined_analysts_table ct
JOIN
	town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY
	ct.province_name,
	ct.town_name
ORDER BY
	ct.town_name;



-- This CTE calculates the total population of each town
-- We will group by province name and town name since there are two Harares
-- And join on a composite key since the town names are not unique
WITH town_totals AS (
	SELECT province_name, town_name, SUM(people_served) AS ttl_ppl_svd
	FROM combined_analysts_table
	GROUP BY province_name, town_name
)
SELECT
	ct.province_name,
	ct.town_name,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'river'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS river,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'shared_tap'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS shared_tap,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'tap_in_home'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS tap_in_home,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'tap_in_home_broken'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS tap_in_home_broken,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'well'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS well

FROM
	combined_analysts_table ct
JOIN
	town_totals tt 
	ON ct.province_name = tt.province_name 
	AND ct.town_name = tt.town_name

GROUP BY
	ct.province_name,
	ct.town_name,
	tt.ttl_ppl_svd
ORDER BY
	ct.town_name;

-- Temporary tables to store the complex query result
CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (
	SELECT province_name, town_name, SUM(people_served) AS ttl_ppl_svd
	FROM combined_analysts_table
	GROUP BY province_name, town_name
)
SELECT
	ct.province_name,
	ct.town_name,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'river'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS river,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'shared_tap'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS shared_tap,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'tap_in_home'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS tap_in_home,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'tap_in_home_broken'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS tap_in_home_broken,

	ROUND(SUM(CASE 
		WHEN ct.type_of_water_source = 'well'
		THEN ct.people_served ELSE 0 END) * 100.0 / tt.ttl_ppl_svd, 0) AS well

FROM
	combined_analysts_table ct
JOIN
	town_totals tt 
	ON ct.province_name = tt.province_name 
	AND ct.town_name = tt.town_name

GROUP BY
	ct.province_name,
	ct.town_name,
	tt.ttl_ppl_svd
ORDER BY
	ct.town_name;

-- Town with the highest ratio of people who have taps but no drinking water
SELECT
	province_name,
	town_name,
	ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100.0) AS Pct_broken_taps
FROM
	town_aggregated_water_access;