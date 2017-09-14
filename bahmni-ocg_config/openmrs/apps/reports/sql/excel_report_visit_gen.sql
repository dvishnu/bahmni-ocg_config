
SELECT 
    visit_id,date_started,gender,
    GROUP_CONCAT(DISTINCT (IF(concept_id IN (323),
            1,
            IF(concept_id IN (324), 2, NULL)))) visit,
    GROUP_CONCAT(DISTINCT (IF(concept_id IN (298),
            value_coded,null))) visit_coded,age,month(date_started)
FROM
    (SELECT 
        e.visit_id,
            o.encounter_id,
            o.obs_id,
            o.person_id o_pid,
            e.patient_id e_pid,
            o.concept_id,
            o.value_coded,
            o.obs_datetime,
            v.date_started,
            p.gender,
            TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) AS age
            
    FROM
        obs o
    JOIN encounter e ON e.encounter_id = o.encounter_id
        AND e.patient_id = o.person_id
        JOIN visit v on e.visit_id=v.visit_id
        join person p on p.person_id=v.patient_id
    WHERE
        concept_id IN (324 , 323, 298)
            AND e.visit_id > 35
    ORDER BY e.visit_id , o.encounter_id , o.obs_id) a
GROUP BY visit_id
order by date_started;
