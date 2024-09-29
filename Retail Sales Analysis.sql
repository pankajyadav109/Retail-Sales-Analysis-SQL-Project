-- Create database

CREATE DATABASE p1_retail_db;

USE p1_retail_db;

-- Create table

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE NULL,	
    sale_time TIME NULL,
    customer_id INT NULL,	
    gender VARCHAR(10) NULL,
    age INT NULL ,
    category VARCHAR(35) NULL,
    quantity INT NULL,
    price_per_unit FLOAT NULL,	
    cogs FLOAT NULL,
    total_sale FLOAT NULL
);

SELECT * FROM retail_sales;

-- DATA CLEANING

SELECT * FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR gender IS NULL
		OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR gender IS NULL
		OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
 
-- DATA EXPLORATION

-- How many sales we have?
SELECT count(*) FROM retail_sales;

-- How many unique category we have?
SELECT count(DISTINCT customer_id) FROM retail_sales;

-- How many unique category we have?
SELECT DISTINCT category FROM retail_sales;

-- DATA ANALYSIS & KEY BUSINESS PROBLEMS & ANSWER

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT *
FROM retail_sales
WHERE
    sale_date = '2022-11-05';


-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.

SELECT *
FROM retail_sales
WHERE
    category = 'Clothing'
        AND YEAR(sale_date) = '2022'
        AND MONTH(sale_date) = '11'
        AND quantity >= 4;


-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, SUM(total_sale) AS Total_sales
FROM retail_sales
GROUP BY category;


-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT round(AVG(age), 2) AS Avg_age_of_customers
FROM retail_sales
WHERE category = 'Beauty';


-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;


-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, COUNT(transactions_id) AS Num_of_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

WITH CTE AS(
SELECT year(sale_date) AS Year, month(sale_date) AS Month, ROUND(AVG(total_sale), 2) AS Avg_sale,
RANK () OVER(PARTITION BY year(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
FROM retail_sales
GROUP BY month(sale_date), year(sale_date)
)
SELECT Year, Month
FROM CTE
WHERE rnk = 1;


-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id, SUM(total_sale) AS Total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY Total_sales DESC
LIMIT 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT customer_id) Num_of_unique_customers
FROM retail_sales
GROUP BY category;


-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

WITH CTE AS(
SELECT *,
	CASE 
		WHEN sale_time < '12:00:00' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
        WHEN sale_time > '17:00:00' THEN 'Evening'
	END AS shift
FROM retail_sales
)
SELECT shift, COUNT(transactions_id) AS Num_of_orders
FROM CTE
GROUP BY shift
;


