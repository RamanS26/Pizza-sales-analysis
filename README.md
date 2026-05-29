# Pizza-sales-analysis
Project Overview 
# Pizza Sales Analysis using SQL

## Project Overview

This project focuses on analyzing pizza sales data using SQL to derive meaningful business insights related to revenue trends, customer ordering behavior, product performance, and operational efficiency.

The dataset was downloaded from Kaggle in raw CSV format and processed using MySQL. The project includes data cleaning, database modeling, KPI analysis, advanced SQL analytics, and business insight generation.

The SQL workflow was designed to support future integration with Power BI for dashboard visualization and business reporting.

---

# Objectives

* Clean and transform raw transactional data
* Design a relational database schema
* Create relationships using primary and foreign keys
* Perform KPI and sales analysis
* Analyze customer ordering behavior
* Identify top-performing products
* Generate business insights using SQL

---

# Dataset Information

The project uses four datasets:

| Table Name    | Description                                       |
| ------------- | ------------------------------------------------- |
| orders        | Contains order date and order time information    |
| order_details | Contains pizza quantities for each order          |
| pizzas        | Contains pizza size and pricing information       |
| pizza_types   | Contains pizza names, categories, and ingredients |

---

# Database Modeling

The database was normalized using:

* Primary Keys
* Foreign Keys
* Relational Joins

### Entity Relationship Structure

orders
(order_id PK)

↓

order_details
(order_details_id PK)
(order_id FK)
(pizza_id FK)

↓

pizzas
(pizza_id PK)
(pizza_type_id FK)

↓

pizza_types
(pizza_type_id PK)

---

# SQL Concepts Used

This project demonstrates:

* Data Cleaning
* Datatype Conversion
* Constraints
* Primary Keys
* Foreign Keys
* Joins
* Views
* Aggregations
* CTEs
* Window Functions
* Ranking Functions
* KPI Analysis
* Time-Series Analysis
* Percentage Contribution Analysis

---

# Business KPIs Analyzed

* Total Revenue
* Total Orders
* Average Order Value
* Best Selling Pizzas
* Highest Revenue Pizzas
* Revenue by Category
* Revenue by Pizza Size
* Monthly Revenue Trends
* Orders by Hour
* Weekday vs Weekend Analysis

---

# Advanced SQL Analytics

Advanced SQL concepts implemented include:

* Common Table Expressions (CTEs)
* DENSE_RANK()
* Window Functions
* Revenue Contribution Analysis
* Ranking Analysis
* Time-Based Analytics


# Key Business Insights

* Weekend sales contribute significantly higher revenue compared to weekdays.
* A small subset of pizzas contributes disproportionately to total revenue.
* Large-sized pizzas generate a major share of business revenue.
* Peak operational demand occurs during evening hours.
* Certain pizza categories dominate overall sales performance.

# Future Scope

The project is designed for future integration with Power BI to create:

* Interactive dashboards
* KPI reporting
* Revenue trend visualizations
* Product performance dashboards
* Operational analytics dashboards

# Tools Used

* MySQL
* MySQL Workbench
* Kaggle Dataset

# Conclusion

This project demonstrates an end-to-end SQL analytics workflow starting from raw CSV data to business insight generation.

The project combines:

* database design
* data cleaning
* analytical SQL
* business KPI reporting
* advanced SQL analytics

to simulate a real-world business analyst workflow using SQL.
 
