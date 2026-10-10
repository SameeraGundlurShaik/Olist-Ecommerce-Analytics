USE olist_ecommerce;


-- =========================================================
-- OLIST E-COMMERCE ANALYSIS
-- FILE: 05_data_analysis.sql
-- =========================================================


-- =========================================================
-- ANALYSIS 1: OVERALL BUSINESS PERFORMANCE
-- =========================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    COUNT(DISTINCT oi.product_id) AS total_products_sold,
    COUNT(DISTINCT oi.seller_id) AS total_sellers,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id;


-- =========================================================
-- ANALYSIS 2: ORDER STATUS DISTRIBUTION
-- =========================================================

SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;


-- =========================================================
-- ANALYSIS 3: MONTHLY SALES TREND
-- =========================================================

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;


-- =========================================================
-- ANALYSIS 4: YEARLY SALES TREND
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;


-- =========================================================
-- ANALYSIS 5: MONTHLY ORDER GROWTH
-- =========================================================

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month;


-- =========================================================
-- ANALYSIS 6: AVERAGE ORDER VALUE
-- =========================================================

SELECT
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT oi.order_id),
        2
    ) AS average_order_value
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');


-- =========================================================
-- ANALYSIS 7: TOP PRODUCT CATEGORIES BY SALES
-- =========================================================

SELECT
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
ORDER BY total_sales DESC
LIMIT 15;


-- =========================================================
-- ANALYSIS 8: TOP PRODUCT CATEGORIES BY NUMBER OF ITEMS
-- =========================================================

SELECT
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
ORDER BY items_sold DESC
LIMIT 15;


-- =========================================================
-- ANALYSIS 9: TOP PRODUCTS BY SALES
-- =========================================================

SELECT
    oi.product_id,
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    oi.product_id,
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
ORDER BY total_sales DESC
LIMIT 20;


-- =========================================================
-- ANALYSIS 10: TOP PRODUCTS BY NUMBER OF SALES
-- =========================================================

SELECT
    oi.product_id,
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    COUNT(*) AS items_sold,
    ROUND(AVG(oi.price), 2) AS average_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    oi.product_id,
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
ORDER BY items_sold DESC
LIMIT 20;


-- =========================================================
-- ANALYSIS 11: CUSTOMER STATE PERFORMANCE
-- =========================================================

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_sales DESC;


-- =========================================================
-- ANALYSIS 12: TOP CUSTOMER CITIES BY SALES
-- =========================================================

SELECT
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_city,
    c.customer_state
ORDER BY total_sales DESC
LIMIT 20;


-- =========================================================
-- ANALYSIS 13: CUSTOMER ORDER FREQUENCY
-- =========================================================

SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
ORDER BY order_count DESC
LIMIT 20;


-- =========================================================
-- ANALYSIS 14: REPEAT CUSTOMER ANALYSIS
-- =========================================================

SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END;


-- =========================================================
-- ANALYSIS 15: AVERAGE ORDERS PER CUSTOMER
-- =========================================================

SELECT
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS average_orders_per_customer
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id;


-- =========================================================
-- ANALYSIS 16: DELIVERY PERFORMANCE
-- =========================================================

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                DATE(order_delivered_customer_date),
                DATE(order_purchase_timestamp)
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL;


-- =========================================================
-- ANALYSIS 17: ESTIMATED VS ACTUAL DELIVERY
-- =========================================================

SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM orders
            WHERE order_status = 'delivered'
              AND order_delivered_customer_date IS NOT NULL
              AND order_estimated_delivery_date IS NOT NULL
        ),
        2
    ) AS percentage
FROM orders
WHERE
    order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
GROUP BY
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END;


-- =========================================================
-- ANALYSIS 18: AVERAGE DELIVERY DAYS BY STATE
-- =========================================================

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(
        AVG(
            DATEDIFF(
                DATE(o.order_delivered_customer_date),
                DATE(o.order_purchase_timestamp)
            )
        ),
        2
    ) AS average_delivery_days
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;


-- =========================================================
-- ANALYSIS 19: REVIEW SCORE DISTRIBUTION
-- =========================================================

SELECT
    review_score,
    COUNT(*) AS review_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reviews),
        2
    ) AS percentage
FROM reviews
GROUP BY review_score
ORDER BY review_score;


-- =========================================================
-- ANALYSIS 20: AVERAGE REVIEW SCORE
-- =========================================================

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM reviews
WHERE review_score IS NOT NULL;


-- =========================================================
-- ANALYSIS 21: REVIEW SCORE BY ORDER STATUS
-- =========================================================

SELECT
    o.order_status,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
GROUP BY o.order_status
ORDER BY average_review_score DESC;


-- =========================================================
-- ANALYSIS 22: DELIVERY STATUS VS REVIEW SCORE
-- =========================================================

