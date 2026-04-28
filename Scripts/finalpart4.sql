-- Add data from the source fixes result set into the Project Progress Table
INSERT INTO md_water_services.Project_progress (
    Source_id,
    Address,
    Town,
    Province,
    Source_type,
    Improvement
)
SELECT DISTINCT
    water_source.source_id,
    location.address,
    location.town_name,
    location.province_name,
    water_source.type_of_water_source,

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
    visits.visit_count = 1
    AND (
        CASE
            WHEN water_source.type_of_water_source = 'well'
                AND well_pollution.results LIKE 'Contaminated%'
                THEN 1
            WHEN water_source.type_of_water_source IN ('river', 'shared_tap', 'tap_in_home_broken')
                THEN 1
            ELSE 0
        END = 1
    );

SELECT *
FROM
	md_water_services.Project_progress;