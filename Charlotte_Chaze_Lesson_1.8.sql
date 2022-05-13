/** More analytics from sales and customer data **/

# List all the products sold in Los Angeles in February, and include how many of each were sold.

SELECT product, SUM(Quantity) AS Num_Ordered
FROM BIT_DB.FebSales 
WHERE location like '%Los Angeles%'
GROUP BY product;