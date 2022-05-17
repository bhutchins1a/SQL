-- hackerrank.com problems involving aggregation functions

-- Revising Aggregations - The COUNT Function
-- Query a count of the number of cities in CITY having a Population larger than 100,000.
SELECT 
    COUNT(*)
FROM City
WHERE POPULATION > 100000;

-- Answer: 6


-- Revising Aggregations - The SUM Function
-- Query the total population of all cities in CITY where District is California.
SELECT
    SUM(POPULATION)
FROM City
WHERE DISTRICT = 'California';

-- Answer: 339002


-- Revising Aggregations - The AVG Function
-- Query the average population of all cities in CITY where District is California.
SELECT
    AVG(POPULATION)
FROM City
WHERE DISTRICT = 'California';

-- Answer: 113000.6667


-- Query the average population for all cities in CITY, rounded down to the nearest integer.
SELECT
    FLOOR(AVG(POPULATION))
FROM City;

-- Answer: 454250


-- Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
SELECT 
    SUM(POPULATION)
FROM City
WHERE COUNTRYCODE = 'JPN';

-- Answer: 879196


-- Query the difference between the maximum and minimum populations in CITY.
SELECT
    MAX(POPULATION) - MIN(POPULATION) AS Difference
FROM City;

-- Answer: 4695354


-- Aggregation: The Blunder
-- Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's  
-- 0 key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation 
-- (using salaries with any zeros removed), and the actual average salary.

-- Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), and round it up to the next integer.
SELECT
    CEILING(AVG(Salary) - AVG(REPLACE(Salary,'0','')))
FROM EMPLOYEES;

-- Answer: 2253


-- Aggregation: Top Earners
-- We define an employee's total earnings to be their monthly salary X months worked, and the maximum total earnings to be the maximum total earnings for any employee 
-- in the Employee table. 
-- Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. 
-- Then print these values as 2 space-separated integers.

SELECT 
    CONCAT(Max_Earnings, " ", COUNT(*))
FROM
(SELECT
    SUM(salary * months) AS Max_Earnings
FROM
Employee
GROUP BY employee_id
ORDER BY Max_Earnings DESC) AS temp
GROUP BY Max_Earnings
ORDER BY Max_Earnings DESC
LIMIT 1;

-- Answer: 108064 7


-- Aggregation: Weather Observation Station 2
-- Query the following two values from the STATION table:

-- The sum of all values in LAT_N rounded to a scale of 2 decimal places.
-- The sum of all values in LONG_W rounded to a scale of 2 decimal places.
SELECT
    ROUND(SUM(LAT_N), 2) AS SUM_LAT,
    ROUND(SUM(LONG_W), 2) AS SUM_LONG
FROM STATION;

-- Answer: 42850.04  47381.48


-- Aggregation: Weather Observation Station 13
-- Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. 
-- Truncate your answer to 4 decimal places.
SELECT 
    TRUNCATE(SUM(LAT_N),4) AS SUM_LAT
FROM STATION
WHERE LAT_N > 38.7880 AND LAT_N < 137.2345;

-- Answer: 36354.8135


-- Aggregation: Weather Observation Station 14
-- Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.
SELECT
    TRUNCATE(LAT_N, 4) AS LAT
FROM STATION
WHERE LAT_N < 137.2345
ORDER BY LAT DESC
LIMIT 1;

-- Answer: 137.0193


-- Aggregation: Weather Observation Station 15
-- Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345. 
-- Round your answer to 4 decimal places.
SELECT
    ROUND(LONG_W, 4) AS West_Long
FROM STATION
WHERE LAT_N < 137.2345
ORDER BY LAT_N DESC
LIMIT 1;

-- Answer: 117.2465


-- Aggregation: Weather Observation Station 16
-- Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. Round your answer to 4 decimal places.
SELECT
    ROUND(LAT_N, 4) AS LAT_Small
FROM STATION
WHERE LAT_N > 38.7880
ORDER BY LAT_N
LIMIT 1;

-- Answer: 38.8526


-- Aggregation: Weather Observation Station 17
-- Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7780 Round your answer to 4 decimal places.
SELECT 
    ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N > 38.7780
ORDER BY LAT_N
LIMIT 1;

-- Answer: 70.1378


-- Aggregation: Weather Observation Station 18
-- Consider P1(a,b) and P2(c, d) to be two points on a 2D plane.

-- a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
-- b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
-- c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
-- d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
-- Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.
SELECT 
    ROUND(ABS(MAX(LAT_N)-MIN(LAT_N)) + ABS(MAX(LONG_W)-MIN(LONG_W)), 4)
FROM STATION;

-- Answer: 259.6859


-- Aggregation: Weather Observation Station 19
-- Consider P1(a,c) and P2(b, d) to be two points on a 2D plane.

-- a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
-- b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
-- c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
-- d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
-- Query the Euclidean Distance between points P1 and P2 and round it to a scale of 4 decimal places.
SELECT
    ROUND(SQRT(POWER((MAX(LAT_N) - MIN(LAT_N)),2) + POWER((MAX(LONG_W) - MIN(LONG_W)),2)), 4) AS RND_4
FROM STATION;

-- Answer: 184.1616


-- Aggregation: Weather Observation Station 20
-- A median is defined as a number separating the higher half of a data set from the lower half. 
-- Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
SELECT ROUND(AVG(dd.LAT_N), 4) as median_val
FROM (
SELECT d.LAT_N, @rownum:=@rownum+1 as `row_number`, @total_rows:=@rownum
  FROM STATION d, (SELECT @rownum:=0) r
  WHERE d.LAT_N is NOT NULL
  ORDER BY d.LAT_N
) as dd
WHERE dd.row_number IN ( FLOOR((@total_rows+1)/2), FLOOR((@total_rows+2)/2) );

-- Answer: 83.8913


