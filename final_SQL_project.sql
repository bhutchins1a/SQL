/** Problems from the chinnok database using SQLite 3. database here: https://cdn.fs.teachablecdn.com/dRmwOLQsS22FVFbXfh3x **/

# 1, Show Customers (their full names, customer ID, and country) who are not in the US. (Hint: != or <> can be used to say "is not equal to").
SELECT
    CustomerId as ID,
    FirstName ||" " || LastName AS Customer,
    Country
FROM customers
WHERE Country != 'USA';
Answer:
ID	Customer	                 Country
1	Luís Gonçalves	    Brazil
2	Leonie Köhler	                 Germany
3	François Tremblay	    Canada
4	Bjørn Hansen	                 Norway
5	František Wichterlová	    Czech Republic
6	Helena Holý	                 Czech Republic
7	Astrid Gruber	                 Austria
8	Daan Peeters	                 Belgium
9	Kara Nielsen	                 Denmark
10	Eduardo Martins	    Brazil
11	Alexandre Rocha	    Brazil
12	Roberto Almeida	    Brazil
13	Fernanda Ramos	    Brazil
14	Mark Philips	                 Canada
15	Jennifer Peterson	    Canada
29	Robert Brown	                 Canada
30	Edward Francis	    Canada
31	Martha Silk	                 Canada
32	Aaron Mitchell	    Canada
33	Ellie Sullivan	    Canada
34	João Fernandes	    Portugal
35	Madalena Sampaio	    Portugal
36	Hannah Schneider	    Germany
37	Fynn Zimmermann	    Germany
38	Niklas Schröder	    Germany
39	Camille Bernard	    France
40	Dominique Lefebvre	    France
41	Marc Dubois	                 France
42	Wyatt Girard	                 France
43	Isabelle Mercier	    France
44	Terhi Hämäläinen	    Finland
45	Ladislav Kovács	    Hungary
46	Hugh O'Reilly	                 Ireland
47	Lucas Mancini	                 Italy
48	Johannes Van der Berg	    Netherlands
49	Stanisław Wójcik	    Poland
50	Enrique Muñoz	                 Spain
51	Joakim Johansson	    Sweden
52	Emma Jones	                 United Kingdom
53	Phil Hughes	                 United Kingdom
54	Steve Murray	                 United Kingdom
55	Mark Taylor	                 Australia
56	Diego Gutiérrez               Argentina
57	Luis Rojas	                 Chile
58	Manoj Pareek	                 India
59	Puja Srivastava	    India


# 2. Show only the Customers from Brazil.
SELECT
    CustomerId as ID,
    FirstName ||" " || LastName AS Customer,
    Country
FROM customers
WHERE Country = 'Brazil';
Answer:
1	Luís Gonçalves	Brazil
10	Eduardo Martins	Brazil
11	Alexandre Rocha	Brazil
12	Roberto Almeida	Brazil
13	Fernanda Ramos	Brazil


# 3. Find the Invoices of customers who are from Brazil. The resulting table should show the customer's full name, Invoice ID, Date of the invoice, and billing country.
SELECT
    FirstName ||" " || LastName AS Customer,
    InvoiceId,
    InvoiceDate,
    BillingCountry
FROM customers 
JOIN invoices
    ON customers.CustomerId = invoices. CustomerId
