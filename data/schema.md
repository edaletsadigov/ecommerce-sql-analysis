# 🗃️ Database Schema

## Overview

The dataset consists of 5 related tables representing a retail e-commerce operation. All queries in this project are written in **Oracle SQL**.

---

## CUSTOMERS

| Column | Type | Description |
|---|---|---|
| customer_id | VARCHAR | Unique customer identifier |
| full_name | VARCHAR | Customer's full name |
| gender | VARCHAR | Gender (Male / Female) |
| age | NUMBER | Customer age |
| city | VARCHAR | City of residence |
| registration_date | DATE | Account registration date |

---

## PRODUCTS

| Column | Type | Description |
|---|---|---|
| product_id | VARCHAR | Unique product identifier |
| product_name | VARCHAR | Product name |
| category | VARCHAR | Category (Books / Clothing / Electronics / Home / Toys) |
| unit_price | NUMBER | Selling price per unit |
| cost_price | NUMBER | Cost price per unit |

---

## ORDERS

| Column | Type | Description |
|---|---|---|
| order_id | VARCHAR | Unique order identifier |
| customer_id | VARCHAR | Customer ID (FK → CUSTOMERS) |
| order_date | DATE | Date the order was placed |
| payment_method | VARCHAR | Payment method (Cash / Card / Transfer) |
| status | VARCHAR | Order status (Completed / Cancelled / Returned) |

---

## ORDER_DETAILS

| Column | Type | Description |
|---|---|---|
| order_id | VARCHAR | Order ID (FK → ORDERS) |
| product_id | VARCHAR | Product ID (FK → PRODUCTS) |
| quantity | NUMBER | Units ordered |
| discount | NUMBER | Discount amount per unit |

---

## RETURNS

| Column | Type | Description |
|---|---|---|
| return_id | VARCHAR | Unique return identifier |
| order_id | VARCHAR | Order ID (FK → ORDERS) |
| product_id | VARCHAR | Product ID |
| return_date | DATE | Date the item was returned |
| reason | VARCHAR | Return reason (Defective / Wrong Item / Customer Dissatisfaction) |

---

## Entity-Relationship Diagram

```
CUSTOMERS
    │ customer_id
    │
    └──< ORDERS
              │ order_id
              │
              ├──< ORDER_DETAILS >── PRODUCTS
              │                         product_id
              │
              └──< RETURNS
```

---

## Revenue Formula

```sql
-- Net revenue per line item
quantity * (unit_price - discount)

-- Profit per line item
quantity * (unit_price - discount - cost_price)

-- IMPORTANT: operator precedence
-- WRONG  → quantity * unit_price - discount   (discount subtracted once)
-- CORRECT → quantity * (unit_price - discount) (discount per unit)
```

---

## Key Metrics Reference

| Metric | Formula |
|---|---|
| Net Revenue | `SUM(quantity * (unit_price - discount))` |
| Total Cost | `SUM(quantity * cost_price)` |
| Profit | `SUM(quantity * (unit_price - discount - cost_price))` |
| Profit Margin % | `ROUND(profit / revenue * 100)` |
| Return Rate % | `returned_qty / total_qty * 100` |
| Revenue Share % | `group_revenue / SUM(group_revenue) OVER() * 100` |
