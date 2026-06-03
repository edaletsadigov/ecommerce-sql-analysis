-- ============================================================
-- 04_bonus_queries.sql
-- Section IV: Bonus Queries
-- Dialect: Oracle SQL
-- ============================================================


-- Bonus 1: Average profit margin (%) by product category
WITH category_summary AS (
    SELECT 
        pl.category,
        SUM(odl.quantity * (pl.unit_price - odl.discount))            AS revenue,
        SUM(odl.quantity * (pl.unit_price - odl.discount - pl.cost_price)) AS profit
    FROM order_details_large odl
    JOIN products_large pl
        ON odl.product_id = pl.product_id
    GROUP BY pl.category
)
SELECT 
    category,
    revenue,
    profit,
    ROUND((profit / revenue) * 100) || '%' AS profit_margin
FROM category_summary
ORDER BY profit_margin DESC;


-- ============================================================
-- Bonus 2: Sales share and detailed metrics by customer age group
-- Concepts used:
--   CASE WHEN → age group categorization
--   SUM() OVER() → percentage share without subquery
--   LEFT JOIN (DISTINCT) → fan-out prevention from returns
--   GROUP BY repeating CASE WHEN → Oracle does not allow aliases in GROUP BY
WITH age_groups AS (
    SELECT 
        CASE
            WHEN cl.age BETWEEN 18 AND 30 THEN 'Young (18-30)'
            WHEN cl.age BETWEEN 31 AND 50 THEN 'Middle-Aged (31-50)'
            WHEN cl.age BETWEEN 51 AND 70 THEN 'Senior (51-70)'
            ELSE 'Other'
        END                                                                    AS age_group,
        COUNT(DISTINCT cl.customer_id)                                         AS customer_count,
        SUM(odl.quantity)                                                      AS total_qty,
        SUM(odl.quantity * (pl.unit_price - odl.discount))                    AS total_revenue,
        SUM(odl.quantity * (pl.unit_price - odl.discount - pl.cost_price))    AS total_profit,
        ROUND(AVG(odl.quantity * (pl.unit_price - odl.discount)), 2)          AS avg_order_value,
        ROUND(AVG(odl.discount), 2)                                            AS avg_discount,
        SUM(CASE WHEN rl.return_id IS NOT NULL THEN odl.quantity ELSE 0 END)  AS returned_qty
    FROM customers_large cl
    JOIN orders_large ol
        ON cl.customer_id = ol.customer_id
    JOIN order_details_large odl
        ON odl.order_id = ol.order_id
    JOIN products_large pl
        ON odl.product_id = pl.product_id
    LEFT JOIN (SELECT DISTINCT order_id, return_id FROM returns_large) rl
        ON odl.order_id = rl.order_id
    GROUP BY 
        CASE
            WHEN cl.age BETWEEN 18 AND 30 THEN 'Young (18-30)'
            WHEN cl.age BETWEEN 31 AND 50 THEN 'Middle-Aged (31-50)'
            WHEN cl.age BETWEEN 51 AND 70 THEN 'Senior (51-70)'
            ELSE 'Other'
        END
)
SELECT 
    age_group,
    customer_count,
    total_qty,
    total_revenue,
    ROUND(total_revenue * 100 / SUM(total_revenue) OVER ()) || '%' AS revenue_share,
    total_profit,
    ROUND(total_profit * 100 / total_revenue) || '%'               AS profit_margin,
    returned_qty,
    ROUND(returned_qty * 100 / total_qty) || '%'                   AS return_rate,
    avg_order_value,
    avg_discount
FROM age_groups
ORDER BY total_revenue DESC;


-- ============================================================
-- Bonus 3: Year-over-year sales growth
-- Concept: LAG() OVER (ORDER BY) — compares current row to previous row
--          artim_faizi = NULL for the first year (no prior year to compare)
WITH yearly AS (
    SELECT 
        TO_CHAR(ol.order_date, 'YYYY')                                        AS year,
        COUNT(DISTINCT ol.customer_id)                                         AS customer_count,
        COUNT(ol.order_id)                                                     AS order_count,
        SUM(odl.quantity)                                                      AS total_qty,
        SUM(odl.quantity * (pl.unit_price - odl.discount))                    AS total_revenue,
        SUM(odl.quantity * (pl.unit_price - odl.discount - pl.cost_price))    AS total_profit
    FROM orders_large ol
    JOIN order_details_large odl
        ON ol.order_id = odl.order_id
    JOIN products_large pl
        ON odl.product_id = pl.product_id
    GROUP BY TO_CHAR(ol.order_date, 'YYYY')
)
SELECT 
    year,
    customer_count,
    order_count,
    total_qty,
    total_revenue,
    total_profit,
    LAG(total_revenue) OVER (ORDER BY year)    AS prev_year_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year))
        / LAG(total_revenue) OVER (ORDER BY year) * 100, 2
    ) || '%'                                   AS yoy_growth
FROM yearly
ORDER BY year;