WHERE Country = 'Brazil';
Answer:
Customer	            InvoiceId	InvoiceDate	              BillingCountry
Luís Gonçalves	98	2010-03-11 00:00:00	Brazil
Luís Gonçalves	121	2010-06-13 00:00:00	Brazil
Luís Gonçalves	143	2010-09-15 00:00:00	Brazil
Luís Gonçalves	195	2011-05-06 00:00:00	Brazil
Luís Gonçalves	316	2012-10-27 00:00:00	Brazil
Luís Gonçalves	327	2012-12-07 00:00:00	Brazil
Luís Gonçalves	382	2013-08-07 00:00:00	Brazil
Eduardo Martins	25	2009-04-09 00:00:00	Brazil
Eduardo Martins	154	2010-11-14 00:00:00	Brazil
Eduardo Martins	177	2011-02-16 00:00:00	Brazil
Eduardo Martins	199	2011-05-21 00:00:00	Brazil
Eduardo Martins	251	2012-01-09 00:00:00	Brazil
Eduardo Martins	372	2013-07-02 00:00:00	Brazil
Eduardo Martins	383	2013-08-12 00:00:00	Brazil
Alexandre Rocha	57	2009-09-06 00:00:00	Brazil
Alexandre Rocha	68	2009-10-17 00:00:00	Brazil
Alexandre Rocha	123	2010-06-17 00:00:00	Brazil
Alexandre Rocha	252	2012-01-22 00:00:00	Brazil
Alexandre Rocha	275	2012-04-25 00:00:00	Brazil
Alexandre Rocha	297	2012-07-28 00:00:00	Brazil
Alexandre Rocha	349	2013-03-18 00:00:00	Brazil
Roberto Almeida	34	2009-05-23 00:00:00	Brazil
Roberto Almeida	155	2010-11-14 00:00:00	Brazil
Roberto Almeida	166	2010-12-25 00:00:00	Brazil
Roberto Almeida	221	2011-08-25 00:00:00	Brazil
Roberto Almeida	350	2013-03-31 00:00:00	Brazil
Roberto Almeida	373	2013-07-03 00:00:00	Brazil
Roberto Almeida	395	2013-10-05 00:00:00	Brazil
Fernanda Ramos	35	2009-06-05 00:00:00	Brazil
Fernanda Ramos	58	2009-09-07 00:00:00	Brazil
Fernanda Ramos	80	2009-12-10 00:00:00	Brazil
Fernanda Ramos	132	2010-07-31 00:00:00	Brazil
Fernanda Ramos	253	2012-01-22 00:00:00	Brazil
Fernanda Ramos	264	2012-03-03 00:00:00	Brazil
Fernanda Ramos	319	2012-11-01 00:00:00	Brazil


# 4. Show the Employees who are Sales Agents.
SELECT
    EmployeeId,
    FirstName || " " || LastName AS Employee,
    Title
FROM employees
WHERE Title = 'Sales Support Agent';
Answer:
EmployeeId	Employee	    Title
3	Jane Peacock	    Sales Support Agent
4	Margaret Park	    Sales Support Agent
5	Steve Johnson    Sales Support Agent


# 5. Find a unique/distinct list of billing countries from the Invoice table.
SELECT
    DISTINCT BillingCountry
FROM invoices
ORDER BY BillingCountry;
Answer:
BillingCountry
Argentina
Australia
Austria
Belgium
Brazil
Canada
Chile
Czech Republic
Denmark
Finland
France
Germany
Hungary
India
Ireland
Italy
Netherlands
Norway
Poland
Portugal
Spain
Sweden
USA
United Kingdom


-- # 6. Provide a query that shows the invoices associated with each sales agent. The resulting table should include the Sales Agent's full name.
SELECT
    emp.FirstName || " " || emp.LastName as Sales_Rep,
    InvoiceId
FROM employees emp
JOIN customers cust
    ON emp.EmployeeId = cust.SupportRepId
JOIN invoices inv
    ON inv.CustomerId = cust.CustomerId
WHERE emp.Title = 'Sales Support Agent'
ORDER BY Sales_Rep, InvoiceId;
Answer is too long.

-- alternative: Provide a query that shows the number of invoices associated with each sales agent
SELECT
    emp.FirstName,
    emp.LastName,
    COUNT(InvoiceId) AS Num_Invoices
FROM employees emp
JOIN customers cust
    ON emp.EmployeeId = cust.SupportRepId
JOIN invoices inv
    ON inv.CustomerId = cust.CustomerId
WHERE emp.Title = 'Sales Support Agent'
GROUP BY emp.LastName, emp.FirstName
ORDER BY emp.LastName, emp.FirstName, InvoiceId;
Answer:
FirstName	LastName	Num_Invoices
Steve	Johnson	126
Margaret	Park	140
Jane	Peacock	146


