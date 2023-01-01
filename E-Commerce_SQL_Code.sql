USE portfolio;
SET SQL_SAFE_UPDATES = 0;
-- --------------------------------------------------------------------------------

-- Because the dataset is so large (over 500,000 rows), we need to manually load
-- the data and NOT utilize the import wizard

-- When initially trying to load the local file, I needed to grant permissions to 
-- my account to be able to load local files. To do this, I first need to open .cmd
-- and log into mysql. Set the path of the mysql server with cd "PATH"
-- Then, log in with mysql.exe -u root -p
-- Input password, and type SET GLOBAL local_infile=1
-- Next, open MySQL Workbench and open portfolio server connections.
-- Under the connections table>advanced>other, type 'OPT_LOCAL_INFILE=1'
-- This should allow local file loading.

-- --------------------------------------------------------------------------------

-- Now, we create the needed tables to load our files into.

-- -------------------------------------------------

CREATE TABLE customers (
	customer_id VARCHAR(255) PRIMARY KEY,
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(255),
    customer_city VARCHAR(255),
	customer_state VARCHAR(255)
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_customers_dataset.csv"
INTO TABLE customers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
;

UPDATE customers
SET customer_id = REPLACE(customer_id, '"', '');

UPDATE customers
SET customer_unique_id = REPLACE(customer_unique_id, '"', '');

UPDATE customers
SET customer_zip_code_prefix = REPLACE(customer_zip_code_prefix, '"', '');

-- ------------------------------------------------

CREATE TABLE geolocation (
	geolocation_zip_code_prefix VARCHAR(255) PRIMARY KEY,
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city VARCHAR(255),
	geolocation_state VARCHAR(255)
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_geolocation_dataset.csv"
INTO TABLE geolocation
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
;

UPDATE geolocation
SET geolocation_zip_code_prefix = REPLACE(geolocation_zip_code_prefix, '"', '');

-- --------------------------------------------------------

CREATE TABLE order_items (
	order_id VARCHAR(255) PRIMARY KEY,
    order_item_id DOUBLE,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
	shipping_limit_date DATETIME,
    price DOUBLE,
    freight_value DOUBLE
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_order_items_dataset.csv"
INTO TABLE order_items
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
;

UPDATE order_items
SET order_id = REPLACE(order_id, '"', '');

UPDATE order_items
SET product_id = REPLACE(product_id, '"', '');

UPDATE order_items
SET seller_id = REPLACE(seller_id, '"', '');
-- --------------------------------------------------------------------

CREATE TABLE order_payments (
	order_id VARCHAR(255) PRIMARY KEY,
    payment_sequential DOUBLE,
    payment_type VARCHAR(255),
    payment_installments DOUBLE,
	payment_value DOUBLE
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_order_payments_dataset.csv"
INTO TABLE order_payments
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(order_id, payment_sequential, payment_type, payment_installments, payment_value)
;

UPDATE order_payments
SET order_id = REPLACE(order_id, '"', '');
-- ------------------------------------------------------------------

CREATE TABLE order_payments (
	order_id VARCHAR(255) PRIMARY KEY,
    payment_sequential DOUBLE,
    payment_type VARCHAR(255),
    payment_installments DOUBLE,
	payment_value DOUBLE
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_order_payments_dataset.csv"
INTO TABLE order_payments
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(order_id, payment_sequential, payment_type, payment_installments, payment_value)
;

UPDATE order_payments
SET order_id = REPLACE(order_id, '"', '');
-- ------------------------------------------------------------------

CREATE TABLE order_reviews (
	review_id VARCHAR(255),
	order_id VARCHAR(255) PRIMARY KEY,
    review_score DOUBLE
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_order_reviews_dataset.csv"
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(review_id, order_id, review_score)
;
-- ----------------------------------------------------------

CREATE TABLE orders (
	order_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255),
    order_status VARCHAR(255),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_orders_dataset.csv"
INTO TABLE orders
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, 
 order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
;

UPDATE orders
SET order_id = REPLACE(order_id, '"', '');

UPDATE orders
SET customer_id = REPLACE(customer_id, '"', '');
-- -----------------------------------------------------------

CREATE TABLE products (
	product_id VARCHAR(255) PRIMARY KEY,
    product_category_name VARCHAR(255),
    product_name_lenght DOUBLE,
    product_description_lenght DOUBLE,
    product_photos_qty DOUBLE,
    product_weight_g DOUBLE,
    product_length_cm DOUBLE,
    product_height_cm DOUBLE,
    product_width_cm DOUBLE
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_products_dataset.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(product_id, product_category_name,	product_name_lenght,	
product_description_lenght,	product_photos_qty,	product_weight_g,
product_length_cm, product_height_cm, product_width_cm
)
;

UPDATE products
SET product_id = REPLACE(product_id, '"', '');
-- --------------------------------------------------------------------------

CREATE TABLE sellers (
	seller_id VARCHAR(255) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(255),
    seller_city VARCHAR(255),
    seller_state VARCHAR(255)
) ;

LOAD DATA LOCAL INFILE "C:/Users/Matth/OneDrive/Desktop/SQL Data/olist_sellers_dataset.csv"
INTO TABLE sellers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(seller_id, seller_zip_code_prefix, seller_city, seller_state)
;

UPDATE sellers
SET seller_id = REPLACE(seller_id, '"', '');

UPDATE sellers
SET seller_zip_code_prefix = REPLACE(seller_zip_code_prefix, '"', '');

-- --------------------------------------------------------------------------------

-- Now we have all the data loaded into seperate files. We have a common primary key,
-- customer_id that we can join these tables together.
CREATE TABLE full_data (
	SELECT *
    FROM orders
	LEFT JOIN customers USING(customer_id)
	LEFT JOIN order_reviews USING(order_id)
	LEFT JOIN order_payments USING(order_id)
    LEFT JOIN order_items USING(order_id)
    WHERE order_status IS NOT NULL
);

CREATE TABLE fuller_data (
	SELECT *
    FROM full_data fd
	LEFT JOIN geolocation gl ON fd.customer_zip_code_prefix = gl.geolocation_zip_code_prefix
	LEFT JOIN products USING(product_id)
	LEFT JOIN sellers USING(seller_id)
);

SET SESSION SQL_MODE='ALLOW_INVALID_DATES';

-- Let's find our how far off estimated deliveries are, and how long it takes for 
-- deliveries from time of purchase to delivering it to the customer

ALTER TABLE orders 
ADD delivery_diff INT;

ALTER TABLE orders 
ADD order_to_delivery INT;

UPDATE orders
SET delivery_diff = DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date),
    order_to_delivery = DATEDIFF(order_delivered_customer_date, order_purchase_timestamp);

DELETE FROM orders WHERE order_status != 'delivered';

CREATE TABLE orders_updated (
SELECT *
FROM orders
);

SELECT 
	*, 
    payment_value / payment_installments AS payment_per_cyce
FROM order_payments

-- ----------------------------------------------------