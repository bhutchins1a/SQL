-- A variety of SQL queries presented by hackerrank.com
-- These are the queries I wrote and compared to the expected output
--
-- Hackerrank SQL Advanced JOINs: SQL Project Planning
--
-- You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. 
-- It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
-- If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the 
-- total number of different projects completed.

-- Write a query to output the start and end dates of projects listed by the number of days it took to complete the project 
-- in ascending order. If there is more than one project that have the same number of completion days, 
-- then order by the start date of the project.
SELECT 
    Start_Date, 
    MIN(End_Date) 
FROM
    (SELECT 
    Start_Date
    FROM PROJECTS
    WHERE Start_Date NOT IN
        (SELECT End_Date 
            FROM PROJECTS)) a,
    (SELECT End_Date
    FROM PROJECTS
    WHERE End_Date NOT IN
        (SELECT Start_date
            FROM PROJECTS)) b
WHERE Start_Date < End_Date
GROUP BY Start_Date
ORDER BY (MIN(End_Date) - Start_Date), Start_Date;

-- Answer:
Start_Date, End_Date
2015-10-15 	2015-10-16 
2015-10-17 	2015-10-18 
2015-10-19 	2015-10-20 
2015-10-21 	2015-10-22 
2015-11-01 	2015-11-02 
2015-11-17 	2015-11-18 
2015-10-11 	2015-10-13 
2015-11-11 	2015-11-13 
2015-10-01 	2015-10-05 
2015-11-04 	2015-11-08 
2015-10-25 	2015-10-31


-- Hackerrank SQL Advanced JOINs: Placements
--
-- You are given three tables: Students, Friends and Packages. Students contains two columns: ID and Name. 
-- Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). Packages contains two columns: ID and Salary 
-- (offered salary in $ thousands per month).

-- Write a query to output the names of those students whose best friends got offered a higher salary than them. 
-- Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students 
-- got same salary offer.

SELECT
    Name
FROM
(SELECT 
    s1.ID AS ID,
    s1.name AS Name,
    p1.salary AS Salary,
    Friend_ID AS Friend_ID,
    s2.name AS Friend_Name,
    p2.salary AS Friend_Salary
FROM students s1
JOIN friends f1
ON s1.ID = f1.ID
JOIN packages p1
ON p1.id = s1.id
JOIN packages p2
ON p2.id = f1.friend_id
JOIN students s2
ON s2.ID = f1.friend_id) t1
WHERE t1.Friend_Salary > t1.Salary
ORDER BY t1.Friend_Salary;

-- Answer:
Name 
Stuart
Priyanka
Paige
Jane
Julia
Belvet
Amina
Kristeen
Scarlet
Priya
Meera

-- (The more expanded set is this below)
ID  Friend      Pkg    Fr_ID    Fr_Name     Fr_Pkg
1 	Samantha 	15.5 	14 		Scarlet 	15.1
2 	Julia 		15.6 	15 		Salma 		17.1
3 	Britney 	16.7 	18 		Stuart 		13.15
4 	Kristeen 	18.8 	19 		Aamina 		33.33
5 	Dyana 		31.5 	20 		Amina 		22.16
6 	Jenny 		45 		5 		Dyana 		31.5
7 	Christene 	47 		6 		Jenny 		45
8 	Meera 		46 		7 		Christene 	47
9 	Priya 		39 		8 		Meera 		46
10 	Priyanka 	11.1 	1 		Samantha 	15.5
11 	Paige 		12.1 	2 		Julia 		15.6
12 	Jane 		13.1 	3 		Britney 	16.7
13 	Belvet 		14.1 	4 		Kristeen 	18.8
14 	Scarlet 	15.1 	9 		Priya 		39
15 	Salma 		17.1 	10 		Priyanka 	11.1
16 	Amanda 		21.1 	11 		Paige 		12.1
17 	Maria 		31.1 	12 		Jane 		13.1
18 	Stuart 		13.15 	13 		Belvet 		14.1
19 	Aamina 		33.33 	16 		Amanda 		21.1
20 	Amina 		22.16 	17 		Maria 		31.1


