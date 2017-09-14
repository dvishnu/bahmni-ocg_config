select sum(if(value is null,1,0)) total_enrolled_patients from ( select a.patient_id, group_concat(distinct(  if( value_coded  in  (430,423) ,1,null ))) value
    from
    (SELECT 
        visit_id, patient_id
    FROM
        visit
    WHERE
       date_started>='#startDate#'  and  date_started <= '#endDate#') a
        join person p on p.person_id=a.patient_id and p.dead =0
		join encounter e on e.visit_id = a.visit_id
        join obs o on o.encounter_id = e.encounter_id  and o.person_id=a.patient_id 
        
        group by a.patient_id) aia;
