SELECT
    pi.identifier AS 'Identifier',
    CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name) as 'Name',
	TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS Age,
    p.gender,
    v.date_started,
    obs_fscn.name                         AS 'Diagnosis',
    coalesce(o.value_numeric, o.value_text, o.value_datetime, coded_scn.name, coded_fscn.name) AS 'Status'
FROM
   person p
        INNER JOIN
    patient_identifier pi ON p.person_id = pi.patient_id
        AND pi.voided = '0'
          AND pi.preferred = 1
        INNER JOIN
    person_name pn ON pn.person_id = p.person_id
        AND pn.voided = '0'
        INNER JOIN
    person_address pa ON pa.person_id = pn.person_id
    AND pa.voided = '0'
    INNER JOIN
   (select max(date_started) as date_started,visit_id,patient_id from  visit group by patient_id)  v ON v.patient_id = p.person_id
    LEFT JOIN
    obs o ON o.person_id = p.person_id
    and o.voided = '0'
    JOIN concept obs_concept ON obs_concept.concept_id=o.concept_id AND obs_concept.retired is false AND obs_concept.concept_id IN (285,286,287,288,289,290,291,292,293,155)
  JOIN concept_name obs_fscn on o.concept_id=obs_fscn.concept_id AND obs_fscn.concept_name_type='FULLY_SPECIFIED' AND obs_fscn.voided is false 
  LEFT JOIN concept_name obs_scn on o.concept_id=obs_scn.concept_id AND obs_scn.concept_name_type='SHORT' AND obs_scn.voided is false
  LEFT JOIN concept_name coded_fscn on coded_fscn.concept_id = o.value_coded AND coded_fscn.concept_name_type="FULLY_SPECIFIED" AND coded_fscn.voided is false
  LEFT JOIN concept_name coded_scn on coded_scn.concept_id = o.value_coded AND coded_fscn.concept_name_type="SHORT" AND coded_scn.voided is false

where p.voided = '0'
and date(v.date_started) between NOW() - INTERVAL 4 DAY and NOW()
group by Identifier, Name, Age, gender 

