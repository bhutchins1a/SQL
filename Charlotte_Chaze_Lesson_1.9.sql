/** More using SQL to gather customer financial and operational info **/

# 1. How many locations are there in New York that sold more than 1 product in January?

SELECT COUNT(DISTINCT location) 
FROM BIT_DB_1.JanSales jan
WHERE location like '%NY%'
AND quantity > 1;
Answer: 133



# 2. How many of each type of headphone were sold in February?

SELECT product, SUM(Quantity) as NumSold
FROM BIT_DB_1.FebSales feb
WHERE product LIKE '%Headphones%'
GROUP BY product;
Anwer: 
product	NumSold
Apple Airpods Headphones	1013
Bose SoundSport Headphones	844
Wired Headphones	1282


# 3. What was the average amount spent per account in February? (Hint: For this question, we want the average amount spent / number of accounts, not the amount spent by each account).

SELECT ROUND((SUM(Quantity*Price)/ COUNT(acctnum)), 2) As Average
FROM BIT_DB_1.customers cust 
JOIN BIT_DB_1.FebSales feb 
ON cust.order_id = feb.orderID;
Answer: 190
         
-- Charlotte's answer
SELECT sum(quantity*price)/count(cust.acctnum)
FROM BIT_DB_1.FebSales Feb

LEFT JOIN BIT_DB.customers cust
ON FEB.orderid=cust.order_id;
Answer: 190

-- Bob variation
SELECT SUM(quantity * price)/COUNT(DISTINCT orderID) AS Average_per_ACCT
FROM BIT_DB_1.FebSales;
Answer: 191.49 why? Because there's not a 1:1 relationship between orderID and acctnum

-- A test - how many rows in the JOINed customers and FebSales tables?
SELECT COUNT(*) AS NumRecords, COUNT(DISTINCT order_id) AS Distinct_Accts
FROM BIT_DB_1.FebSales feb
JOIN BIT_DB_1.customers cust
ON feb.orderID = cust.order_id;
Answer: 13,006 rows with 11,507 distinct order_id


# 4. What was the average quantity of products purchased per account in February? (Hint: just like question 3, we want the overall average, not the average for each account individually).
SELECT 
    SUM(Quantity) AS Sum,
    COUNT(acctnum) AS Count,
    SUM(feb.Quantity)/ COUNT(cust.acctnum) As Average
FROM BIT_DB.FebSales feb 
LEFT JOIN BIT_DB.customers cust
ON cust.order_id = feb.orderID;
Answer: 
Sum	Count	Average
14551	13618	1.06851226318108

-- Charlotte's answer
select sum(quantity)/count(cust.acctnum)
FROM BIT_DB.FebSales Feb

LEFT JOIN BIT_DB.customers cust
ON FEB.orderid=cust.order_id;
Answer: 
sum(quantity) / count(cust.acctnum)
1.06851226318108

# 5. Which product brought in the most revenue in January and how much revenue did it bring in total?
SELECT 
    product, 
    SUM(Quantity*price) as Total_Revenue
FROM BIT_DB_1.JanSales jan
JOIN BIT_DB_1.customers cust
ON jan.orderID = cust.order_id
GROUP BY product 
ORDER BY Total_Revenue DESC
LIMIT 2;
Answer:
product	        Total_Revenue
Macbook Pro Laptop	408000
iPhone	             350000


-- Altnernative 
SELECT 
    product,
    SUM(Quantity*price) AS Max_Revenue
FROM BIT_DB_1.JanSales jan
JOIN BIT_DB_1.customers cust
ON jan.orderID = cust.order_id
GROUP BY product
HAVING Max_Revenue = 
(SELECT MAX(Revenue)
FROM
(SELECT SUM(Quantity*price) as Revenue
FROM BIT_DB_1.JanSales jan
LEFT JOIN BIT_DB_1.customers cust
ON jan.orderID = cust.order_id
GROUP BY product) a )
;
Answer:
product	        Max_Revenue
Macbook Pro Laptop	408000

-- Charlotte's answer
SELECT product, 
SUM(quantity*price)
FROM BIT_DB_1.JanSales 
GROUP BY product
ORDER BY sum(quantity*price) DESC 
LIMIT 1;
Answer:
product	SUM(quantity * price)
Macbook Pro Laptop	399500


/** There are lots of issues with the data in all the tables. It's very dirty and it affects the results. 
I don't have time (or desire) to clean it up but I'll let Charlotte know. **/

-- just a bunch of extra tests on the data to home in on bad data
select count(*)
from bit_db_1.jansales
join bit_db_1.customers
on bit_db_1.jansales.orderID = bit_db_1.customers.order_id;
10559

select count(*) from bit_db_1.jansales;
9681

select count(*)
from bit_db_1.customers
join bit_db_1.jansales
on bit_db_1.jansales.orderID = bit_db_1.customers.order_id;
10599

select count(*) from bit_db.customers;
21759

select count(*) from bit_db.customers
where order_id in (select orderID from bit_db.jansales);
9715

select count(*) from bit_db.customers
where order_id not in (select orderID from bit_db.jansales);
12044

select distinct product, price from bit_db.jansales where product = 'Macbook Pro Laptop';


select order_id, count(acctnum)
from customers
group by order_id
order by order_id;

# have to clean up all the tables: customers and all the sales tables. they have CR & LF characters in rows as well as column headers in many rows
delete from bit_db_1.customers where order_id ='Order ID';


select orderID 
from bit_db_1.JanSales
where orderID not in (select order_id from customers);
