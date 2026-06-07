# 🐘 PostgreSQL Exploratory Data Analysis (EDA) Project


> A structured, multi-module SQL-based Exploratory Data Analysis project performed on a 5-table relational dataset using PostgreSQL. Covers schema inspection, aggregations, filtering, date functions, joins, subqueries, CTEs, and window functions.

---

## 📌 Project Overview

This project demonstrates a complete EDA workflow in SQL — starting from raw data understanding and progressing to advanced analytical techniques. It simulates the day-to-day work of a **Data Analyst** or **BI Developer** exploring a multi-domain business dataset.

| Attribute | Detail |
|-----------|--------|
| **Database** | PostgreSQL |
| **Tables** | 5 (customers, leads, organizations, people, products) |
| **EDA Modules** | 8 analytical categories |
| **Queries Written** | 50+ |
| **Techniques** | DDL, DQL, Aggregations, Joins, Subqueries, CTEs, Window Functions |

---

## 📂 Dataset Schema

### 1. `customers`
Stores customer contact and subscription information.
- `customer_id`, `first_name`, `last_name`, `company`
- `city`, `country`, `email`, `phone1`, `phone2`
- `subscription_date`, `website`

### 2. `leads`
Sales pipeline data with deal stages and lead sources.
- `account_id`, `lead_owner`, `first_name`, `last_name`
- `company`, `source`, `deal_stage`, `notes`

### 3. `organizations`
Firmographic data about companies.
- `organization_id`, `name`, `country`, `industry`
- `founded`, `number_of_employees`

### 4. `people`
Individual records with demographic and job data.
- `user_id`, `first_name`, `last_name`, `sex`
- `date_of_birth`, `email`, `phone`, `job_title`

### 5. `products`
Product catalog with inventory and pricing.
- `name`, `brand`, `category`, `price`, `stock`
- `color`, `size`, `availability`, `currency`

---

## 🔬 EDA Modules

### Module 1 — Basic Data Overview
**Goal:** Understand table structure, row counts, and value variety before deeper analysis.

```sql
-- Schema inspection (PostgreSQL alternative to DESCRIBE)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'customers';

-- Row counts
SELECT COUNT(*) FROM customers;

-- Distinct value distribution
SELECT country, COUNT(*) AS total_count
FROM customers
GROUP BY country ORDER BY total_count DESC;
```

---

### Module 2 — Aggregations and Summaries
**Goal:** Quantify key fields using aggregate functions.

```sql
-- Average product price and stock
SELECT AVG(price), AVG(stock) FROM products;

-- Total inventory value
SELECT SUM(price), SUM(stock) FROM products;

-- Filter groups by aggregate threshold
SELECT country, industry, SUM(number_of_employees) AS total_employees
FROM organizations
GROUP BY country, industry
HAVING SUM(number_of_employees) > 5000
ORDER BY country, industry;
```

---

### Module 3 — Filtering and Slicing
**Goal:** Isolate targeted subsets of data using WHERE conditions.

```sql
-- Multi-condition filter on leads
SELECT * FROM leads WHERE source = 'Website Form' AND deal_stage = 'Closed Won';

-- Date range for age cohort
SELECT * FROM people WHERE date_of_birth BETWEEN '1980-01-01' AND '2000-01-01';
```

---

### Module 4 — Working with Dates
**Goal:** Extract temporal components and calculate date differences.

```sql
-- Customer tenure in days
SELECT customer_id, (current_date - subscription_date) AS days_since_subscription
FROM customers;

-- Subscription breakdown by year
SELECT EXTRACT(YEAR FROM subscription_date) AS year FROM customers;
```

---

### Module 5 — Conditional Logic and Strings
**Goal:** Transform and enrich raw data with labels and computed fields.

```sql
-- Inventory status labeling
SELECT name, brand, stock,
  CASE
    WHEN stock = 0 THEN 'Out of Stock'
    WHEN stock < 10 THEN 'Low Stock'
    ELSE 'Available'
  END AS stock_status
FROM products;

-- Full name concatenation
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name, email
FROM customers;
```

---

### Module 6 — Joins and Relationships
**Goal:** Combine tables to reveal cross-domain relationships.

