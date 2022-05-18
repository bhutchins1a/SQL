-- Basic JOIN: African Cities
-- Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.

-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
SELECT
    CITY.NAME
FROM CITY
JOIN COUNTRY
ON CITY.CountryCode = COUNTRY.CODE
WHERE CONTINENT = 'Africa';

Answer:
city.name
Qina
Warraq al-Arab
Kempton Park
Alberton
Klerksdorp
Uitenhage
Brakpan
Libreville


-- Basic JOIN: Average Population of Each Continent
-- Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) 
-- rounded down to the nearest integer.

-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
SELECT
    CONTINENT,
    FLOOR(AVG(CITY.POPULATION))
FROM COUNTRY
JOIN CITY
ON CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY CONTINENT
ORDER BY CONTINENT DESC;

Answer:
CONTINENT   	AVG_POPULATION
South America	147435
Oceania			109189
Europe			175138
Asia			693038
Africa			274439


-- Basic JOIN: The Report
-- You are given two tables: Students and Grades. Students contains three columns ID, Name and Marks.
-- Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. 
-- Ketty doesn't want the NAMES of those students who received a grade lower than 8. 
-- The report must be in descending order by grade -- i.e. higher grades are entered first. 
-- If there is more than one student with the same grade (8-10) assigned to them, 
-- order those particular students by their name alphabetically. Finally, if the grade is lower than 8, 
-- use "NULL" as their name and list them by their grades in descending order. If there is more than one 
-- student with the same grade (1-7) assigned to them, order those particular students by their marks in ascending order.

-- Write a query to help Eve.
SELECT
    CASE
        WHEN Grade < 8 THEN NULL
        ELSE Name
    END AS Name,
    Grade,
    Marks
FROM
(SELECT
    students.name,
    CASE
        WHEN Marks BETWEEN 0 AND 9 THEN 1
        WHEN Marks BETWEEN 10 AND 19 THEN 2
        WHEN Marks BETWEEN 20 AND 29 THEN 3
        WHEN Marks BETWEEN 30 AND 39 THEN 4
        WHEN Marks BETWEEN 40 AND 49 THEN 5
        WHEN Marks BETWEEN 50 AND 59 THEN 6
        WHEN Marks BETWEEN 60 AND 69 THEN 7
        WHEN Marks BETWEEN 70 AND 79 THEN 8
        WHEN Marks BETWEEN 80 AND 89 THEN 9
        WHEN Marks BETWEEN 90 AND 100 THEN 10
    END AS Grade,
    Marks
FROM Students) temp
ORDER BY Grade DESC, name;

-- Answer:
name		grade		marks
Britney 	10 			95
Heraldo 	10 			94
Julia 		10 			96
Kristeen 	10 			100
Stuart 		10 			99
Amina 		9 			89
Christene 	9 			88
Salma 		9 			81
Samantha 	9 			87
Scarlet 	9 			80
Vivek 		9 			84
Aamina 		8 			77


-- Basic JOIN: Top Competitors
SELECT 
    hacker_id,
    name
FROM 
(SELECT
    hackers.hacker_id,
    hackers.name,
    count(*)
FROM submissions s1
JOIN hackers
ON s1.hacker_id = hackers.hacker_id
JOIN challenges
ON s1.challenge_id = challenges.challenge_id
JOIN difficulty 
ON difficulty.difficulty_level = challenges.difficulty_level
WHERE difficulty.score = s1.score
GROUP BY hackers.hacker_id, hackers.name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC, hackers.hacker_id) TEMP
;

-- Answer:
hacker_id	name
27232		Phillip
28614		Willie
15719		Christina
43892		Roy
14246		David
14372		Michelle
18330		Lawrence
26133		Jacqueline
26253		John
30128		Brandon
35583		Norma
13944		Victor
17295		Elizabeth
19076		Matthew
26895		Evelyn
32172		Jonathan
41293		Robin
45386		Christina
45785		Jesse
49652		Christine
13391		Robin
14366		Donna
14777		Gerald
16259		Brandon
17762		Joseph
28275		Debra
36228		Nancy
37704		Keith
40226		Anna
49307		Brian
12539		Paul
14363		Joyce
14658		Stephanie
19448		Jesse
20504		John
20534		Martha
22196		Anthony
23678		Kimberly
28299		David
30721		Ann
32254		Dorothy
46205		Joyce
47641		Patricia
13122		James
13762		Gloria
14863		Walter
18690		Marilyn
18983		Lori
21212		Timothy
25732		Antonio
28250		Evelyn
30755		Emily
38852		Benjamin
42052		Andrew
44188		Diana
48984		Gregory
13380		Kelly
13523		Ralph
21463		Christine
24663		Louise
26243		Diana
26289		Dorothy
39277		Charles
23278		Paula
25184		Martin
32121		Dorothy
36322		Andrew
39782		Tammy
40257		James
41319		Jean
10857		Kevin
25238		Paul
34242		Marilyn
39771		Alan
49789		Lillian
57947		Justin
74413		Harry


