/** This is the SQL Murder Mystery exercise performed in SQLite **/
/** The link is https://mystery.knightlab.com/  **/

/** There's been a Murder in SQL City! The SQL Murder Mystery is designed to be both a self-directed lesson to learn SQL concepts
 *  and commands and a fun game for experienced SQL users to solve an intriguing crime. **/

/** Here's what we know:
 * A crime has taken place and the detective needs your help. The detective gave you the crime scene report, 
 * but you somehow lost it. You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 
 * and that it took place in SQL City. Start by retrieving the corresponding crime scene report from the police department’s database. **/

Crime scene report 20180115
SELECT description FROM crime_scene_report WHERE type = 'murder' and date = 20180115 and city = 'SQL City';

/** Output: Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". 
 * The second witness, named Annabel, lives somewhere on "Franklin Ave". **/

/** Get the interview information (We need the names of the people who were interviewed) **/
SELECT * FROM person WHERE address_street_name LIKE 'Northwestern%' ORDER BY address_number DESC; -- last house comes first?
1) Last house on Northwestern Dr. 
id		name			license_id	address_number	address_street_name		ssn
14887	Morty Schapiro	118009		4919			Northwestern Dr			111564949

SELECT * FROM person WHERE address_street_name LIKE 'Franklin%' ORDER BY name;
2) Annabel lives on Franklin Ave: 
id		name			license_id	address_number	address_street_name		ssn
16371	Annabel Miller	490173		103				Franklin Ave			318771143

/** Let's dig in further to see what we can find out from Morty Schapiro and Annabel Miller **/



Query for the interview text:
SELECT transcript FROM interview WHERE person_id = 14887;
1) Morty Schapiro - id 14887: 
I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
Only gold members have those bags. The man got into a car with a plate that included "H42W".

SELECT transcript FROM interview WHERE person_id = 16371;
2) Annabel Miller - id 16371: 
I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

/** We get some interesting information from these two:
 *  Morty saw a MAN
 *  The MAN had a "Get Fit Now Gym" bag
 *  The number on the bag started with "48Z"
 *  The MAN got into a car with plate that included 'H42W'
 *  Annabel witnessed the murder and recognized the killer from the gym
 *  She last saw him on January 9th, 2018 **/
 
Work with information from Morty Schapiro. Find the name of the person who has a gold membership that starts with "48Z" and a license
plate that includes 'H42W'.

SELECT person.name 
FROM person
JOIN get_fit_now_member gfn
ON person.id = gfn.person_id
JOIN drivers_license dl
ON dl.id = person.license_id
WHERE gfn.membership_status = 'gold'
AND gfn.id like '48z%'
AND dl.plate_number like '%H42W%';

/** The name that comes up is Jeremy Bowers **/

/**
Now let's check out Anabel Miller's information about seeing the murderer on January 9th. We need to find out if 
Jeremy Bower was at the gym on that date. 
**/

-- Let's see who was there on January 9th whose membership number begins with '48Z'.
SELECT 
	membership_id,
	gfn.name,
	check_in_date,
	check_in_time,
	check_out_time
FROM get_fit_now_member gfn
JOIN get_fit_now_check_in gfc
ON gfc.membership_id = gfn.id
WHERE check_in_date = 20180109
AND membership_id LIKE '48Z%';

/**
membership_id	name			check_in_date	check_in_time	check_out_time
48Z7A			Joe Germuska	20180109		1600			1730
48Z55			Jeremy Bowers	20180109		1530			1700

As we can see, our primary suspect, Jeremy Bowers, was at the gym from 1530 to 1700 on Jan 9th.
**/

Looks lik our murderer could be Jeremy Bowers or Joe Germuska.

/** Let's find the names of people whose license plates begin with 'H42W' **/
SELECT 
	person.id,
	person.name,
	plate_number
FROM person
JOIN drivers_license dl
ON person.license_id = dl.id
WHERE plate_number LIKE '%H42W%';

id		name			plate_number
51739	Tushar Chandra	4H42WR
67318	Jeremy Bowers	0H42W2
78193	Maxine Whitely	H42W0X

/** Let's check to see if these were at the gym on Jan 9th **/
SELECT 
	membership_id,
	gfn.name,
	check_in_date,
	check_in_time,
	check_out_time
FROM get_fit_now_member gfn
JOIN get_fit_now_check_in gfc
ON gfc.membership_id = gfn.id
JOIN person
ON gfn.person_id = person.id
WHERE check_in_date = 20180109
AND gfn.name IN ('Tushar Chandra', 'Jeremy Bowers', 'Maxine Whitely');

membership_id	name			check_in_date	check_in_time	check_out_time
48Z55			Jeremy Bowers	20180109		1530			1700

/** Looks like Jeremy Bowers is our guy! **/
/** Sure enough, Jeremy Bowers is the killer! **/

/** ****************   BONUS SECTION  *************************** **/
/** Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, 
 * try querying the interview transcript of the murderer to find the real villain behind this crime. 
 * If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. 
 * Use this same INSERT statement with your new suspect to check your answer. **/

 /** Ok, let's review Jeremy Bowers' interview **/
 SELECT 
	transcript
FROM interview
JOIN person
ON interview.person_id = person.id
WHERE name = 'Jeremy Bowers';

/** I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
 * She has red hair and she drives a Tesla Model S. 
 * I know that she attended the SQL Symphony Concert 3 times in December 2017. **/

 /** Let's see who we can find in the database who matches this description **/

SELECT
	person.name,
	annual_income
FROM person
JOIN drivers_license dl
ON dl.id = person.license_id
JOIN facebook_event_checkin fb
ON fb.person_id = person.id
JOIN income
ON income.ssn = person.ssn
WHERE 1 = 1
AND hair_color = 'red'
AND height BETWEEN 65 AND 67
AND car_make = 'Tesla'
AND car_model = 'Model S'
AND fb.event_name LIKE 'SQL Symphony%'
AND fb.date between 20171201 AND 20171231;

/** And the mastermind is Miranda Priestly, who attended the SQL Symphony Concert 3 times in December! **/

/** Results from the query: Congrats, you found the brains behind the murder! 
 * Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne! **/
