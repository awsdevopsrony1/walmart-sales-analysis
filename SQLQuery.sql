create database walmart;

select * from [Walmart Sales Data];

select count(*) as total_count
from [Walmart Sales Data];
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--A)Generic Questions
-- Q1. How many distinct cities are present in the dataset?
SELECT COUNT(distinct city) as total_city
from [Walmart Sales Data];
--Q2.In which city is each branch situated?
SELECT DISTINCT city,branch
from [Walmart Sales Data]
order by Branch asc;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--B)Product Analysis
--1)How many distinct product lines are there in the dataset?
select count(distinct product_line) as distinct_product_line
from [Walmart Sales Data];
--2)What is the most common payment method?
select payment,count(payment) as total_payment
from [Walmart Sales Data]
group by Payment;
--3)-- Q3. What is the most selling product line?
select top 1 product_line,count(product_line) as most_selling_line
from [Walmart Sales Data]
group by Product_line
order by most_selling_line desc;
--4)What is the total revenue by month?
SELECT
    DATENAME(MONTH, [date]) AS month_name,
    SUM(total) AS total_revenue
FROM [Walmart Sales Data]
GROUP BY DATENAME(MONTH, [date]),
         MONTH([date])
ORDER BY total_revenue DESC;

--5)Which month recorded the highest Cost of Goods Sold (COGS)?

select top 1 DATENAME(MONTH,[date]) as month_name,
ROUND(sum(cogs),2) as Goods_sold
from [Walmart Sales Data]
group by DATENAME(MONTH,[date])
order by Goods_sold desc;
--6)Which product line generated the highest revenue?

SELECT top 1 product_line,sum(total) as highest_revenue
from [Walmart Sales Data]
group by Product_line
order by highest_revenue desc;
--7)Which city has the highest revenue?


select  top 1 city,sum(total) as highest_revenue
from [Walmart Sales Data]
group by City
order by highest_revenue desc;
--8) Which product line incurred the highest VAT?

select top 1 product_line,sum(VAT) as highest_vat
from [Walmart Sales Data]
group by Product_line
order by highest_vat desc;
--9)Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,' based on whether its sales are above the average.
with cte1 as
(
select product_line,sum(total) as total_saless
from [Walmart Sales Data]
group by Product_line
)
select Product_line,total_saless,
case when total_saless>(select avg(total_saless) from cte1) then 'good' else 'Bad' end as product_category
from cte1;
--10 Which branch sold more products than average?
select * from [Walmart Sales Data];
with cte1 as
(
select Branch,sum(Quantity) as total_products
from [Walmart Sales Data]
group by Branch
)
select *
from cte1
where total_products >(select avg(total_products) from cte1);
-- 11 What is the most common product line by gender?
with cte1 as
(
select gender,product_line,count(*)  as cnt,
rank()over(partition by gender order by count(*) desc) as rn 
from [Walmart Sales Data]
group by gender,Product_line
)
select gender,Product_line
from cte1
where rn=1
-- 12 What is the average rating of each product line?
select product_line, ROUND(avg(Rating),2) as avg_rate
from [Walmart Sales Data]
group by Product_line;

-- 13 Identify the customer type that generates the highest revenue.
select * from [Walmart Sales Data];
select top 1 customer_type ,sum(total) as highest_revenue
from [Walmart Sales Data]
group by Customer_type
order by highest_revenue desc;
-- 14 Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT TOP 1
    city,
    ROUND(AVG((VAT / cogs) * 100), 2) AS avg_vat_percentage
FROM [Walmart Sales Data]
GROUP BY city
ORDER BY avg_vat_percentage DESC;
-- 15 Which customer type pays the most VAT?
SELECT TOP 1 Customer_type,sum(VAT) as most_vat
from [Walmart Sales Data]
group by Customer_type
order by most_vat desc;
--16 How many unique customer types does the data have?
select count(distinct customer_type) as unique_type
from [Walmart Sales Data];
--17 How many unique payment methods?
SELECT COUNT(DISTINCT payment) AS total_payment_methods
FROM [Walmart Sales Data];
-- 18 What is the gender distribution per branch?
SELECT
    branch,
    gender,
    COUNT(*) AS total_customers
FROM [Walmart Sales Data]
GROUP BY branch, gender
ORDER BY branch;
--19 Which day of week has best average rating?
SELECT TOP 1
    DATENAME(WEEKDAY,[date]) AS weekday_name,
    AVG(rating) AS avg_rating
FROM [Walmart Sales Data]
GROUP BY DATENAME(WEEKDAY,[date])
ORDER BY avg_rating DESC;

--20 Which day of week has best average rating per branch?

WITH CTE1 AS
(
SELECT Branch,DATENAME(WEEKDAY,[date]) as weekday_name,avg(rating) as avg_rating,
rank()over(partition by Branch order by avg(rating) desc) as rn
from [Walmart Sales Data]
group by Branch,DATENAME(WEEKDAY,[date])
)
SELECT Branch,weekday_name,avg_rating
from CTE1
where rn=1;

---------------------------------------------------------------------