-- Basic Joins: Ollivander's Inventory
-- Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.
-- Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy 
-- each non-evil wand of high power and age. Write a query to print the id, age, coins_needed, and power of the 
-- wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, 
-- sort the result in order of descending age.
SELECT
    w1.id,
    wp1.age,
    w1.coins_needed,
    w1.power
FROM wands w1
JOIN wands_property wp1
ON w1.code = wp1.code
WHERE is_evil = 0
AND coins_needed = (SELECT MIN(coins_needed)
    FROM wands w2
    JOIN wands_property wp2
        ON w2.code = wp2.code
    WHERE wp1.age = wp2.age
    AND w1.power = w2.power)
ORDER BY w1.power DESC, wp1.age DESC;

-- Answer: 724 rows


-- Basic JOIN: Challenges
-- Julia asked her students to create some coding challenges. Write a query to print the hacker_id, 
-- name, and the total number of challenges created by each student. Sort your results by the total number 
-- of challenges in descending order. If more than one student created the same number of challenges, 
-- then sort the result by hacker_id. If more than one student created the same number of challenges and 
-- the count is less than the maximum number of challenges created, then exclude those students from the result.

SELECT
    h1.hacker_id AS Hacker_id,
    h1.name AS name,
    COUNT(*) AS Num_Challenges
FROM hackers h1
JOIN challenges c1
ON h1.hacker_id = c1.hacker_id
GROUP BY h1.hacker_id, h1.name
HAVING Num_Challenges = (SELECT COUNT(*) AS max_count FROM challenges GROUP BY hacker_id ORDER BY max_count DESC LIMIT 1)
OR Num_Challenges IN (SELECT temp.cnt FROM (SELECT COUNT(*) AS cnt FROM challenges GROUP BY hacker_id) AS temp
GROUP BY temp.cnt HAVING COUNT(temp.cnt) = 1)
ORDER BY Num_Challenges DESC, h1.hacker_id ASC;

-- OR as an alternative

SELECT
    h1.hacker_id AS Hacker_id,
    h1.name AS name,
    COUNT(*) AS Num_Challenges
FROM hackers h1
JOIN challenges c1
ON h1.hacker_id = c1.hacker_id
GROUP BY h1.hacker_id, h1.name
HAVING Num_Challenges =
(SELECT COUNT(*) FROM challenges GROUP BY hacker_id ORDER BY COUNT(*) DESC LIMIT 1)
OR 
Num_Challenges IN
(SELECT Num_Challenges 
FROM
(SELECT
    h1.hacker_id AS Hacker_ID,
    h1.name,
    COUNT(*) AS Num_Challenges
FROM hackers h1
JOIN challenges c1
ON h1.hacker_id = c1.hacker_id
GROUP BY h1.hacker_id, h1.name
ORDER BY Num_Challenges DESC) t
GROUP BY Num_Challenges
HAVING COUNT(Num_Challenges) = 1)
ORDER BY Num_Challenges DESC, h1.hacker_id ASC;

-- Answer:
hacker_id	Name	Num_Challenges
5120 		Julia 		50 
18425 		Anna 		50 
20023 		Brian 		50 
33625 		Jason 		50 
41805 		Benjamin 	50 
52462 		Nicholas 	50 
64036 		Craig 		50 
69471 		Michelle 	50 
77173 		Mildred 	50 
94278 		Dennis 		50 
96009 		Russell 	50 
96716 		Emily 		50 
72866 		Eugene 		42 
37068 		Patrick 	41 
12766 		Jacqueline 	40 
86280 		Beverly 	37 
19835 		Joyce 		36 
38316 		Walter 		35 
29483 		Jeffrey 	34 
23428 		Arthur 		33 
95437 		George 		32 
46963 		Barbara 	31 
87524 		Norma 		30 
84085 		Johnny 		29 
39582 		Maria 		28 
65843 		Thomas 		27 
5443 		Paul 		26 
52965 		Bobby 		25 
77105 		Diana 		24 
33787 		Susan 		23 
45855 		Clarence 	22 
33177 		Jane 		21 
7302 		Victor 		20 
54461 		Janet 		19 
42277 		Sara 		18 
99388 		Mary 		16 
31426 		Carlos 		15 
95010 		Victor 		14 
27071 		Gerald 		10 
90267 		Edward 		9 
72609 		Bobby 		8


-- Basic JOIN: Contest Leaderboard
-- You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!

-- The total score of a hacker is the sum of their maximum scores for all of the challenges. Write a query to print the 
-- hacker_id, name, and total score of the hackers ordered by the descending score. If more than one hacker achieved the same 
-- total score, then sort the result by ascending hacker_id. Exclude all hackers with a total score of  from your result.

SELECT 
    Hacker, 
    H_Name,
    SUM(m_score) as Total
