select 
	per.gender,
	TIMESTAMPDIFF(YEAR,per.birthdate,CURDATE()) AS age ,
	(sum(per.dead)/(select count(*) from patient)*100) mortality_rate
from patient pat
	join person per on per.person_id=pat.patient_id
    group by age,gender;
