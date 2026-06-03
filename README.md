# ecommerce-sql-analysis
E-Commerce Sales Analysis using Oracle SQL — customer behavior, product performance, return analysis


# 🛒 E-Commerce Sales Analysis — SQL Project

**Author:** Adalat Sadiqov  
**Date:** May 2026  
**Environment:** Oracle SQL | freesqltry.com  

---

## 📋 Project Overview

This project analyzes e-commerce sales data using SQL to understand customer behavior, product performance, revenue trends, and return patterns. Results are visualized in a PowerPoint presentation.

---

## 🗂️ Repository Structure

```
ecommerce-sql-analysis/
│
├── README.md                      ← Project overview (this file)
│
├── data/
│   └── schema.md                  ← Table structure and column descriptions
│
├── sql/
│   ├── 01_sales_metrics.sql       ← Sales indicators (Tasks 1–6)
│   ├── 02_discount_payment.sql    ← Discount & payment analysis (Tasks 7–9)
│   ├── 03_return_analysis.sql     ← Return analysis (Tasks 10–12)
│   └── 04_bonus_queries.sql       ← Bonus queries
│
├── analysis/
│   └── insights.md                ← Business insights from each query
│
└── presentation/
    └── ecommerce_analiz.pptx      ← PowerPoint presentation
```

---

## 🗃️ Tables Used

| Table | Description |
|---|---|
| `CUSTOMERS` | Customer data (name, age, city, registration date) |
| `ORDERS` | Order data (date, payment method, status) |
| `ORDER_DETAILS` | Order line items (product, quantity, discount) |
| `PRODUCTS` | Product data (price, cost, category) |
| `RETURNS` | Return data (date, reason) |

### Table Relationships

```
CUSTOMERS ──< ORDERS ──< ORDER_DETAILS >── PRODUCTS
                  │
                  └──< RETURNS
```

---

## 📊 Analysis Sections

### I. Sales Metrics
- Total sales revenue
- Monthly sales trend
- Revenue, cost, and profit per product
- Top 5 products by revenue
- Top 5 customers by revenue
- Sales and order count by city

### II. Discount & Payment Analysis
- Discounted vs non-discounted orders
- Sales breakdown by payment method
- Cancelled vs completed order ratio

### III. Return Analysis
- Return rate by product category
- Most returned product overall and per category
- Return reason breakdown

### IV. Bonus Queries
- Average profit margin by category
- Sales share by customer age group
- Year-over-year sales growth

---

## 🔑 Key Findings

| Metric | Value |
|---|---|
| Total Revenue | $2,367,915 |
| Total Orders | 1,000 |
| Monthly Average Sales | $197,326 |
| Overall Return Rate | 20.5% |
| Peak Sales Month | July ($275,568) |
| Most Problematic Category | Home (26% return rate) |
| #1 Return Reason | Customer Dissatisfaction (39%) |

---

## 💡 Key SQL Concepts Used

| Concept | Where Applied |
|---|---|
| `JOIN` (INNER, LEFT) | All queries — multi-table analysis |
| `GROUP BY` + Aggregates | Sales totals, counts, averages |
| `HAVING` | Filtering aggregated results |
| `CASE WHEN` | Categorization (age groups, discount status) |
| `CTE` (WITH clause) | Complex multi-step queries |
| `ROW_NUMBER() OVER` | Top-N per group (most returned per category) |
| `LAG() OVER` | Year-over-year growth comparison |
| `SUM() OVER` | Running totals and percentage share |
| Subqueries | Fan-out prevention, scalar aggregates |

---

## ⚠️ Technical Notes

**Operator Precedence — Critical:**
```sql
-- WRONG: discount subtracted once regardless of quantity
quantity * unit_price - discount

-- CORRECT: discount applied per unit
quantity * (unit_price - discount)
```

**Fan-out Prevention — returns_large JOIN:**
```sql
-- WRONG: inflates quantity counts
LEFT JOIN returns_large rl ON rl.order_id = odl.order_id

-- CORRECT: deduplicate before joining
LEFT JOIN (SELECT DISTINCT order_id FROM returns_large) rl
    ON rl.order_id = odl.order_id
```

**JOIN Selection:**
- `INNER JOIN` — only rows with matches in all tables
- `LEFT JOIN` — all rows from left table, NULLs where no match

---

## 🛠️ How to Use

1. Read `data/schema.md` to understand the data model
2. Run SQL files in order (`01` → `04`)
3. Read `analysis/insights.md` for business interpretation of each result
4. Open `presentation/ecommerce_analiz.pptx` for the full visual report

---

## 👤 Author

**Adalat Sadiqov**  
Junior Data Analyst | Baku, Azerbaijan
