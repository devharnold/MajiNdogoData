SELECT 
    province_name,
    town_name,
    COUNT(*) AS record_count
FROM md_water_services.location
GROUP BY province_name, town_name
ORDER BY province_name, record_count DESC;

SELECT 
    province_name,
    town_name,
    COUNT(*) AS records_per_town
FROM md_water_services.location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town DESC;