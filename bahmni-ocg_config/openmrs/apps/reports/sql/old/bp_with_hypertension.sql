select systa systalic,count(*) count,c total, (sum(hyper)/c)*100 percent from (
SELECT 
    o.person_id,
    o.concept_id,
    o.value_coded,
    o.value_numeric,
    o.obs_datetime,
    a.c ,
   group_concat( if (o.concept_id = 285, 1, NULL) ) hyper,
    group_concat(IF(o.concept_id = 170,
        IF(o.value_numeric <= 140,
            '<=140',
            IF(o.concept_id > 140
                    AND o.concept_id <= 159,
                '140-159',
                '160')),
        NULL) ) systa
FROM
    obs o
        JOIN
    (SELECT 
        COUNT(DISTINCT person_id) c
    FROM
        obs
    WHERE
        concept_id IN (285)) a
        JOIN
    (SELECT 
        person_id, concept_id, MAX(obs_datetime) latest
    FROM
        obs
    WHERE
        concept_id IN (170 , 171, 285)
    GROUP BY person_id , concept_id) ag ON ag.person_id = o.person_id
        AND o.concept_id = ag.concept_id
        AND ag.latest = o.obs_datetime
WHERE
    o.concept_id IN (170 , 171, 285)
GROUP BY o.person_id ) final
where hyper=1
group by systa
;
