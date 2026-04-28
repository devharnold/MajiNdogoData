-- Project Progress(Our Plan in the database)
CREATE TABLE Project_progress(
	Project_id SERIAL PRIMARY KEY,
	Source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
	Address VARCHAR(50),
	Town VARCHAR(30),
	Province VARCHAR(30),
	Source_type VARCHAR(50),
	Improvement VARCHAR(50),
	Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
	Date_of_completion DATE,
	Comments TEXT
);

-- Project_id −− Unique key for sources in case we visit the same source more than once in the future
-- Each of the sources we want to improve should exist, and should refer to the source table. This ensures data integrity
-- Street address
-- What the engineers should do at that place
-- We want to limit the type of information engineers can give us, so we limit Source_status
-- Engineers will add this the day the source has been upgraded
-- Engineers can leave comments. We use a TEXT type that has no limit on char length

-- Project Progress Query
SELECT DISTINCT
	location.address,
	location.town_name,
	location.province_name,
	water_source.source_id,
	water_source.type_of_water_source,
	well_pollution.results
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
	visits.visit_count = 1
	AND (
		(water_source.type_of_water_source = 'shared_tap'
		AND visits.time_in_queue >= 30)
	OR
	-- Contaminated wells only
	(water_source.type_of_water_source = 'well'
	AND well_pollution.results != 'Clean')
	
	OR
	(water_source.type_of_water_source = 'river')
	
	OR
	(water_source.type_of_water_source = 'tap_in_home_broken')
);