| Join Type | Tables | Business Use Case |
|-----------|--------|-------------------|
| INNER JOIN | customers + leads | Customers with matched pipeline records |
| LEFT JOIN | customers + leads | All customers, including those with no lead |
| RIGHT JOIN | people + organizations | All orgs, even without linked person records |
| FULL OUTER JOIN | people + organizations | Complete combined view of both tables |
| CROSS JOIN | products + organizations | Cartesian product of all combinations |
| SELF JOIN | people + people | Pairs of people sharing the same job title |

```sql
-- Self join: People with the same job title
SELECT p1.user_id, p1.first_name AS person1, p2.first_name AS person2, p1.job_title
FROM people p1
INNER JOIN people p2 ON p1.job_title = p2.job_title AND p1.user_id <> p2.user_id;
```

---

### Module 7 — Subqueries and Advanced EDA
**Goal:** Answer nested and complex analytical questions.

```sql
-- Customers in countries with large organizations
SELECT customer_id, first_name, last_name, country FROM customers
WHERE country IN (
  SELECT country FROM organizations WHERE number_of_employees > 5000
);

-- Lead count per customer (scalar subquery)
SELECT c.customer_id, c.first_name,
  (SELECT COUNT(*) FROM leads l WHERE l.account_id = c.customer_id) AS lead_count
FROM customers c;

-- CTE: Products priced below average
WITH avg_price AS (
  SELECT AVG(price) AS overall_avg FROM products
)
SELECT p.name, p.brand, p.price
FROM products p, avg_price
WHERE p.price < avg_price.overall_avg;

-- ROLLUP for hierarchical lead summary
SELECT source, deal_stage, COUNT(*) AS lead_count
FROM leads
GROUP BY ROLLUP (source, deal_stage)
ORDER BY source, deal_stage;
```

---

### Module 8 — Window Functions
**Goal:** Rank, number, and compute running aggregates without collapsing rows.

```sql
-- Running total of price within each product category
SELECT category, name, price,
  SUM(price) OVER (PARTITION BY category ORDER BY price) AS running_total
FROM products;

-- Dense rank organizations by employee count
SELECT organization_id, name, number_of_employees,
  DENSE_RANK() OVER (ORDER BY number_of_employees DESC) AS employee_dense_rank
FROM organizations;

-- Rank deal stages within each lead source
SELECT source, deal_stage, first_name, last_name,
  RANK() OVER (PARTITION BY source ORDER BY deal_stage) AS stage_rank
FROM leads;
```

---

## 🛠️ Skills Demonstrated

| Category | Skills |
|----------|--------|
| **DDL** | CREATE TABLE, data types, PRIMARY KEY, SERIAL |
| **DQL** | SELECT, WHERE, DISTINCT, ORDER BY |
| **Aggregation** | COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING |
| **Date Functions** | EXTRACT, current_date arithmetic |
| **String Functions** | CONCAT, LENGTH, SUBSTRING |
| **Conditional Logic** | CASE WHEN THEN ELSE |
| **Joins** | INNER, LEFT, RIGHT, FULL OUTER, CROSS, SELF |
| **Subqueries** | Correlated, scalar, EXISTS, nested WHERE |
| **Set Operations** | ROLLUP, GROUPING SETS |
| **CTEs** | WITH clause for modular query logic |
| **Window Functions** | OVER, PARTITION BY, RANK, DENSE_RANK, ROW_NUMBER |

---

## 🚀 How to Run

1. **Install PostgreSQL** — [Download here](https://www.postgresql.org/download/)
2. **Create a new database** in pgAdmin or psql:
   ```sql
   CREATE DATABASE eda_project;
   ```
3. **Run the DDL** — Execute the CREATE TABLE statements from `SQL_EDA_project.sql`
4. **Import data** — Load sample CSVs using `\copy` or pgAdmin's import tool
5. **Run the EDA queries** — Execute each module sequentially

---

## 📁 Repository Structure

```
📦 postgresql-eda-project
 ┣ 📄 SQL_EDA_project.sql     # All DDL and EDA queries
 ┣ 📄 README.md               # Project documentation (this file)
 ┗ 📄 EDA_Report.docx         # Detailed technical report
```

---
