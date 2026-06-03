-- ============================================================
-- 03_return_analysis.sql
-- Section III: Return Analysis (Tasks 10–12)
-- Dialect: Oracle SQL
-- Tables: ORDER_DETAILS, PRODUCTS, RETURNS
--
-- ⚠️ FAN-OUT WARNING:
-- Joining returns_large directly inflates quantity counts
-- when one order_id has multiple rows in returns_large.
-- Fix: use SELECT DISTINCT order_id subquery before joining.
-- ============================================================


-- Task 10: Return rate by product category
-- Fan-out fix: DISTINCT order_id subquery prevents row multiplication
SELECT 
    pl.category,
    SUM(odl.quantity)                                                            AS total_qty,
    SUM(CASE WHEN rl.order_id IS NOT NULL THEN odl.quantity ELSE 0 END)         AS returned_qty,
    ROUND(
        SUM(CASE WHEN rl.order_id IS NOT NULL THEN odl.quantity ELSE 0 END)
        * 100 / SUM(odl.quantity)
    ) || '%'                                                                     AS return_rate
FROM order_details_large odl
JOIN products_large pl
    ON odl.product_id = pl.product_id
LEFT JOIN (
    SELECT DISTINCT order_id       -- fan-out prevention
    FROM returns_large
) rl ON rl.order_id = odl.order_id
GROUP BY pl.category
ORDER BY pl.category;


-- ============================================================
-- Task 11a: Most returned product overall (top 1)
SELECT 
    pl.category,
    pl.product_name,
    SUM(odl.quantity)                                                            AS total_qty,
    SUM(CASE WHEN rl.order_id IS NOT NULL THEN odl.quantity ELSE 0 END)         AS returned_qty,
    ROUND(
        SUM(CASE WHEN rl.order_id IS NOT NULL THEN odl.quantity ELSE 0 END)
        * 100 / SUM(odl.quantity)
    ) || '%'                                                                     AS return_rate
FROM order_details_large odl
JOIN products_large pl
    ON odl.product_id = pl.product_id
LEFT JOIN (
    SELECT DISTINCT order_id
    FROM returns_large
) rl ON rl.order_id = odl.order_id
GROUP BY pl.category, pl.product_name
ORDER BY returned_qty DESC
FETCH FIRST 1 ROWS ONLY;


-- ============================================================
-- Task 11b: Most returned product per category (top-N per group)
-- Concept: ROW_NUMBER() OVER (PARTITION BY) — classic interview pattern
WITH ranked AS (
    SELECT 
        pl.category,
        pl.product_name,
        SUM(odl.quantity)                                                            AS total_qty,
        SUM(CASE WHEN rl.order_id IS NOT NULL THEN odl.quantity ELSE 0 END)         AS returned_qty,
        ROUND(
            SUM(CASE WHEN rl.order_id IS NOT NULL THEN odl.quantity ELSE 0 END)
            * 100 / SUM(odl.quantity)
        ) || '%'                                                                     AS return_rate,
        ROW_NUMBER() OVER (
            PARTITION BY pl.category
            ORDER BY SUM(CASE WHEN rl.order_id IS NOT NULL THEN odl.quantity ELSE 0 END) DESC
        )                                                                            AS rn
    FROM order_details_large odl
    JOIN products_large pl
        ON odl.product_id = pl.product_id
    LEFT JOIN (
        SELECT DISTINCT order_id
        FROM returns_large
    ) rl ON rl.order_id = odl.order_id
    GROUP BY pl.category, pl.product_name
)
SELECT 
    category,
    product_name,
    total_qty,
    returned_qty,
    return_rate
FROM ranked
WHERE rn = 1
ORDER BY category;


-- ============================================================
-- Task 12: Return reason breakdown with percentage share
-- Concept: scalar subquery for total denominator
WITH reason_summary AS (
    SELECT 
        rl.reason                AS return_reason,
        SUM(odl.quantity)        AS reason_qty,
        (
            SELECT SUM(odl2.quantity)
            FROM returns_large rl2
            JOIN order_details_large odl2
                ON rl2.order_id = odl2.order_id
        )                        AS total_returned
    FROM returns_large rl
    JOIN order_details_large odl
        ON rl.order_id = odl.order_id
    GROUP BY rl.reason
)
SELECT 
    return_reason,
    reason_qty,
    total_returned,
    ROUND(reason_qty * 100 / total_returned) || '%' AS share
FROM reason_summary
ORDER BY reason_qty DESC;
