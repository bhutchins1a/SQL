```sql
/** 
Subqueries and stuff from Charlotte Chaze Course
These queries are all about getting statistics about customers, products and revenue for varying timeframes
**/


#1. How many sales made in January?
SELECT COUNT(*) FROM BIT_DB.JanSales; (ans: 9723)

#2. How many of those orders were for an iPhone?
SELECT COUNT(*) FROM BIT_DB.JanSales WHERE Product = "iPhone"; (ans: 379)

#3. Select the customer account numbers for all the orders that were placed in February.
SELECT 
    acctnum AS Account_Number,
    COUNT(*) AS Number_of_Orders
FROM customers
JOIN FebSales 
    ON customers.order_id = FebSales.orderID
GROUP BY acctnum
ORDER BY acctnum;


#4. Which product was the cheapest one sold in January, and what was the price? For this one, you are going to 
# use the commands distinct and MIN(). Using 'SELECT distinct' will remove duplicate rows from your results. 
# The MIN() command will allow you to select the smallest value from the price column. 
# This is a hard one - see if you can do it, but don't be afraid to look at the hint or answer if you need to!
-- First method uses subquery:
SELECT 
    DISTINCT product,
    price
FROM BIT_DB.JanSales
WHERE price = 
(SELECT MIN(price) FROM BIT_DB.JanSales)
ORDER BY price;
(Answer: AAA Batteries (4-pack) $2.99 )

-- 1st alternative; since using DISTINCT, LIMIT 1 will work
SELECT DISTINCT product, price 
FROM BIT_DB.JanSales 
ORDER BY price ASC LIMIT 1;

-- 2nd alternative; use the MIN() function
SELECT product, MIN(price)
FROM BIT_DB.JanSales
GROUP BY product, price
ORDER BY MIN(price)
LIMIT 1;


#5. What is the total revenue for each product sold in January? (Revenue can be calculated using the number of products sold and the price of the products).
SELECT 
  product, 
  ROUND(SUM(Quantity*price), 0) AS Total_Revenue
FROM BIT_DB.JanSales
GROUP BY product
ORDER BY Total_Revenue DESC;


#6. Which products were sold in February at 548 Lincoln St, Seattle, WA 98101, how many of each were sold, and what was the total revenue?
SELECT
    product,
    SUM(quantity),
    SUM(quantity)*price AS Revenue
FROM FebSales
WHERE location = '548 Lincoln St, Seattle, WA 98101';
/*
Answer:
product	SUM(quantity)	Revenue
```AA Batteries (4-pack)```	```2```	```7.68```
*/


#7. How many customers ordered more than 2 products at a time in February, and what was the average amount spent for those customers?
# Bob's Answer:
SELECT COUNT(acctnum), ROUND(AVG(revenue), 2) 
FROM 
(SELECT
    acctnum,
    quantity,
    price,
    quantity*price as revenue
FROM BIT_DB_1.FebSales feb
LEFT JOIN BIT_DB_1.customers cust
ON feb.orderID = cust.order_id
WHERE quantity > 2) temp;

# Answer:
-- COUNT(acctnum)	ROUND(AVG(revenue), 2)
-- 278	                  13.83

# Charlott's Answer:
SELECT 
COUNT(cust.acctnum), 
ROUND(AVG(quantity)*price, 2)
FROM BIT_DB_1.FebSales Feb
LEFT JOIN BIT_DB_1.customers cust
ON FEB.orderid=cust.order_id
WHERE Feb.Quantity>2;

/**
# Answer
COUNT(cust.acctnum)	ROUND(AVG(quantity) * price, 2)
278	                 12.79
**/
# Now here's an interesting dilemma caused by querying for the number of rows
# where quantity is > 2. Then numbers are different than those in the queries above
# and it is difficult to determine why.
# Query:
SELECT 
  quantity, 
  count(*) as The_Count
FROM BIT_DB_1.FebSales
WHERE quantity > 2
GROUP BY quantity;
/**
# Output	
quantity	The_Count
3	        194
4	         54
5	         11
6	          3
7	          1
Total:	  263
**/
# The queries above gave a total of 278. What's causing the discrepancy?
# There are multiple column headers in the row data - that's what
```
