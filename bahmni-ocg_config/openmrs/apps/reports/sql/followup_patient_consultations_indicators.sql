select   p.gender,TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) AS age, pr.provider_id,pr.name clinician, cn.name diagnosis,count(a.visit_id) followup_visits, count(a.visit_id)/denom.visit_count*100 followup_percent
FROM
        (SELECT 
        visit_id, patient_id
    FROM
        visit
    WHERE
       date_started>='#startDate#'  and  date_started <= '#endDate#') a
    LEFT OUTER JOIN (SELECT 
        distinct patient_id
    FROM
        visit
    WHERE
        date_started < '#startDate#') b ON a.patient_id = b.patient_id 
        join person p on p.person_id=a.patient_id
		join  (  select count(visit_id) visit_count from visit where  date_started>='#startDate#'  and  date_started <= '#endDate#' ) denom
        join encounter e on e.visit_id = a.visit_id
        join obs o on o.encounter_id = e.encounter_id  and o.person_id=a.patient_id and concept_id in  (285,286,287,288,289,290,291,292,293,155)
        join concept_name cn on o.concept_id=cn.concept_id
        join encounter_provider ep on ep.encounter_id= e.encounter_id
        join provider pr on ep.provider_id = pr.provider_id
        where b.patient_id is not null
        group by p.gender,age,clinician,cn.name;
