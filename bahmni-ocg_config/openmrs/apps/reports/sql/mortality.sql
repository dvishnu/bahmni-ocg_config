SELECT 
    ou.age,
    ou.gender,
    ou.name,
    sum(ou.isdead)/sum(ou.total)*100 mortality_rate
FROM
    (SELECT 
        TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) AS age,
            p.gender gender,
                     cn.name,
            if(p.dead =1,1,0) isdead,
            1 total
    FROM
        (SELECT 
        visit_id, patient_id, date_started
    FROM
        visit
    WHERE
        date_started < '#endDate#') a
    JOIN person p ON p.person_id = a.patient_id
     JOIN obs o ON o.person_id=p.person_id and o.concept_id in (285,286,287,288,289,290,291,292,293,155)
     JOIN concept_name cn ON cn.concept_id=o.concept_id
    WHERE
        a.date_started > '#startDate#') ou
GROUP BY ou.age , ou.gender;
