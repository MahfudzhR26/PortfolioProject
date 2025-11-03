-- dataset are imported from mavenanalytics-dataplayground
-- dataset are divided into two tables - menu_items / order_details
USE restaurant_db;

-- View menu_items table
SELECT * FROM menu_items;

-- the number of items on the menu
SELECT COUNT(*) FROM menu_items;

-- the least and most expensive items on the menu
SELECT * FROM menu_items
ORDER BY price;

SELECT * FROM menu_items
ORDER BY price DESC;

-- How many Italian dishes are on the menu?
SELECT COUNT(*) FROM menu_items
WHERE category='Italian';

-- the least and most expensive Italian dishes on the menu
SELECT * FROM menu_items
WHERE category='Italian'
ORDER BY price;

SELECT * FROM menu_items
WHERE category='Italian'
ORDER BY price DESC;

-- number of dishes in each category
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM menu_items
GROUP BY category;


-- the average dish price within each category
SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category;

-- EXPLORE THE ORDERS TABLE

-- View the order_details table
SELECT * FROM order_details;

-- the date range of the table
SELECT MIN(order_date), MAX(order_date)
FROM order_details;

-- How many orders were made within this date range?
SELECT COUNT(DISTINCT order_id) 
FROM order_details;

-- number of items rdered within this date range
SELECT COUNT(*) 
FROM order_details;

-- the orders that had the most number of items
SELECT order_id, COUNT(item_id) AS num_items 
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC;

-- number of orders that had more than 12 items
SELECT COUNT(*) FROM 

(SELECT order_id, COUNT(item_id) AS num_items 
FROM order_details
GROUP BY order_id
HAVING num_items > 12) AS num_orders;

-- Combine the menu_items and order_details tables into a single table
SELECT * FROM menu_items;
SELECT * FROM order_details;


-- combine transaction table into a lookup table
-- using left join to make sure the transaction table on the left and the lookup details will be added to the right.
SELECT *
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id;

-- the least and most ordered items, and the categories they're in
SELECT item_name, category, COUNT(order_details_id) as num_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases;


-- the top 5 orders that spent the most money
SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;


-- the details of the highest spend order. The insights that can be gathered from the details
SELECT order_id, category, COUNT(item_id) AS num_item
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id='440'
GROUP BY order_id, category;
-- the detail shows the highest order is the Italian category food for the highest spend order. Therefore the Italian menu should be keep due to regular order by the highest spend customers


-- view the details of the top 5 highest spend orders. What insights can you gather from
SELECT order_id, category, COUNT(item_id) AS num_item
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1975, 330, 2675)
GROUP BY order_id, category;
-- the detail shows the highest order is the Italian category food for every 5 top spend orders. Therefore the Italian menu should be keep due to regular order by the top 5 highest spend customers

