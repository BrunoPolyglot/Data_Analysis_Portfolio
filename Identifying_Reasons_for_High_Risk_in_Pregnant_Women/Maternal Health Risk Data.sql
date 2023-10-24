--Name: Bruno Araujo 
--Project: Identifying Reasons for High Risk in Pregnant Women

--Data has been collected from different hospitals, community clinics, maternal health cares through 
--the IoT based risk monitoring system.

-- general information
select *
from maternal_health_risk

-- average of the columns 
select risklevel,
round(avg(age)) as avg_age, 
round(avg(heartrate)) as heartrate_avg, 
round(avg(systolicbp)) as systoliccbp_avg, 
round(avg(bs)) as bs_avg, 
round(avg(bodytemp)) as bodytemp_avg
from maternal_health_risk
group by risklevel

--percentage of each risk level in the sample
select risklevel,concat(round(((count(a.risklevel)/sum(a.count_risk))* 10000),2),'%') as risk_percent
from (select risklevel, count(risklevel) as count_risk
from maternal_health_risk
group by risklevel) a
group by a.risklevel, a.count_risk


--How does the distribution of systolic blood pressure (SystolicBP) look in the dataset?
--> blood plessure higher than 130/80 is considered high.
'Result: all women with high blood pleasure are in high risk,but not all women with high risk have high blood plessure.'
select  risklevel, count(risklevel)
from maternal_health_risk
where systolicbp >130 and DiastolicBP > 80
group by risklevel

--> Does low pressure level represent a high risk ?
'results: no'
select  risklevel, count(risklevel)
from maternal_health_risk
where systolicbp < 90 AND DiastolicBP < 60
group by risklevel

--> how many women have a high risk level but not high blood plessure 
'result = 153 high risk'
SELECT risklevel, count(risklevel)
FROM maternal_health_risk
WHERE (systolicbp, DiastolicBP) NOT IN (
    SELECT systolicbp, DiastolicBP
    FROM maternal_health_risk
    WHERE systolicbp > 130 AND DiastolicBP > 80)
group by risklevel

--investigate why there are high levels when the blood plessure is normal:
'results:the blood sugar average of the high levelis 11, while 7.22 and 7.7 are the average of the low risk and mid risk levels'
select risklevel, avg(bs) as average_sugar
from maternal_health_risk
group by risklevel

--> high pressure sugar in high risk while the average of blood plessure is not high'
'the number of pregnant women in high risk with normal low or normal blood plessure and high blood sugar 
are low, showing that both blood pressure and blood sugar are correlated'
select risklevel, avg(bs) as average_sugar, count(bs) 
from 
(SELECT risklevel, systolicbp, DiastolicBP, bs 
    FROM maternal_health_risk
    WHERE systolicbp < 130 AND DiastolicBP < 80 and bs > 12) 
group by risklevel

-- COMPARE AGE
--> average age by risk level.
'results: the older, the higher the risk.'
select risklevel, avg(age)
from maternal_health_risk 
group by risklevel

--> average age related to high level risk 
'results: the average age of women in high risk and high blood pressure is 39 years old'
select avg(age), count(age)
from maternal_health_risk
where 
	risklevel = 'high risk' and 
	systolicbp >130 and
	diastolicbp >80


--difference between normal blood pressure and high risk vs high pressure and high risk 
'result: women who have normal blood pressure but high risk seem to have a high body temperature, maybe because of an infection'
select avg(age) as age_avg,
avg(bs) as bs_avg,
avg(heartrate) as heartrate_avg ,
avg(bodytemp) as bodytemp_avg, 
count(age) as count_age
from maternal_health_risk
where 
	risklevel = 'high risk' and 
	systolicbp <=130 and
	diastolicbp <=80

'result:women who have high risk and high blood pressure seem to be due to the higher average age of 40 years old'
select avg(age) as age_avg,
avg(bs) as bs_avg,
avg(heartrate) as heartrate_avg ,
avg(bodytemp) as bodytemp_avg, 
count(age) as count_age
from maternal_health_risk
where 
	risklevel = 'high risk' and 
	systolicbp > 130 and
	diastolicbp > 80


'CONCLUSION
In this project, I investigated the data collected in Bangladesh about pregnant women and
"36.76%" of these women were in high risk so I wanted to understand why they were in risk.
according to the data, all the women with high blood pressure were in high risk but not all
the women in high risk had high blood pressure.
the data indicates that the high average age of 39 years old might cause a high blood pressure and high blood sugar
. However, 102 women, with an average age of 29 years old had a higher body temperature even if everything seems to be normal.
That might be caused by an infection.
Unfortunately the data does not helps me go further.
'