# 7. Show the Invoice Total, Customer name, Country, and Sales Agent name for all invoices and customers.
SELECT
    cust.FirstName || " " || cust.LastName AS Customer,
    inv.Total AS Inv_Total,
    cust.Country AS Country,
    emp.FirstName || " " || emp.LastName AS Sales_Rep
FROM invoices inv
JOIN customers cust
    ON inv.CustomerId = cust.CustomerId
JOIN employees emp
ON emp.EmployeeId = cust.SupportRepId
ORDER BY Country, Customer;
Answer:
412 rows


# 8. How many Invoices were there in 2009?
SELECT 
    '2009' AS Year,
    COUNT(*) AS Num_Invoices
FROM invoices 
WHERE SUBSTR(InvoiceDate, 1, 4) = '2009';
Answer:
Year	Num_Invoices
2009	83


# 9. What are the total sales for 2009?
SELECT
    '2009' AS Year,
    ROUND(SUM(Total), 2) AS Total_Sales
FROM invoices
WHERE SUBSTR(InvoiceDate, 1, 4) = '2009';
Answer:
Year	Total_Sales
2009	449.46


# 10. Write a query that includes the purchased track name with each invoice line item.
SELECT
    invoiceId,
    inv.InvoiceLineId,
    tracks.Name
FROM invoice_items inv
JOIN tracks
    ON inv.TrackId = tracks.TrackId
ORDER BY invoiceId;
Answer:
2240 rows


# 11. Write a query that includes the purchased track name AND artist name with each invoice line item.
SELECT
    invoiceId,
    inv.InvoiceLineId,
    tracks.Name AS Track,
    artists.Name AS Artist
FROM invoice_items inv
JOIN tracks
    ON inv.TrackId = tracks.TrackId
JOIN albums
    ON albums.AlbumId = tracks.AlbumId
JOIN artists
    ON artists.ArtistId = albums.ArtistId
ORDER BY invoiceId;
Answer:
2240 rows. Artists look accurate to track names


# 12. Provide a query that shows all the Tracks, and include the Album name, Media type, and Genre.
SELECT
    tracks.Name AS Track_Name,
    albums.Title AS Album_Title,
    mt.Name AS Media_Type,
    genres.Name AS Genre,
    artists.Name AS Artist
FROM tracks
JOIN albums
    ON tracks.AlbumID = albums.AlbumId
JOIN media_types mt
    ON mt.MediaTypeId = tracks.MediaTypeId
JOIN genres
    ON genres.GenreId = tracks.GenreId
JOIN artists
    ON artists.ArtistId = albums.ArtistId
ORDER BY Artist;
Answer:
3503 rows; tracks match albums and artists - thats good!

# 13. Show the total sales made by each sales agent.
SELECT
    emp.FirstName || " " || emp.LastName as Sales_Rep,
    ROUND(SUM(Total), 2) as Rep_Total_Sales
FROM employees emp
JOIN customers cust
    ON emp.EmployeeId = cust.SupportRepId
JOIN invoices inv
    ON inv.CustomerId = cust.CustomerId
WHERE emp.Title = 'Sales Support Agent'
GROUP BY Sales_Rep
ORDER BY Rep_Total_Sales DESC;
Answer:
Sales_Rep	    Rep_Total_Sales
Jane Peacock	    833.04
Margaret Park	    775.4
Steve Johnson	    720.16  


# 14. Which sales agent made the most in sales in 2009?
SELECT
    emp.FirstName || " " || emp.LastName as Sales_Rep,
    ROUND(SUM(Total), 2) as Rep_Total_Sales
FROM employees emp
JOIN customers cust
    ON emp.EmployeeId = cust.SupportRepId
JOIN invoices inv
    ON inv.CustomerId = cust.CustomerId
WHERE emp.Title = 'Sales Support Agent'
AND SUBSTR(InvoiceDate, 1, 4) = '2009'
GROUP BY Sales_Rep
ORDER BY Rep_Total_Sales DESC;
Answer:
Sales_Rep	    Rep_Total_Sales
Steve Johnson    164.34            -- !!!!!!!Winner Winner, Chicken Dinner!!!!!!!!
Margaret Park	    161.37
Jane Peacock	    123.75