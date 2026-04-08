drop database if exists zepto_inventory;
create database zepto_inventory;
use zepto_inventory;
drop table if exists zepto;
CREATE TABLE zepto (
    sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(500) NOT NULL,
    mrp FLOAT,
    discountpercent FLOAT,
    availablequantity INT,
    disscountedsellingprice FLOAT,
    weightingrams INT,
    outofstock VARCHAR(5),
    quantity INT
);

-- Data Exploration

-- all table details
SELECT 
    *
FROM
    zepto;

-- count of rows
SELECT 
    COUNT(*)
FROM
    zepto;

-- sample data
SELECT 
    *
FROM
    zepto
LIMIT 10;

-- null values
SELECT 
    *
FROM
    zepto
WHERE
    name IS NULL OR category IS NULL
        OR mrp IS NULL
        OR discountpercent IS NULL
        OR disscountedsellingprice IS NULL
        OR weightingrams IS NULL
        OR outofstock IS NULL
        OR quantity IS NULL;

-- Different product categories
SELECT DISTINCT
    category
FROM
    zepto
ORDER BY category;

-- products in stock vs outof stock
SELECT 
    outofstock, COUNT(sku_id) AS product_count
FROM
    zepto
GROUP BY outofstock;

-- product names present multipul times
SELECT 
    name, COUNT(name) AS product_count
FROM
    zepto
GROUP BY name
HAVING product_count  > 1
ORDER BY product_count DESC;

		              -- OR

SELECT 
    name, COUNT(sku_id) AS product_count
FROM
    zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- data cleaning 

-- products with price = 0
SELECT 
    *
FROM
    zepto
WHERE
    mrp = 0; 
    
-- deleting products where mrp=0
DELETE FROM zepto 
WHERE
    mrp = 0;

-- convert paise to rupees 
UPDATE zepto 
SET 
    mrp = mrp / 100.0,
    disscountedsellingprice = disscountedsellingprice / 100.0;


select mrp,disscountedsellingprice from zepto;

-- Buisness questions solving

-- Q1)Find the top 10 best values product based on the discount percentage.
SELECT DISTINCT
    name, mrp, discountpercent
FROM
    zepto
ORDER BY discountpercent DESC
LIMIT 10;

-- Q2)What are the products with high mrp(>200) but out of stock
SELECT DISTINCT
    name, mrp
FROM
    zepto
WHERE
    outofstock = 'TRUE' AND mrp > 200
ORDER BY mrp DESC;

-- Q3)Calculate estimated revenue from each category
SELECT 
    category,
   round(SUM(disscountedsellingprice * quantity),2) AS estimated_revenue
FROM
    zepto
GROUP BY category
ORDER BY estimated_revenue;

-- Q4)find all products where mrp is greater than 500 and discount is less than 10% 
SELECT DISTINCT
    name, mrp, discountpercent
FROM
    zepto
WHERE
    mrp > 500 AND discountpercent < 10
ORDER BY discountpercent DESC , mrp DESC;

-- Q5) identify the top 5 categoris offering the highest average disscount percentage 
SELECT DISTINCT
    category, ROUND(AVG(discountpercent), 2) AS avg_discount
FROM
    zepto
GROUP BY category
ORDER BY AVG(discountpercent) DESC
LIMIT 5;

-- Q6) find the price per gram for product above 100g and sort by best value
SELECT DISTINCT
    name,
    disscountedsellingprice,
    ROUND((disscountedsellingprice / weightingrams),
            2) AS price_per_gram
FROM
    zepto
WHERE
    weightingrams > 100
ORDER BY price_per_gram;

-- Q7) group the products into category like low, medium, bulk
SELECT 
    CASE
        WHEN weightingrams < 300 THEN 'low'
        WHEN weightingrams < 600 THEN 'medium'
        ELSE 'bulk'
    END AS weight_category,
    count(*) as total_products
FROM
    zepto
GROUP By weight_category;

-- 8) what is the total inventory weight per category 
SELECT 
    category,
    SUM(weightingrams * availablequantity) AS total_weight
FROM
    zepto
GROUP BY category
ORDER BY total_weight;

-- Q9) what is the potential revenue loss due to out of stock products
SELECT 
    name,
    SUM(disscountedsellingprice * quantity) AS revenue_loss
FROM
    zepto
WHERE
    outofstock = 'true'
GROUP BY name;

-- Q10) which products are heavily discounted 
SELECT 
    name,
    mrp,
    disscountedsellingprice,
    (mrp - disscountedsellingprice) AS disscounted_price
FROM
    zepto
ORDER BY disscounted_price DESC
LIMIT 10

