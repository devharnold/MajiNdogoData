-- Our final analysis
-- I'm going to write some SQL to help determine whether some areas need improvements or not
-- Example of water_sources with contaminated water, I'm going to use some control flow logic to determine decisions
SELECT DISTINCT
	location.address,
	location.town_name,
	location.province_name,
	water_source.source_id,
	water_source.type_of_water_source,
	well_pollution.results,

	CASE
		WHEN water_source.type_of_water_source = 'well'
			AND well_pollution.results = 'Contaminated: Biological'
			THEN 'Install UV filter'

		WHEN water_source.type_of_water_source = 'well'
			AND well_pollution.results = 'Contaminated: Chemical'
			THEN 'Install RO filter'
		
		WHEN water_source.type_of_water_source = 'river'
			THEN 'Drill Well'
			
		WHEN water_source.type_of_water_source = 'shared_tap'
			AND visits.time_in_queue > 30
			THEN CONCAT('Install ', FLOOR(visits.time_in_queue / 30), ' Taps Nearby')
			
		WHEN water_source.type_of_water_source = 'tap_in_home_broken'
			THEN 'Fix Broken Taps'

		ELSE NULL
	END AS Improvement

FROM
	md_water_services.water_source
LEFT JOIN
	md_water_services.well_pollution
	ON water_source.source_id = well_pollution.source_id 
INNER JOIN
	md_water_services.visits
	ON water_source.source_id = visits.source_id
INNER JOIN
	md_water_services.location
	ON location.location_id = visits.location_id

WHERE
	visits.visit_count = 1;