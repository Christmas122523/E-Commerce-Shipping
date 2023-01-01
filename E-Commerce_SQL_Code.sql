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

-- --------------------------------------------------------------------------------

-- Table with customer data

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

-- Need to remove quotes from some columns, as they begin with numbers on occasion but we want to save as strings. We'll do this numerous times throughout reading in the data.

UPDATE customers
SET customer_id = REPLACE(customer_id, '"', '');

UPDATE customers
SET customer_unique_id = REPLACE(customer_unique_id, '"', '');

UPDATE customers
SET customer_zip_code_prefix = REPLACE(customer_zip_code_prefix, '"', '');

-- --------------------------------------------------------------------------------

-- Table with geolocations

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

-- --------------------------------------------------------------------------------

-- Table with items that can be ordered

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

-- --------------------------------------------------------------------------------

-- Table with type of payments for orders

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

-- --------------------------------------------------------------------------------

-- Table with product reviews

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

-- --------------------------------------------------------------------------------

-- Table with orders made by customers

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

-- We're largely interested in how long (in days) it takes to deliver a product, and how far off the delivery is to the predicted delivery date. 

-- We'll create delivery_diff to account for how far off (in days) our delivery was compared to the predicted delivery time.

ALTER TABLE orders 
ADD delivery_diff INT;

-- order_to_delivery will account for (in days) how long it took to deliver an item.

ALTER TABLE orders 
ADD order_to_delivery INT;

-- Now we'll update our orders table to have this variables

UPDATE orders
SET delivery_diff = DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date),
    order_to_delivery = DATEDIFF(order_delivered_customer_date, order_purchase_timestamp);

-- And we're really only interested in delivered orders, so we'll remove the others.

DELETE FROM orders WHERE order_status != 'delivered';

-- --------------------------------------------------------------------------------

-- Table with the list of potential products 

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

-- --------------------------------------------------------------------------------

-- Table with potential sellers

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

-- Some tables have common Primary Keys, some do not. We'll need to create multiple tabels and join them, but we eventually will get a full dataset given each table
-- can be connected by some Primary Key (just not all at once).

CREATE TABLE full_data (
	SELECT *
    FROM orders
	LEFT JOIN customers USING(customer_id)
	LEFT JOIN order_reviews USING(order_id)
	LEFT JOIN order_payments USING(order_id)
    LEFT JOIN order_items USING(order_id)
    WHERE order_status IS NOT NULL
);

-- Now we're going to join the remaining tables on difference primary keys.

CREATE TABLE fuller_data (
	SELECT *
    FROM full_data fd
	LEFT JOIN geolocation gl ON fd.customer_zip_code_prefix = gl.geolocation_zip_code_prefix
	LEFT JOIN products USING(product_id)
	LEFT JOIN sellers USING(seller_id)
);

-- Given some dates are 0000-00-00, we need to allow invalid dates in order to make those date s null

SET SESSION SQL_MODE='ALLOW_INVALID_DATES';

-- We also need configure our GROUP BY command to allow certain groupings 

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


-- -------------------------------------------------------------------------------------------------------

-- Now we can start to analyze our deliveries in our full data to try and find some interesting information.

-- What five sellers have the worst time to delivery, and what city are they from?

SELECT 
	seller_id, 
    order_to_delivery, 
    seller_city,
    SUM(order_to_delivery) / COUNT(seller_id) AS average_order_time
FROM fuller_data
GROUP BY seller_id
ORDER BY average_order_time DESC
LIMIT 5;

-- Which 5 product categories have the best and worst delivery times, 
-- what is their weight, length, height and width, and difference in delivery prediction time?

SELECT 
	product_weight_g,
    product_height_cm,
    product_length_cm,
    product_width_cm,
    product_category_name,
    order_to_delivery,
    delivery_diff,
    SUM(order_to_delivery) / COUNT(product_category_name) AS average_order_time,
    SUM(delivery_diff) / COUNT(product_category_name) AS average_delivery_diff
FROM fuller_data
GROUP BY product_category_name
ORDER BY average_order_time DESC
LIMIT 5;

SELECT 
	product_weight_g,
    product_height_cm,
    product_length_cm,
    product_width_cm,
    product_category_name,
    order_to_delivery,
    delivery_diff,
    SUM(order_to_delivery) / COUNT(product_category_name) AS average_order_time,
    SUM(delivery_diff) / COUNT(product_category_name) AS average_delivery_diff
FROM fuller_data
GROUP BY product_category_name
ORDER BY average_order_time ASC
LIMIT 5;

-- Which zipcodes have the longest time to delivery a product, and the most inaccurate product 
-- delivery times? What state and city are they in?

SELECT 
    SUM(order_to_delivery) / COUNT(geolocation_zip_code_prefix) AS average_order_time,
    SUM(delivery_diff) / COUNT(geolocation_zip_code_prefix) AS average_delivery_diff,
    geolocation_zip_code_prefix,
    geolocation_city,
    geolocation_state
FROM fuller_data
GROUP BY geolocation_zip_code_prefix
ORDER BY average_order_time DESC
LIMIT 15;

-- What is the average order_to_delivery and delivery_diff for each possible review score (1-5)

SELECT 
    SUM(order_to_delivery) / COUNT(review_score) AS average_order_time,
    SUM(ABS(delivery_diff)) / COUNT(review_score) AS average_delivery_diff,
    review_score
FROM fuller_data
GROUP BY review_score
ORDER BY average_order_time DESC;

-- What is the top 10 average review scores for each product category, and how many reviews did each product obtain? What is the average price of these product categories?

SELECT 
    SUM(review_score) / COUNT(review_score) AS average_review_score,
    product_category_name,
    COUNT(review_score) AS number_of_reviews,
    AVG(price) AS average_price
FROM fuller_data
GROUP BY product_category_name
ORDER BY average_review_score DESC
LIMIT 10;



-- ----------------------------------------------------