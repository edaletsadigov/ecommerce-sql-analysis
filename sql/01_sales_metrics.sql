-- ============================================================
-- 01_sales_metrics.sql
-- Section I: Sales Metrics (Tasks 1–6)
-- Dialect: Oracle SQL
-- Tables: ORDER_DETAILS, ORDERS, PRODUCTS, CUSTOMERS
-- ============================================================


-- Task 1: Total sales revenue
-- Formula: quantity * (unit_price - discount)
-- Note: parentheses required — discount applied per unit, not per row
SELECT 
    SUM(odl.quantity * (pl.unit_price - odl.discount)) AS total_sales
FROM order_details_large odl
JOIN products_large pl
    ON odl.product_id = pl.product_id;


-- ============================================================
-- Task 2: Sales amount and order count by month
-- Note: GROUP BY includes month number for correct chronological sorting
--       INITCAP formats month name (january → January)
SELECT
    INITCAP(TO_CHAR(ol.order_date, 'Month'))            AS month_name,
    COUNT(odl.order_id)                                  AS order_count,
    SUM(odl.quantity * (pl.unit_price - odl.discount))  AS total_sales
FROM order_details_large odl
JOIN orders_large ol
    ON odl.order_id = ol.order_id
JOIN products_large pl
    ON odl.product_id = pl.product_id
GROUP BY 
    TO_CHAR(ol.order_date, 'Month'),
    TO_NUMBER(TO_CHAR(ol.order_date, 'MM'))
ORDER BY 
    TO_NUMBER(TO_CHAR(ol.order_date, 'MM'));


-- ============================================================
-- Task 3: Revenue, cost, and profit per product
SELECT 
    pl.product_id,
    pl.product_name,
    SUM(odl.quantity * (pl.unit_price - odl.discount))                 AS revenue,
    SUM(odl.quantity * pl.cost_price)                                   AS cost,
    SUM(odl.quantity * (pl.unit_price - odl.discount - pl.cost_price)) AS profit
FROM order_details_large odl
JOIN products_large pl
    ON odl.product_id = pl.product_id
GROUP BY pl.product_id, pl.product_name
ORDER BY revenue DESC;


-- ============================================================
-- Task 4: Top 5 products by revenue
SELECT 
    pl.product_id,
    pl.product_name,
    SUM(odl.quantity * (pl.unit_price - odl.discount)) AS revenue
FROM order_details_large odl
JOIN products_large pl
    ON odl.product_id = pl.product_id
GROUP BY pl.product_id, pl.product_name
ORDER BY revenue DESC
FETCH FIRST 5 ROWS ONLY;


-- ============================================================
-- Task 5: Top 5 customers by revenue
-- Note: Sorted by revenue, NOT by quantity
--       Quantity != Revenue — a high-quantity customer may generate low revenue
SELECT 
    cl.customer_id,
    cl.full_name,
    COUNT(odl.order_id)                                AS order_count,
    SUM(odl.quantity)                                  AS total_quantity,
    SUM(odl.quantity * (pl.unit_price - odl.discount)) AS revenue
FROM order_details_large odl
JOIN orders_large ol
    ON odl.order_id = ol.order_id
JOIN customers_large cl
    ON ol.customer_id = cl.customer_id
JOIN products_large pl
    ON odl.product_id = pl.product_id
GROUP BY cl.customer_id, cl.full_name
ORDER BY revenue DESC
FETCH FIRST 5 ROWS ONLY;


-- ============================================================
-- Task 6: Total sales and order count by city
-- Note: INNER JOIN — only cities with at least one order appear
--       LEFT JOIN would include cities with no orders (NULL sales)
SELECT
    cl.city,
    COUNT(DISTINCT ol.order_id)                        AS order_count,
    SUM(odl.quantity * (pl.unit_price - odl.discount)) AS total_sales
FROM customers_large cl
JOIN orders_large ol
    ON cl.customer_id = ol.customer_id
JOIN order_details_large odl
    ON ol.order_id = odl.order_id
JOIN products_large pl
    ON odl.product_id = pl.product_id
GROUP BY cl.city
ORDER BY total_sales DESC;
