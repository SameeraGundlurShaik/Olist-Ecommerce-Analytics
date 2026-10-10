USE olist_ecommerce;


-- =========================================================
-- OLIST E-COMMERCE DATA LOADING
-- FINAL CLEAN VERSION
-- =========================================================


-- =========================================================
-- STEP 1: TEMPORARILY DISABLE SAFE UPDATE MODE
-- =========================================================

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;


-- =========================================================
-- STEP 2: FIX GEOLOCATION DATA TYPES
-- =========================================================
-- Latitude and longitude need DOUBLE because the original
-- dataset contains decimal values with high precision.

ALTER TABLE geolocation
MODIFY COLUMN geolocation_lat DOUBLE NULL;

ALTER TABLE geolocation
MODIFY COLUMN geolocation_lng DOUBLE NULL;


-- =========================================================
-- STEP 3: RELOAD CUSTOMERS
-- =========================================================

DELETE FROM customers;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_customers_cleaned.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =========================================================
-- STEP 4: RELOAD PRODUCTS
-- =========================================================

DELETE FROM products;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_products_cleaned.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_name_lenght =
        NULLIF(@product_name_lenght, ''),

    product_description_lenght =
        NULLIF(@product_description_lenght, ''),

    product_photos_qty =
        NULLIF(@product_photos_qty, ''),

    product_weight_g =
        NULLIF(@product_weight_g, ''),

    product_length_cm =
        NULLIF(@product_length_cm, ''),

    product_height_cm =
        NULLIF(@product_height_cm, ''),

    product_width_cm =
        NULLIF(@product_width_cm, '');


-- =========================================================
-- STEP 5: RELOAD SELLERS
-- =========================================================

DELETE FROM sellers;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_sellers_cleaned.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =========================================================
-- STEP 6: RELOAD ORDERS
-- =========================================================

DELETE FROM orders;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_orders_cleaned.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp =
        STR_TO_DATE(
            NULLIF(@order_purchase_timestamp, ''),
            '%Y-%m-%d %H:%i:%s'
        ),

    order_approved_at =
        STR_TO_DATE(
            NULLIF(@order_approved_at, ''),
            '%Y-%m-%d %H:%i:%s'
        ),

    order_delivered_carrier_date =
        STR_TO_DATE(
            NULLIF(@order_delivered_carrier_date, ''),
            '%Y-%m-%d %H:%i:%s'
        ),

    order_delivered_customer_date =
        STR_TO_DATE(
            NULLIF(@order_delivered_customer_date, ''),
            '%Y-%m-%d %H:%i:%s'
        ),

    order_estimated_delivery_date =
        STR_TO_DATE(
            NULLIF(@order_estimated_delivery_date, ''),
            '%Y-%m-%d %H:%i:%s'
        );


-- =========================================================
-- STEP 7: RELOAD ORDER ITEMS
-- =========================================================

DELETE FROM order_items;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_order_items_cleaned.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =========================================================
-- STEP 8: RELOAD PAYMENTS
-- =========================================================

DELETE FROM payments;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_order_payments_cleaned.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =========================================================
-- STEP 9: RELOAD REVIEWS
-- =========================================================

DELETE FROM reviews;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_order_reviews_cleaned.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    @review_score,
    review_comment_title,
    review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_score =
        NULLIF(@review_score, ''),

    review_creation_date =
        STR_TO_DATE(
            NULLIF(@review_creation_date, ''),
            '%Y-%m-%d %H:%i:%s'
        ),

    review_answer_timestamp =
        STR_TO_DATE(
            NULLIF(@review_answer_timestamp, ''),
            '%Y-%m-%d %H:%i:%s'
        );


-- =========================================================
-- STEP 10: RELOAD GEOLOCATION
-- =========================================================

DELETE FROM geolocation;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/olist_geolocation_cleaned.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @geolocation_zip_code_prefix,
    @geolocation_lat,
    @geolocation_lng,
    geolocation_city,
    geolocation_state
)
SET
    geolocation_zip_code_prefix =
        NULLIF(@geolocation_zip_code_prefix, ''),

    geolocation_lat =
        NULLIF(@geolocation_lat, ''),

    geolocation_lng =
        NULLIF(@geolocation_lng, '');


-- =========================================================
-- STEP 11: RELOAD CATEGORY TRANSLATION
-- =========================================================

DELETE FROM category_translation;

LOAD DATA LOCAL INFILE
'C:/Users/Sameera/OneDrive/Desktop/Olist_Ecommerce_Analytics/data/cleaned/product_category_name_translation_cleaned.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =========================================================
-- STEP 12: TURN SETTINGS BACK ON
-- =========================================================

SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;


-- =========================================================
-- STEP 13: FINAL ROW COUNT CHECK
-- =========================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'reviews', COUNT(*)
FROM reviews

UNION ALL

SELECT 'geolocation', COUNT(*)
FROM geolocation

UNION ALL

SELECT 'category_translation', COUNT(*)
FROM category_translation;


-- =========================================================
-- STEP 14: CHECK GEOLOCATION DATA
-- =========================================================

SELECT
    COUNT(*) AS geolocation_rows,
    MIN(geolocation_lat) AS min_latitude,
    MAX(geolocation_lat) AS max_latitude,
    MIN(geolocation_lng) AS min_longitude,
    MAX(geolocation_lng) AS max_longitude
FROM geolocation;


-- =========================================================
-- STEP 15: SAMPLE CHECK
-- =========================================================

SELECT *
FROM geolocation
LIMIT 10;