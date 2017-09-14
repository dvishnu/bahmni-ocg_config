select ou.age,ou.gender,sum(ou.new_visit) follow_visits, (sum(ou.new_visit)/(select count(*) from visit where date_started >'#startDate#' and date_started<'#endDate#'))*100 follow_visit_percent from
(select 
	TIMESTAMPDIFF(YEAR,p.birthdate,CURDATE()) AS age,
	p.gender gender, if(b.visit_id is not null,1,0) new_visit,1 total  from 
(select visit_id,patient_id,date_started from visit  where date_started <'#endDate#') a 
left outer join (select visit_id,patient_id,date_started from visit  where date_started <'#startDate#') b on a.patient_id=b.patient_id 
join person p on p.person_id = a.patient_id
where a.date_started>'#startDate#'
) ou
group by ou.age,ou.gender;
