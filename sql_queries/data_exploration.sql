-- OVERALL CHURN REVIEW
-- 1) Overall Churn Rate

select churn,
count(*) as customer_count,
round(count(*)*100/(select count(*) from cleaned_table),2) as Percentage
from 
cleaned_table
group by churn;
-- 26.54% is the overall churn rate.

-- Churn by Demographics
-- 1) Does gender affect churn?
select gender, churn, count(*) as total
from 
cleaned_table 
group by gender, churn;
-- The number of male and female who are leaving is almost same.
-- It shows churning is not gender based.

-- 2) Does being a senior citizen affect churn?
select SeniorCitizen, churn, count(*) as total
from 
cleaned_table
group by SeniorCitizen, churn;
-- People who are not in the category of senior citizen are leaving more than the senior citizen.

-- 3) Does having a partner/ Dependents affect churn?
select Partner, Dependents, churn, count(*) as total
from 
cleaned_table
group by Partner, Dependents, churn;
-- Maximum people who are neither partner nor Dependents are leaving. 
-- So we can say it doesn't depend on partner/Dependent.

-- Churn By Contract/ Billing.
-- 1) Churn Rate by Contract type
select Contract, count(*) as total,
sum(case when churn = "Yes" then 1 else 0 end) as churned,
round(sum(case when churn = "Yes" then 1 else 0 end)*100/count(*), 2) as churning_percentage
from 
cleaned_table
group by Contract;
-- This is usually the single strongest churn predictor — month-to-month customers churn far more than 1-2 year contracts.

-- 2) Churn by Payment method. 
select PaymentMethod,
sum(case when churn = "Yes" then 1 else 0 end) as total,
round(sum(case when churn = "Yes" then 1 else 0 end) *100/ count(*),2) as churn_percentage
from 
cleaned_table
group by PaymentMethod
order by churn_percentage desc;
--  Electronic check users typically churn more — could point to friction or lower commitment.

-- 3)Does paperless billing correlate with churn?
select PaperlessBilling, churn, count(*) as total 
from
cleaned_table
group by PaperlessBilling, churn;

-- Churn By Tenure
-- 1) Churn rate by tenure buckets
select case 
when tenure between 0 and 12 then '0-12 Months'
when tenure between 13 and 24 then '13-24 Months'
when tenure between 25 and 48 then '25-48 Months'
else '48+ Months' 
end as tenure_bucket,
count(*) as total,
sum(case when churn = "Yes" then 1 else 0 end) as total_churn,
round(sum(case when churn = "Yes" then 1 else 0 end), 2)*100 / count(*) as churn_Percentage
from 
cleaned_table
group by tenure_bucket;
--  Churn is usually highest in the first 12 months — the "honeymoon risk period."

-- Churn by Service Subscribed
-- 1) Churn rate by internet service type 
select InternetService, count(*) as total,
sum(case when churn ="Yes" then 1 else 0 end) as total_churned,
Round(sum(case when churn = "Yes" then 1 else 0 end), 2) *100/count(*) as churn_rate
from 
cleaned_table
group by InternetService;
-- Insight- Fiber optic customers often churn more despite paying more — hints at service/quality issues.

-- 2) Does having tech support/ online security reduce churn?
select TechSupport, churn, count(*) as total
from 
cleaned_table
group by TechSupport, churn;

-- 3) Does streaming (TV/ Movies) affect churn?
select StreamingTV, StreamingMovies, churn, count(*) as total
from 
cleaned_table
group by StreamingTV, StreamingMovies, churn;

-- Revenue Impact
-- 1) Total revenue lost due to churn.
select round(sum(MonthlyCharges),2) as monthly_revenue_at_risk
from 
cleaned_table 
where churn = "Yes";
-- Total monthly revenue at risk = 139130.85

-- 2) Average monthly charges - churned vs retained
select churn, round(avg(MonthlyCharges),2) as Avg_monthly_charges
from
cleaned_table
group by churn;
-- Total churn average monthly charges - 74.44

-- 3) Revenue at risk by contract type
select Contract, 
round(sum(case when churn = "Yes" then MonthlyCharges else 0 end), 2) as revenue_contract_type
from 
cleaned_table
group by Contract
order by revenue_contract_type desc;
-- In month to month contract type the revenue at risk is far more than in one year or two year contract type.

-- High Risk Segment identification.
-- 1) Top 5 highest-risk customer segments
select Contract, InternetService, PaymentMethod,
sum(case when churn ="Yes" then 1 else 0 end) as churned,
round(sum(case when churn = "Yes" then 1 else 0 end),2)*100/count(*) as churn_rate
from 
cleaned_table
group by Contract, InternetService, PaymentMethod
having count(*) > 30
order by churn_rate desc
limit 5;
-- Insights - Month-to-month fiber optic customers paying by electronic check are the highest churn risk (60.37%).
--  It signals an urgent need to transition manual-pay users to auto-pay contracts.

-- 2) Rank customers by risk using a churn score proxy
select customerID, Contract, MonthlyCharges, tenure,
rank() over (partition by Contract order by MonthlyCharges desc) as rnk
from 
cleaned_table 
where churn = "Yes";
