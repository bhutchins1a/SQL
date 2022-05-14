/* Hackerrank.com advance problem called "occupations"
* Objective:
* Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 
* The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.

The OCCUPATIONS table is described as follows:

     Column      Type
     Name        String
     Occupation  String
Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

Sample Input

  Name        Occupation
Samantha 		Doctor
Julia			Actor
Maria			Actor
Meera			Singer
Ashley			Professor
Ketty			Professor
Christeen		Professor
Jane			Actor
Jenny			Doctor
Priya			Singer

Sample Output

Jenny    Ashley     Meera  Jane
Samantha Christeen  Priya  Julia
NULL     Ketty      NULL   Maria

*/

DROP DATABASE IF EXISTS occupations;
CREATE DATABASE occupations;
USE occupations;

CREATE TABLE occupations
(
Name TEXT,
Occupation TEXT
);

INSERT INTO occupations
VALUES
('Samantha', 'Actor'),
('Julia', 'Singer'),
('Maria', 'Professor'),
('Meera', 'Professor'),
('Ashley', 'Professor'),
('Ketty', 'Actor'),
('Christeen', 'Doctor'),
('Jane', 'Doctor'),
('Jenny', 'Doctor'),
('Priya', 'Singer'),
('Amina', 'Singer'),
('Belvet', 'Professor'),
('Britney', 'Professor'),
('Naomi', 'Professor'),
('Priyanka', 'Professor'),
('Kristeen', 'Doctor'),
('Eve', 'Actor'),
('Jennifer', 'Actor');

SELECT * FROM occupations;

SELECT MAX(Doctor) Doctor, MAX(Professor) Professor, MAX(Singer) Singer, MAX(Actor) Actor
FROM (SELECT 
		CASE 
			WHEN Occupation="Doctor" THEN (@r1:=@r1+1) 
			WHEN Occupation="Professor" THEN (@r2:=@r2+1) 
			WHEN Occupation="Singer" THEN (@r3:=@r3+1) 
            WHEN Occupation="Actor" THEN (@r4:=@r4+1) 
		END as RowNumber,
		CASE WHEN Occupation="Doctor" THEN Name END Doctor,
		CASE WHEN Occupation="Professor" THEN Name END Professor,
		CASE WHEN Occupation="Singer" THEN Name END Singer,
		CASE WHEN Occupation="Actor" THEN Name END Actor 
	FROM OCCUPATIONS, (SELECT @r1:=0, @r2:=0, @r3:=0, @r4:=0) rownum
    ORDER BY Name
) temp 
GROUP BY RowNumber;

/* This is the output from the query. It was incorrect on hackerrank.com but the 
output is an exact match to what was on hackerrank.com as the output */
# Output
# Doctor	Professor	Singer	Actor
#'Christeen', 'Ashley', 'Amina', 'Eve'
#'Jane', 'Belvet', 'Julia', 'Jennifer'
#'Jenny', 'Britney', 'Priya', 'Ketty'
#'Kristeen', 'Maria', NULL, 'Samantha'
#NULL, 'Meera', NULL, NULL
#NULL, 'Naomi', NULL, NULL
#NULL, 'Priyanka', NULL, NULL
	

