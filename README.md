# telco-customer-churn-analysis
# 📊 Telco Customer Churn Analysis

## Overview

This project analyzes customer churn patterns for a telecom company using SQL. The goal is to identify the key drivers of churn and quantify their business impact to support customer retention strategies.

## Tools Used

* SQL (MySQL)
* Tableau
* Python

## Key Insights

* **Contract type is the strongest churn driver** — month-to-month customers churn at ~42–43%, nearly **15× higher** than two-year contract customers (~3%).

* **The first 12 months are the highest-risk period** — churn reaches ~48% among customers with less than one year of tenure and declines significantly afterward.

* **Churned customers are higher-value customers** — they pay approximately **$74/month** on average compared to **$61/month** for retained customers.

* **Fiber optic and electronic-check customers show the highest churn rates** (~42% and ~45% respectively), indicating potential service-quality or payment-friction issues.

* **Approximately $140K in monthly recurring revenue is at risk** from churned customers, highlighting the financial impact of customer attrition.

## SQL Concepts Used

* Aggregations
* CASE Statements
* GROUP BY & HAVING
* Window Functions
* Subqueries

## Repository Structure

```text
telco-customer-churn-analysis/
├── dataset/
├── sql_queries/
├── README.md
└── insights.md
```

## Business Recommendation

Focus retention efforts on:

* Month-to-month customers
* Customers in their first year
* Fiber optic subscribers
* Electronic-check users

These segments present the greatest opportunity to reduce churn and protect revenue.
