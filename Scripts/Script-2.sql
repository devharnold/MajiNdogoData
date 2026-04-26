-- Part 4
-- Analysis wrap up

-- First join location to visits
SELECT DISTINCT
	visits.location_id,
	visits.visit_count,
	location.province_name,
	location.town_name
FROM
	md_water_services.visits
JOIN
	md_water_services.location
	ON visits.location_id = location.location_id;

-- Join water source to visits
-- Where Location id = 'AkHa00103'
SELECT DISTINCT
	visits.location_id,
	visits.visit_count,
	location.province_name,
	location.town_name,
	water_source.type_of_water_source,
	water_source.number_of_people_served
FROM	
	md_water_services.visits
JOIN
	md_water_services.location
	ON visits.location_id = location.location_id
JOIN
	md_water_services.water_source
	ON visits.source_id = water_source.source_id
WHERE
	visits.location_id = 'AkHa00103';

-- Where Visit_count = 1
SELECT DISTINCT
	visits.location_id,
	visits.visit_count,
	location.province_name,
	location.town_name,
	water_source.type_of_water_source,
	water_source.number_of_people_served
FROM	
	md_water_services.visits
JOIN
	md_water_services.location
	ON visits.location_id = location.location_id
JOIN
	md_water_services.water_source
	ON visits.source_id = water_source.source_id
WHERE
	visits.visit_count = 1;

-- Add Location count and time_in_queue
SELECT DISTINCT
	visits.location_id,
	visits.visit_count,
	visits.time_in_queue,
	location.province_name,
	location.town_name,
	location.location_type,
	water_source.type_of_water_source,
	water_source.number_of_people_served
FROM	
	md_water_services.visits
JOIN
	md_water_services.location
	ON visits.location_id = location.location_id
JOIN
	md_water_services.water_source
	ON visits.source_id = water_source.source_id
WHERE
	visits.visit_count = 1;

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