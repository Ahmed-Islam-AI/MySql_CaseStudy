 -- solution of Foodie_Fi Schema
  
ALTER TABLE `foodie_fi`.`plans` 
CHANGE COLUMN `plan_id` `plan_id` INT NOT NULL ,
ADD PRIMARY KEY (`plan_id`);

select * from subscriptions;
select * from plans;


-- customer journey 
select p.plan_name, s.start_date,s.customer_id
from subscriptions s
join plans p ON s.plan_id=p.plan_id;


-- 1- How many customers has Foodie-Fi ever had?
select count(Distinct customer_id) AS total_customers
FROM subscriptions;        -- result total_customers = 1000

-- 2- What is the monthly distribution of trial plan start_date values for our dataset?

select 
	date_format(start_date, '%Y-%m-01') AS starting_month,
	count(plan_id) as trail_plan
From 
	subscriptions
where
	plan_id=0
    group by date_format(start_date, '%Y-%m-01')
    order by starting_month;                            -- In the month of march we have large amount of trail plans


-- 3- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name?
SELECT plan_name, count(*) as event_count
from subscriptions
join plans on subscriptions.plan_id = plans.plan_id
where start_date > '2020-12-31'
group by plan_name;

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

SELECT COUNT(DISTINCT customer_id) AS churned_customers,
       ROUND((COUNT(DISTINCT customer_id) * 100.0 / (select COUNT(DISTINCT customer_id) from subscriptions)), 1) AS churn_percentage
FROM subscriptions
WHERE plan_id = 4;

-- How many customers have churned straight after their initial free trial? What percentage is this rounded to the nearest whole number?
SELECT 
	COUNT(DISTINCT customer_id) AS churned_after_trial,
	Round(count(customer_id)/(select count(distinct customer_id) from subscriptions) *100) As Churn_Percentage_In_Whole_No
From 
	subscriptions
where
	plan_id= 4 AND day(start_date)<=8;
   
-- 6- What is the number and percentage of customer plans after their initial free trial?

WITH cte_next_plan AS (
	SELECT
		*,
		LEAD(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY plan_id) AS next_plan
	FROM subscriptions)
SELECT
	next_plan,
	COUNT(*) AS num_cust,
    	ROUND(COUNT(*) * 100/(SELECT COUNT(DISTINCT customer_id) FROM subscriptions),1) AS perc_next_plan
FROM cte_next_plan
WHERE next_plan is not null and plan_id = 0
GROUP BY next_plan
ORDER BY next_plan;


-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

select plan_name, count(distinct customer_id) AS customer_count,
       ROUND(COUNT(DISTINCT customer_id) * 100.0 / (select count(distinct customer_id) from subscriptions), 1) AS customer_percentage
from subscriptions
JOIN plans ON subscriptions.plan_id = plans.plan_id
WHERE start_date <= '2020-12-31'
GROUP BY plan_name;


-- 8.	How many customers have upgraded to an annual in 2020?
select 
	count(customer_id) as cust_upgraded_annual
from
	subscriptions
where plan_id=3 and year(start_date)=2020;

-- 9.	How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

select * from subscriptions;
with Annualplans as(
select customer_id , min(start_date) as annual_start_date from subscriptions where plan_id=3 group by customer_id
),
trialPlans as(
select customer_id , min(start_date) as trial_start_date from subscriptions where plan_id=0 group by customer_id
)
select AVG(DATEDIFF(Annualplans.annual_start_date, trialPlans.trial_start_date)) 
AS average_days_to_annual_plan
FROM AnnualPlans
 join trialPlans on AnnualPlans.customer_id=trialPlans.customer_id;

-- 10.	Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

 WITH AnnualPlans AS (
    SELECT customer_id, MIN(start_date) AS annual_start_date
    FROM subscriptions
    WHERE plan_id = 3
    GROUP BY customer_id
),
TrialPlans AS (
    SELECT customer_id, MIN(start_date) AS trial_start_date
    FROM subscriptions
    WHERE plan_id = 0
    GROUP BY customer_id
),
DaysDifference AS (
    SELECT
        AnnualPlans.customer_id,
        DATEDIFF(AnnualPlans.annual_start_date, TrialPlans.trial_start_date) AS days_difference
    FROM
        AnnualPlans
    JOIN
        TrialPlans ON AnnualPlans.customer_id = TrialPlans.customer_id
)
SELECT
    SUM(CASE WHEN days_difference BETWEEN 0 AND 30 THEN 1 ELSE 0 END) AS "0-30 days",
    SUM(CASE WHEN days_difference BETWEEN 31 AND 60 THEN 1 ELSE 0 END) AS "31-60 days",
    SUM(CASE WHEN days_difference BETWEEN 61 AND 90 THEN 1 ELSE 0 END) AS "61-90 days",
    SUM(CASE WHEN days_difference BETWEEN 91 AND 120 THEN 1 ELSE 0 END) AS "91-120 days",
    SUM(CASE WHEN days_difference BETWEEN 121 AND 150 THEN 1 ELSE 0 END) AS "121-150 days",
    SUM(CASE WHEN days_difference > 150 THEN 1 ELSE 0 END) AS ">150 days"
FROM
    DaysDifference;
-- 11.	How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

select * from plans;
 select COUNT(DISTINCT customer_id) AS num_downgrades
from subscriptions
where plan_id =  2
and start_date >= '2020-01-01'
and start_date < '2021-01-01'
and customer_id in (
    select customer_id
    from subscriptions
    where plan_id = 1
    and start_date >= '2020-01-01'
    and start_date < '2021-01-01'
);
