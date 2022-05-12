/** 
MySQL 5.7 project
Performed on Ubuntu 20.04 (but will work on Windows and MacOS, too, with changes to exported file name.

This sample database was created from real data to help an 
SQL student with a challenging problem he had at work
The student's job objective was to calculate the time a truck took to complete 
certain phases of a route. His supervisor wanted to see which trucks tended to be 
more efficient at driving the routes.

The challenge comes in that the company uses MySQL 5.7 and is unable to make use of 
some of the Windows functions of MySQL 8.0 that would make this query easier. 
The student's data come from multiple tables, but the primary table is organized 
such that information for each truck's trip is stored in the same table on different rows.

To solve this, I suggeste pivoting the table and then making his time calculations accordingly.

The student also wanted to export the data to a .csv file and that query is shown at the end

After the student worked with the query structure below, he shared with me real tables and data and asked for help
making this query more generic. I did that and his supervisor allowed him to use it to query his operations database.

I can't show the query code because I agreed not to make it public, but essence of it is that the "pivot" query 
has been made more generic so that event time parameters can be pivoted along with thos shown below. 

The student tested the queries  multiple times and compared them to hand calculations to test for accuracy and consistency.
**/



# Drop the database if it exists so we can start over 
DROP DATABASE IF EXISTS trucking;

CREATE DATABASE trucking;

USE trucking;

# The `truck_routes` table contains operational data for each truck (the trucks ship goods
# from one place to the next
# The truck data was provided by the student and this table is really a subset of the operational data
CREATE TABLE truck_routes
(
id INT AUTO_INCREMENT PRIMARY KEY,
route_num INT,
truck_num INT,
event_time_local TIME,
event_type VARCHAR(25),
event_date DATETIME
);



# Populate the `truck_routes` table
INSERT INTO truck_routes(route_num, truck_num, event_time_local, event_type, event_date)
VALUES
(4101, 1242, '04:29:16', 'VCR_PRE_TRIP_START', '2022-03-17 10:29:16'),
(4101, 1242, '04:30:42', 'VCR_PRE_TRIP_SUBMIT', '2022-03-17 10:30:42'),
(4101, 1242, '15:10:17', 'VCR_POST_TRIP_START', '2022-03-17 21:10:17'),
(4101, 1242, '15:12:23', 'VCR_POST_TRIP_SUBMIT', '2022-03-17 21:12:23');


# Display the table to ensure accuracy
SELECT * FROM truck_routes;


# Query to "Pivot"  the table into a usable structure for making calculations
# created a table called `truck_routes` just so I could show you a demonstration):
SELECT route_num, truck_num, DATE(event_date) as date,
MAX(CASE WHEN event_type = 'VCR_PRE_TRIP_START' THEN event_time_local ELSE '' END) AS 'VCR_PRE_TRIP_START',
MAX(CASE WHEN event_type = 'VCR_PRE_TRIP_SUBMIT' THEN event_time_local ELSE '' END) AS 'VCR_PRE_TRIP_SUBMIT',
MAX(CASE WHEN event_type = 'VCR_POST_TRIP_START' THEN event_time_local ELSE '' END) AS 'VCR_POST_TRIP_START',
MAX(CASE WHEN event_type = 'VCR_POST_TRIP_SUBMIT' THEN event_time_local ELSE '' END) AS 'VCR_POST_TRIP_SUBMIT'
FROM truck_routes
GROUP BY route_num, truck_num, date;


# Calculation query
# This query will find the time difference between the pre-trip start and submit, and the post-trip start and submit
# This is the query the student needed to calculate the required times
SELECT 
	route_num,
    truck_num,
    TIMEDIFF(VCR_PRE_TRIP_SUBMIT, VCR_PRE_TRIP_START) AS Start_Diff,
    TIMEDIFF(VCR_POST_TRIP_SUBMIT, VCR_POST_TRIP_START) AS Post_Diff
FROM
(
SELECT route_num, truck_num, DATE(event_date) as date,
MAX(CASE WHEN event_type = 'VCR_PRE_TRIP_START' THEN event_time_local ELSE '' END) AS 'VCR_PRE_TRIP_START',
MAX(CASE WHEN event_type = 'VCR_PRE_TRIP_SUBMIT' THEN event_time_local ELSE '' END) AS 'VCR_PRE_TRIP_SUBMIT',
MAX(CASE WHEN event_type = 'VCR_POST_TRIP_START' THEN event_time_local ELSE '' END) AS 'VCR_POST_TRIP_START',
MAX(CASE WHEN event_type = 'VCR_POST_TRIP_SUBMIT' THEN event_time_local ELSE '' END) AS 'VCR_POST_TRIP_SUBMIT'
FROM truck_routes
GROUP BY route_num, truck_num, date
) AS temp;

# Output to .csv file (a student's request)
# This will output the query results to a .csv file (watch the file name - needs to be consistent with secure_file_priv
SELECT 'Route_Num', 'Truck_Num', 'Start_Diff', 'Post_Diff'  -- create column headers
UNION ALL
SELECT 
	route_num,
    truck_num,
    TIMEDIFF(VCR_PRE_TRIP_SUBMIT, VCR_PRE_TRIP_START) AS Start_Diff,
    TIMEDIFF(VCR_POST_TRIP_SUBMIT, VCR_POST_TRIP_START) AS Post_Diff
INTO OUTFILE '/var/lib/mysql-files/trucker_results.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM
(
SELECT route_num, truck_num, DATE(event_date) as date,
MAX(CASE WHEN event_type = 'VCR_PRE_TRIP_START' THEN event_time_local ELSE '' END) AS 'VCR_PRE_TRIP_START',
MAX(CASE WHEN event_type = 'VCR_PRE_TRIP_SUBMIT' THEN event_time_local ELSE '' END) AS 'VCR_PRE_TRIP_SUBMIT',
MAX(CASE WHEN event_type = 'VCR_POST_TRIP_START' THEN event_time_local ELSE '' END) AS 'VCR_POST_TRIP_START',
MAX(CASE WHEN event_type = 'VCR_POST_TRIP_SUBMIT' THEN event_time_local ELSE '' END) AS 'VCR_POST_TRIP_SUBMIT'
FROM truck_routes
GROUP BY route_num, truck_num, date
) AS temp;

