select (sum(if(systa=1 and dysta =1 and hyper=1,1,0))/total)*100 bp_control_ration from (
select o.person_id ,o.concept_id,o.obs_datetime,o.value_numeric,o.value_coded
,denom.total total,
group_concat(distinct(if((o.concept_id=170 and o.value_numeric<140),1,NULL))) systa,
group_concat(distinct(if((o.concept_id=171 and o.value_numeric<90),1,NULL))) dysta,
   group_concat( if (o.concept_id = 285, 1, NULL) ) hyper

from  obs o
   join (SELECT 
        person_id, concept_id, MAX(obs_datetime) latest
    FROM
        obs
    WHERE
        concept_id IN (170 , 171, 285)
    GROUP BY person_id , concept_id) ag ON ag.person_id = o.person_id
        AND o.concept_id = ag.concept_id
        AND ag.latest = o.obs_datetime 
        join 
        (select count(*)  total from (
SELECT 
    person_id,
    GROUP_CONCAT(DISTINCT (IF(concept_id = 285, 1, NULL))) hyper
    ,GROUP_CONCAT(DISTINCT(IF(concept_id = 170 or concept_id=171,IF(value_numeric is not null,1,NULL),NULL))) hasbp
FROM
    obs
GROUP BY person_id
having hyper =1 and hasbp=1) bpwithhyper ) denom 
group by person_id ) final;
