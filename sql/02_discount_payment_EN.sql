-- ============================================================
-- 02_discount_payment.sql
-- Section II: Discount & Payment Analysis (Tasks 7–9)
-- Dialect: Oracle SQL
-- Tables: ORDER_DETAILS, ORDERS, PRODUCTS
-- ============================================================


-- Task 7: Discount impact on sales — discounted vs non-discounted orders
-- Filter: completed orders only
-- Concept: CASE WHEN grouping, conditional aggregation
SELECT 
    CASE 
        WHEN odl.discount > 0 THEN 'DISCOUNTED'
        ELSE 'NON-DISCOUNTED'
    END                                                            AS discount_status,
    COUNT(odl.order_id)                                            AS order_count,
    ROUND(SUM(odl.quantity * (pl.unit_price - odl.discount)), 2)  AS total_sales,
    ROUND(AVG(odl.quantity * (pl.unit_price - odl.discount)), 2)  AS avg_sales,
    ROUND(AVG(odl.discount), 2)                                    AS avg_discount
FROM order_details_large odl
JOIN orders_large ol
    ON odl.order_id = ol.order_id
JOIN products_large pl
    ON odl.product_id = pl.product_id
WHERE LOWER(ol.status) = 'completed'
GROUP BY 
    CASE 
        WHEN odl.discount > 0 THEN 'DISCOUNTED'
        ELSE 'NON-DISCOUNTED'
    END;


-- ============================================================
-- Task 8: Sales breakdown by payment method
-- Concept: SUM(COUNT(*)) OVER() — window function for percentage share
SELECT 
    ol.payment_method,
    COUNT(odl.order_id)                                              AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) || '%'       AS percentage
FROM orders_large ol
JOIN order_details_large odl
    ON ol.order_id = odl.order_id
GROUP BY ol.payment_method
ORDER BY order_count DESC;


-- ============================================================
-- Task 9: Ratio of cancelled, completed, and returned orders
-- Concept: SUM(COUNT()) OVER() — total denominator for percentage
SELECT
    ol.status,
    COUNT(odl.order_id)                                                       AS order_count,
    ROUND(COUNT(odl.order_id) * 100.0 / SUM(COUNT(odl.order_id)) OVER (), 2) AS percentage
FROM order_details_large odl
JOIN orders_large ol
    ON odl.order_id = ol.order_id
WHERE LOWER(ol.status) IN ('cancelled', 'completed', 'returned')
GROUP BY ol.status
ORDER BY ol.status;