SELECT
    CASE
        WHEN o.order_delivered_customer_date <=
             o.order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY
    CASE
        WHEN o.order_delivered_customer_date <=
             o.order_estimated_delivery_date
            THEN 'On Time'
        ELSE 'Late'
    END;


-- =========================================================
-- ANALYSIS 23: PAYMENT METHOD DISTRIBUTION
-- =========================================================

SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- =========================================================
-- ANALYSIS 24: PAYMENT INSTALLMENT ANALYSIS
-- =========================================================

SELECT
    payment_installments,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_installments
ORDER BY payment_installments;


-- =========================================================
-- ANALYSIS 25: SELLER PERFORMANCE
-- =========================================================

SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_state
ORDER BY total_sales DESC
LIMIT 20;


-- =========================================================
-- ANALYSIS 26: SELLER STATE PERFORMANCE
-- =========================================================

SELECT
    s.seller_state,
    COUNT(DISTINCT s.seller_id) AS total_sellers,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY total_sales DESC;


-- =========================================================
-- ANALYSIS 27: FREIGHT VALUE BY CATEGORY
-- =========================================================

SELECT
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(AVG(oi.freight_value), 2) AS average_freight
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
ORDER BY total_freight DESC
LIMIT 15;


-- =========================================================
-- ANALYSIS 28: PRICE VS FREIGHT VALUE
-- =========================================================

SELECT
    CASE
        WHEN oi.price < 50 THEN 'Below 50'
        WHEN oi.price < 100 THEN '50 - 99'
        WHEN oi.price < 200 THEN '100 - 199'
        WHEN oi.price < 500 THEN '200 - 499'
        ELSE '500+'
    END AS price_range,
    COUNT(*) AS items_sold,
    ROUND(AVG(oi.freight_value), 2) AS average_freight,
    ROUND(AVG(oi.price), 2) AS average_price
FROM order_items oi
GROUP BY
    CASE
        WHEN oi.price < 50 THEN 'Below 50'
        WHEN oi.price < 100 THEN '50 - 99'
        WHEN oi.price < 200 THEN '100 - 199'
        WHEN oi.price < 500 THEN '200 - 499'
        ELSE '500+'
    END
ORDER BY
    MIN(oi.price);


-- =========================================================
-- ANALYSIS 29: ORDERS BY DAY OF WEEK
-- =========================================================

SELECT
    DAYNAME(order_purchase_timestamp) AS day_of_week,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    DAYOFWEEK(order_purchase_timestamp),
    DAYNAME(order_purchase_timestamp)
ORDER BY DAYOFWEEK(order_purchase_timestamp);


-- =========================================================
-- ANALYSIS 30: ORDERS BY HOUR
-- =========================================================

SELECT
    HOUR(order_purchase_timestamp) AS purchase_hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY HOUR(order_purchase_timestamp)
ORDER BY purchase_hour;


-- =========================================================
-- ANALYSIS 31: TOP CATEGORIES BY REVIEW SCORE
-- =========================================================

SELECT
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
JOIN reviews r
    ON oi.order_id = r.order_id
GROUP BY
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
HAVING COUNT(r.review_id) >= 50
ORDER BY average_review_score DESC
LIMIT 15;


-- =========================================================
-- ANALYSIS 32: LOW-RATED PRODUCT CATEGORIES
-- =========================================================

SELECT
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
JOIN reviews r
    ON oi.order_id = r.order_id
GROUP BY
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
HAVING COUNT(r.review_id) >= 50
ORDER BY average_review_score ASC
LIMIT 15;


-- =========================================================
-- ANALYSIS 33: SALES BY CUSTOMER STATE AND CATEGORY
-- =========================================================

SELECT
    c.customer_state,
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    c.customer_state,
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
ORDER BY total_sales DESC
LIMIT 30;


-- =========================================================
-- ANALYSIS 34: YEARLY CUSTOMER GROWTH
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    COUNT(DISTINCT c.customer_unique_id) AS unique_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY order_year;


-- =========================================================
-- ANALYSIS 35: TOP 20 ORDERS BY ORDER VALUE
-- =========================================================

SELECT
    oi.order_id,
    ROUND(SUM(oi.price), 2) AS order_value,
    COUNT(*) AS item_count
FROM order_items oi
GROUP BY oi.order_id
ORDER BY order_value DESC
LIMIT 20;


-- =========================================================
-- ANALYSIS 36: FINAL BUSINESS SUMMARY
-- =========================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(AVG(oi.price), 2) AS average_item_price,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    ROUND(
        AVG(
            DATEDIFF(
                DATE(o.order_delivered_customer_date),
                DATE(o.order_purchase_timestamp)
            )
        ),
        2
    ) AS average_delivery_days
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';