-- Advanced JOIN: Symmetric Pairs
--
--You are given a table, Functions, containing two columns: X and Y.
--
--     Column        Type
--        X         Integer
--        Y         Integer

-- Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.
-- Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ≤ Y1.
SELECT X,
       Y
FROM Functions f1
WHERE EXISTS
    (SELECT *
     FROM Functions f2
     WHERE f2.Y = f1.X
       AND f2.X = f1.Y
       AND f2.X > f1.X)
  AND (X != Y)
UNION
SELECT X,
       Y
FROM Functions f1
WHERE X = Y
  AND (
         (SELECT COUNT(*)
          FROM Functions
          WHERE X = f1.X
            AND Y = f1.X) > 1)
ORDER BY X;
-- Answer:
	X   Y
	2 	24
	4 	22
	5 	21
	6 	20
	8 	18
	9 	17
	11 	15
	13 	13


-- Advanced JOIN: Interviews
-- 
-- Samantha interviews many candidates from different colleges using coding challenges 
-- and contests. Write a query to print the contest_id, hacker_id, name, and the 
-- sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest 
-- sorted by contest_id. Exclude the contest from the result if all four sums are 0.
-- 
-- Note: A specific contest can be used to screen candidates at more than one college, but each college only holds 1 screening contest.
-- (This one was quite challenging, too!)
SELECT 
    ct.contest_id AS Contest_ID,
    hacker_id,
    name AS Hacker_Name,
    IFNULL(SUM(ss.total_submissions), 0) AS SUM_Subs,
    IFNULL(SUM(ss.total_accepted_submissions), 0) AS SUM_Accept_Subs,
    IFNULL(SUM(vs.total_views), 0) AS SUM_Total_Views,
    IFNULL(SUM(vs.total_unique_views), 0) AS SUM_Total_Unique_Views
FROM contests ct
JOIN colleges cl 
ON ct.contest_id = cl.contest_id
JOIN challenges ch 
ON cl.college_id = ch.college_id
LEFT JOIN 
(SELECT challenge_id, SUM(total_submissions) AS total_submissions, SUM(total_accepted_submissions) AS total_accepted_submissions 
FROM submission_stats s GROUP BY challenge_id) ss 
ON ss.challenge_id = ch.challenge_id
LEFT JOIN 
(SELECT challenge_id, SUM(total_views) AS total_views, SUM(total_unique_views) AS total_unique_views
FROM view_stats GROUP BY challenge_id) vs 
ON vs.challenge_id = ch.challenge_id
GROUP BY ct.contest_id, hacker_id, name
HAVING (SUM_Subs+SUM_Accept_Subs+SUM_Total_Views+SUM_Total_Unique_Views) > 0
ORDER BY ct.contest_id;

-- Answer: 
# Contest_ID	hacker_id	Hacker_Name	SUM_Subs	SUM_Accept_Subs	SUM_Total_Views	SUM_Total_Unique_Views
66406			17973			Rose	111					39				156				56
66556			79153			Angela	0					0				11				10
94828			80275			Frank	150					38				41				15
				

