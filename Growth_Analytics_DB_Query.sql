CREATE DATABASE SQL_Test;


DROP DATABASE IF EXISTS SQL_Test;


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  "id" INT,
  "city" VARCHAR(3),
  "start_time" DATETIME,
  "end_time" DATETIME,
  "total_cost_eur" INT,
  "customer_id" INT,
  "store_id" INT
);

INSERT INTO orders
  ("id", "city", "start_time", "end_time", "total_cost_eur", "customer_id", "store_id")
VALUES
  ('87235', 'MAD', '1/4/2022 12:23:17', '1/4/2022 12:52:05', '24', '1532', '345'),
  ('87236', 'BCN', '1/4/2022 23:23:48', '1/4/2022 23:45:24', '16', '876563', '3321');
  
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  "id" INT,
  "sign_up_time" DATETIME,
  "preferred_city" VARCHAR(3),
  "is_prime" VARCHAR(50)
);

INSERT INTO customers
  ("id", "sign_up_time", "preferred_city", "is_prime")
VALUES
  ('6543', '7/30/2017 7:54:42', 'MAD', 'FALSE' ),
  ('6544', '9/2/2018 13:23:04', 'GRA', 'TRUE');
  
  
DROP TABLE IF EXISTS stores;
CREATE TABLE stores (
  "id" INT,
  "creation_time" DATETIME,
  "is_food" VARCHAR(50),
  "top_store" VARCHAR(50),
  "store_name" VARCHAR(50),
  "city" VARCHAR(3)
);

INSERT INTO stores
  ("id", "creation_time", "is_food", "top_store", "store_name", "city")
VALUES
  ('420', '4/13/2019 12:00:00', 'TRUE' , 'FALSE', 'Burger Queen', 'TAR'),
  ('421', '4/13/2019 12:15:02', 'TRUE', 'TRUE', 'McDouglas', 'CAN');

DROP TABLE IF EXISTS order_products;
  CREATE TABLE order_products (
  "order_id" INT,
  "product_id" INT
);

INSERT INTO order_products
  ("order_id", "product_id")
VALUES
  ('534231', '8765432'),
  ('534231', '12343'),
  ('534232', '6543221');