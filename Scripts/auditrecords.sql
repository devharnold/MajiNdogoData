-- Part3 - Linking records(Between the Auditors Table and the Visits Table)

SELECT
	auditor_report.location_id AS audit_location,
	auditor_report.true_water_source_score,
	visits.location_id AS visit_location,
	visits.record_id
FROM
	md_water_services.auditor_report
JOIN
	md_water_services.visits
	ON auditor_report.location_id = visits.location_id;

SELECT
	auditor_report.location_id AS audit_location,
	auditor_report.true_water_source_score AS auditor_score,
	visits.location_id AS visit_location,
	visits.record_id,
	water_quality.subjective_quality_score AS surveyor_score
FROM	
	md_water_services.auditor_report
JOIN
	md_water_services.visits
	ON auditor_report.location_id = visits.location_id
JOIN
	md_water_services.water_quality
	ON visits.record_id = water_quality.record_id;

SELECT
	visits.location_id,
	visits.record_id,
	auditor_report.true_water_source_score AS auditor_score,
	water_quality.subjective_quality_score AS surveyor_score
FROM
	md_water_services.auditor_report
JOIN
	md_water_services.visits
	ON auditor_report.location_id = visits.location_id
JOIN
	md_water_services.water_quality
	ON visits.record_id = water_quality.record_id
WHERE
	auditor_report.true_water_source_score = water_quality.subjective_quality_score;

SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
    md_water_services.auditor_report
JOIN
    md_water_services.visits
    ON auditor_report.location_id = visits.location_id
JOIN
    md_water_services.water_quality
    ON visits.record_id = water_quality.record_id
WHERE
    auditor_report.true_water_source_score = water_quality.subjective_quality_score;

SELECT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    (auditor_report.true_water_source_score - water_quality.subjective_quality_score) AS score_diff
FROM
    md_water_services.auditor_report
JOIN
    md_water_services.visits
    ON auditor_report.location_id = visits.location_id
JOIN
    md_water_services.water_quality
    ON visits.record_id = water_quality.record_id
WHERE
    (auditor_report.true_water_source_score - water_quality.subjective_quality_score) = 0;

SELECT DISTINCT
	visits.location_id,
	visits.record_id,
	visits.visit_count,
	auditor_report.true_water_source_score AS auditor_score,
	water_quality.subjective_quality_score AS surveyor_score
FROM
	md_water_services.auditor_report
JOIN
	md_water_services.visits
	ON auditor_report.location_id = visits.location_id
JOIN
	md_water_services.water_quality
	ON visits.record_id = water_quality.record_id
WHERE visits.visit_count = 1
	AND water_quality.subjective_quality_score = 10;

SELECT DISTINCT
	water_source.type_of_water_source AS survey_source,
	visits.location_id,
	visits.record_id,
	auditor_report.true_water_source_score AS auditor_score,
	water_quality.subjective_quality_score AS surveyor_score
FROM
	md_water_services.auditor_report
JOIN
	md_water_services.visits
	ON audio

SELECT DISTINCT
    visits.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score,
    (auditor_report.true_water_source_score - water_quality.subjective_quality_score) AS score_diff
FROM
    md_water_services.auditor_report
JOIN
    md_water_services.visits
    ON auditor_report.location_id = visits.location_id
JOIN
    md_water_services.water_quality
    ON visits.record_id = water_quality.record_id;
-- WHERE (auditor_report.true_water_source_score - water_quality.subjective_quality_score) = 0

SELECT
    COUNT(*) AS total_records,
    SUM(CASE 
        WHEN auditor_report.true_water_source_score = water_quality.subjective_quality_score THEN 1 
        ELSE 0 
    END) AS agreements,
    SUM(CASE 
        WHEN auditor_report.true_water_source_score != water_quality.subjective_quality_score THEN 1 
        ELSE 0 
    END) AS disagreements
FROM
    md_water_services.auditor_report
JOIN
    md_water_services.visits
    ON auditor_report.location_id = visits.location_id
JOIN
    md_water_services.water_quality
    ON visits.record_id = water_quality.record_id;