-- With the full dataset
# Contest_ID	hacker_id	Hacker_Name		SUM_Subs	SUM_Accept_Subs	SUM_Total_Views	SUM_Total_Unique_Views
845				579			Rose			1987			580				1635			566
858				1053		Angela			703				160				1002			384
883				1055		Frank			1121			319				1217			338
1793			2655		Patrick			1337			360				1216			412
2374			2765		Lisa			2733			815				3368			904
2963			2845		Kimberly		4306			1221			3603			1184
3584			2873		Bonnie			2492			652				3019			954
4044			3067		Michael			1323			449				1722			528
4249			3116		Todd			1452			376				1767			463
4269			3256		Joe				1018			372				1766			530
4483			3386		Earl			1911			572				1644			477
4541			3608		Robert			1886			516				1694			504
4601			3868		Amy				1900			639				1738			548
4710			4255		Pamela			2752			639				2378			705
4982			5639		Maria			2705			759				2558			711
5913			5669		Joe				2646			790				3181			835
5994			5713		Linda			3369			967				3048			954
6939			6550		Melissa			2842			859				3574			1004
7266			6947		Carol			2758			665				3044			835
7280			7030		Paula			1963			554				886				259
7484			7033		Marilyn			3217			934				3795			1061
7734			7386		Jennifer		3780			1015			3637			1099
7831			7787		Harry			3190			883				2933			1012
7862			8029		David			1738			476				1475			472
8812			8147		Julia			1044			302				819				266
8825			8438		Kevin			2624			772				2187			689
9136			8727		Paul			4205			1359			3125			954
9613			8762		James			3438			943				3620			1046
10568			8802		Kelly			1907			620				2577			798
11100			8809		Robin			1929			613				1883			619
12742			9203		Ralph			1523			413				1344			383
12861			9644		Gloria			1596			536				2089			623
12865			10108		Victor			2076			597				1259			418
13503			10803		David			924				251				584				167
13537			11390		Joyce			1381			497				1784			538
13612			12592		Donna			1981			550				1487			465
14502			12923		Michelle		1510			463				1830			545
14867			13017		Stephanie		2471			676				2291			574
15164			13256		Gerald			2570			820				2085			607
15804			13421		Walter			1454			459				1396			476
15891			13569		Christina		2188			710				2266			786
16063			14287		Brandon			1804			580				1621			521
16415			14311		Elizabeth		4535			1366			3631			1071
18477			14440		Joseph			1320			391				1419			428
18855			16973		Lawrence		2967			1020			3371			1011
19097			17123		Marilyn			2956			807				2554			750
19575			17562		Lori			2590			863				2627			760


-- Advanced JOINs: 15 Days of Learning SQL
-- 
-- Julia conducted a 15 days of learning SQL contest. The start date of the contest was March 01, 2016 and the 
-- end date was March 15, 2016.
-- 
-- Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day 
-- of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one 
-- such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, 
-- sorted by the date.
SELECT submission_date,
       (SELECT COUNT(DISTINCT hacker_id) as num_unique_hackers FROM submissions S2
        WHERE  S2.submission_date = S1.submission_date
        AND (SELECT COUNT(DISTINCT S3.submission_date)
             FROM   submissions S3
             WHERE  S3.hacker_id = S2.hacker_id
             AND S3.submission_date < S1.submission_date
        ) = DATEDIFF(S1.submission_date, (SELECT MIN(submission_date) FROM submissions))
       ) AS Count_Unique_Hackers,
       (SELECT hacker_id FROM submissions S2
        WHERE  S2.submission_date = S1.submission_date
        GROUP  BY hacker_id
        ORDER  BY Count(submission_id) DESC, hacker_id ASC LIMIT  1
       ) AS MAX_SUB_HACKER_ID,
       (SELECT name FROM hackers
        WHERE  hacker_id = MAX_SUB_HACKER_ID
       ) AS NAME
FROM   (SELECT DISTINCT submission_date FROM submissions) S1
GROUP BY submission_date;

-- Answer:
submit_date		num_unique_hackers		Hacker_Id 		Name
2016-03-01 				112 			81314 			Denise 
2016-03-02 				59 				39091 			Ruby 
2016-03-03 				51 				18105 			Roy 
2016-03-04 				49 				533 			Patrick 
2016-03-05 				49 				7891 			Stephanie 
2016-03-06 				49 				84307 			Evelyn 
2016-03-07 				35 				80682 			Deborah 
2016-03-08 				35 				10985 			Timothy 
2016-03-09 				35 				31221 			Susan 
2016-03-10 				35 				43192 			Bobby 
2016-03-11 				35 				3178 			Melissa 
2016-03-12 				35 				54967 			Kenneth 
2016-03-13 				35 				30061 			Julia 
2016-03-14 				35 				32353 			Rose 
2016-03-15 				35 				27789 			Helen 
