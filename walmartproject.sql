-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
-- amd upload csv which has 995 records


select * from salesdatawalmart.sales;
 
 -- ------------------------Feature engineering-------------
 -- Time_of_day
SELECT time,
      (case
          when `time` between '00:00:00' and '12:00:00' then 'mrng'
          when `time` between '12:00:00' and '16:00:00' then 'afn'
          else 'evng'
	  end) as Time_of_day
from sales;
 
 alter table sales add column Time_of_day varchar(10) Not null;
 
 update sales
 set Time_of_day = (case
          when `time` between '00:00:00' and '12:00:00' then 'mrng'
          when `time` between '12:00:00' and '16:00:00' then 'afn'
          else 'evng'
	  end);
 
-- -------------------------------------------------------------------------------------------------
 -- day_name
 SeLECT date,
        dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10) not null;
 
update sales
set day_name = dayname(date);
 
-- ------------------------------------------------------------------------------------------- 
-- month_name

alter table sales add column month_name varchar(15) not null;
update sales 
set month_name = monthname(date);
-- ---------------------------------------------------------------------------------
--  how many cities
select distinct city
from sales;
--  in city has which branch
Select distinct branch,city
FROM sales;

-- --------------------------product based--------------------------------
-- How many uniquw product lines does the dat have?
SELECt count(distinct product_line)
from sales;
-- what us most common payment method
SeLect payment,
       count(payment) as cnt
from sales
group by payment
order by cnt desc;

-- what is the most selling product line?
SeLect product_line,
       count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

-- what is the total revenue by month?
SELECT Month_name,sum(total) as 'revenue by month'
FROM sales
group by month_name;

-- what month had the largest cogs
SELECT Month_name,(sum(cogs)) as cogs_by_month
FROM sales
group by month_name
order by  cogs_by_month desc;
-- what product line has the largest revenue?
SELECT product_line,
       sum(total) as total_revenue
from sales 
group by product_line
order by total_revenue desc;

-- which branch sold more products than avg product sold?
SELECT branch,
       sum(quantity) as qty
from sales
group by branch
having qty > (Select avg(quantity) from sales)
order by qty
       

-- what is the most common product lne by gender?
;
select GEnder, 
       product_line,
	   count(gender) as total_count
from sales
group by gender, product_line
order by total_count desc;

-- whay s the average rating of each producr line?
SELECT round(avg(rating),2) as avg_rating,
       product_line
from sales
GROUP BY GENDER , PRODUCT_LINE
ORDER BY AVG_RATING DESC;

-- ----------------------------------------------------------------------------------------
-- sales
-- no. of sales made in each time of the day per weekday

select 
       Time_of_day,
       count(*) as totalsales
from sales
where day_name = 'monday'
group by  time_of_day;

-- which type of cx brings more revenue
SELECT customer_type,
       sum(total) as total
from sales 
group by customer_type
order by total desc;

-- which city has the largest tax percent/vat 
SELECT city,
       avg(vat) as TOTAL_vat
from sales
group by city
order by total_vat desc;

-- which type cx pays more vat
SELECT customer_type,
       avg(vat) as totalvat
from sales 
group by customer_type
order by totalvat desc;

-- ---------------------------------------------------------------------------------------------
-- cx
-- how many unique cx 
select count(distinct(customer_type))
from sales
;
-- How many unique payment
select count(distinct(payment)) 
from sales;

-- which cx type buys the most
SELECt customer_type,
	count(*)as cux_cnt
from sales
group by customer_type
order by cux_cnt desc
LIMIT  1;

-- what is the gender of most of the cx
SELECt gender,
	count(*)as cux_cnt
from sales
group by gender
order by cux_cnt desc
LIMIT  2;

-- what is the gender distrubution for each branch
SELECt gender,
	count(*)as cux_cnt
from sales
where branch = 'c'
group by gender
order by cux_cnt desc;
-- which time of the day cx gives more rating?
SELECT time_of_day,
       avg(rating) as avg_raing
from sales
group by time_of_day
order by avg_raing desc;

-- which time of the day cx more rating for each branch?
SELECT time_of_day,
       avg(rating) as avg_raing
from sales
Where branch = 'a'
group by time_of_day
order by avg_raing desc;

-- which day of the eweek has the best avg rating
SELECT day_name,
       avg(rating) As avg_rating 
from Sales
group by day_name
order by avg_rating desc;

-- which day of the week has best avg rating

SELECT day_name,
       avg(rating) As avg_rating 
from Sales
where branch = 'a'
group by day_name
order by avg_rating desc;

-- -----------------------------------------------------------------------------------------------
--  revenue and profit calculations
-- cogs
SELECT sum(unit_price * quantity) 
FROM sales