FROM 
(SELECT 
	t1.hacker_id AS Hacker, 
	t1.name AS H_Name, 
	t1.challenge_id, 
	MAX(score) AS m_score
FROM 
(SELECT 
    h.hacker_id,
    h.name,
    s.challenge_id,
    s.score
FROM hackers h 
JOIN submissions s 
ON h.hacker_id = s.hacker_id) t1
GROUP BY t1.hacker_id, t1.name, t1.challenge_id) t2
GROUP BY Hacker, H_Name
HAVING Total > 0
ORDER BY Total DESC, Hacker;

-- Answer: 
# Hacker	H_Name		Total
76971		Ashley		760
84200		Susan		710
76615		Ryan		700
82382		Sara		640
79034		Marilyn		580
78552		Harry		570
74064		Helen		540
78688		Sean		540
83832		Jason		540
72796		Jose		510
76216		Carlos		510
90304		Lillian		500
88507		Patrick		490
72505		Keith		480
88018		Dennis		480
78918		Julia		470
85319		Shawn		470
71357		Bobby		460
72047		Elizabeth	460
74147		Jason		460
80587		Ruth		460
89286		Jennifer	460
75626		Gerald		450
85788		Julia		440
90588		Charles		440
87978		Melissa		410
78547		Julia		400
82861		Denise		400
92906		Philip		400
94035		Doris		400
85042		Irene		380
79315		Susan		370
79254		Cheryl		340
81859		Jane		290
93258		Jimmy		290
87948		Linda		280
84196		Rose		270
85266		Jonathan	250
73214		Ann			230
3683		Robert		212
80554		Judith		210
55642		Elizabeth	203
6999		Linda		201
35308		Andrew		187
38308		Charles		187
45122		Patricia	176
2380		Todd		175
42279		Andrew		175
25310		Martin		169
25580		Paul		169
12200		Ralph		168
4881		Maria		164
10582		Paul		164
48534		Bobby		164
15940		Christina	163
66274		Chris		152
33393		Jonathan	151
44305		Jesse		147
68133		Janet		144
30917		Brandon		141
42122		Jean		136
59495		Stephen		133
70246		Kelly		133
49116		Wayne		131
47456		Aaron		127
55456		Thomas		127
66530		Jennifer	122
14015		Michelle	121
23032		Anthony		121
1869		Michael		120
12362		Gloria		120
39671		Alan		120
1700		Lisa		115
20843		John		115
64693		Sandra		113
42964		Diana		111
8352		Marilyn		110
48165		Dorothy		108
597			Angela		107
7850		Paula		107
32880		Dorothy		102
31803		Emily		100
9109		Julia		98
14446		Stephanie	98
34429		Norma		98
50325		Andrew		98
2751		Joe			97
19271		Marilyn		97
46027		Lillian		97
59991		Alan		97
64880		Helen		97
65694		Paul		97
17265		Brandon		96
49050		Clarence	95
54234		Cynthia		95
26489		Antonio		94
34553		Nancy		93
48754		Jeremy		93
49653		Carolyn		93
12754		David		91
18428		Lawrence	91
48304		Christopher	88
65153		Larry		88
49727		Margaret	87
41656		Robin		86
63648		Paul		86
26988		Diana		85
51558		Albert		83
2938		Earl		82
11315		James		81
28855		Debra		81
39731		Tammy		81
88494		Jeremy		80
56716		Justin		79
8526		Jennifer	76
63706		Gerald		75
486			Rose		74
28503		Phillip		74
3845		Amy			73
61687		Norma		73
52878		Arthur		72
69832		Charles		71
44539		Joyce		70
12968		Joyce		69
27705		Dorothy		69
36555		Benjamin	69
7725		Carol		67
48588		Carol		67
40617		Anna		66
66461		Steven		66
12671		Victor		64
48556		Gerald		64
31300		Ann			63
57314		Albert		61
7680		Melissa		60
14579		Gerald		60
33538		Dorothy		60
42591		Roy			59
1755		Bonnie		58
45237		Gregory		58
65689		Alan		57
19635		Lori		56
964			Patrick		55
8670		Harry		55
23773		Paula		55
27281		John		55
21323		Timothy		54
45908		Christine	54
61481		Joshua		54
66539		Bonnie		53
12089		Robin		52
28155		Evelyn		51
66566		Shirley		51
52382		Judy		50
54737		Jerry		47
21417		Christine	46
63492		Melissa		46
67347		Jeffrey		46
13279		Donna		45
20328		Matthew		45
24185		Kimberly	45
36517		Keith		45
41148		James		42
69289		Albert		42
4404		Pamela		41
48411		Bobby		39
5787		Joe			38
28619		Evelyn		36
64099		Ronald		35
20360		Jesse		34
58583		James		34
1746		Kimberly	32
775			Frank		31
26831		Jacqueline	31
9044		David		30
62538		Mildred		29
9113		Kevin		28
17381		Elizabeth	26
30731		Willie		22
18320		Joseph		18
45831		Brian		18
14891		Walter		17


