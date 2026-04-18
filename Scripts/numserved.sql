SELECT 
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served
FROM md_water_services.water_source
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;

SELECT 
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served,
    ROUND(
        SUM(number_of_people_served) * 100.0 / 
        SUM(SUM(number_of_people_served)) OVER (), 
        0
    ) AS percentage_served
FROM md_water_services.water_source
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;

SELECT
	type_of_water_source,
	SUM(number_of_people_served) AS total_people_served,
	RANK() OVER(
		ORDER BY SUM(number_of_people_served) DESC
	) AS rank_by_population
FROM md_water_services.water_source
GROUP BY type_of_water_source 
ORDER BY total_people_served DESC;