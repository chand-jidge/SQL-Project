# SQL-Project
This project focuses on analyzing a zepto inventory dataset, involving data cleaning, preprocessing, and solving bussiness-driven questions. The analysis aims to uncover insights related to product availability, pricing, and inventory trends to support better business decision-making.


Here is some highlighted business queries of my project:


Q) find the price per gram for product above 100g and sort by best value

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

Q) group the products into category like low, medium, bulk

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

Q) what is the total inventory weight per category

SELECT 
    category,
    SUM(weightingrams * availablequantity) AS total_weight
FROM
    zepto
GROUP BY category
ORDER BY total_weight;

Q) what is the potential revenue loss due to out of stock products

SELECT 
    name,
    SUM(disscountedsellingprice * quantity) AS revenue_loss
FROM
    zepto
WHERE
    outofstock = 'true'
GROUP BY name;
 
Q) which products are heavily discounted 

SELECT 
    name,
    mrp,
    disscountedsellingprice,
    (mrp - disscountedsellingprice) AS disscounted_price
FROM
    zepto
ORDER BY disscounted_price DESC
LIMIT 10
