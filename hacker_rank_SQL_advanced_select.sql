-- All the Advanced Select queries from hackerrank.com
-- solved as per the instructions.


-- Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:
Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.

SELECT 
    CASE 
        WHEN (A + B) <= C OR (B + C) <= A OR (A + C) <= B THEN 'Not A Triangle'
        WHEN (A = B) AND (B = C) THEN 'Equilateral'
        WHEN (A = B OR B = C OR A = C) THEN 'Isosceles'
        ELSE 'Scalene'
    End as Triangle
FROM TRIANGLES;


The Pads
Generate the following two result sets:

Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical 
(i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:

There are a total of [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.

Note: There will be at least two entries in the table for each type of occupation.

Input Format

The OCCUPATIONS table is described as follows:  
Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

SELECT CONCAT(Name,
             CASE 
                WHEN Occupation = 'Actor' THEN '(A)'
                WHEN Occupation = 'Doctor' THEN '(D)'
                WHEN Occupation = 'Professor' THEN '(P)'
                WHEN Occupation = 'Singer' THEN '(S)'
             END
             )
FROM Occupations
ORDER BY Name ASC;
SELECT CONCAT('There are a total of ', COUNT(*), 
             CASE
                WHEN Occupation = 'Doctor' THEN ' doctors.'
                WHEN Occupation = 'Singer' THEN ' singers.'
                WHEN Occupation = 'Actor' THEN ' actors.'
                WHEN Occupation = 'Professor' THEN ' professors.'
             END
             )
FROM Occupations
GROUP BY Occupation
ORDER BY COUNT(*), Occupation;

-- Optional method
SELECT concat(NAME,concat("(",concat(substr(OCCUPATION,1,1),")"))) FROM OCCUPATIONS ORDER BY NAME ASC;
SELECT "There are a total of ", count(OCCUPATION), concat(lower(occupation),"s.") FROM OCCUPATIONS GROUP BY OCCUPATION ORDER BY count(OCCUPATION), OCCUPATION ASC

Aamina(D) 
Ashley(P) 
Belvet(P) 
Britney(P) 
Christeen(S) 
Eve(A) 
Jane(S) 
Jennifer(A) 
Jenny(S) 
Julia(D) 
Ketty(A) 
Kristeen(S) 
Maria(P) 
Meera(P) 
Naomi(P) 
Priya(D) 
Priyanka(P) 
Samantha(A) 
There are a total of 3 doctors. 
There are a total of 4 actors. 
There are a total of 4 singers. 
There are a total of 7 professors.


Binary Tree Nodes
You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.



Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
	Root: If node is root node.
	Leaf: If node is leaf node.
	Inner: If node is neither root nor leaf node.
Sample Input
	N  			p 
	1  			2
	3 			2
	6			8
	9			8
	2   		5
	8			5 	
	5  			NULL

SELECT N,
    CASE
        WHEN P IS NULL THEN 'Root'
        WHEN N IN (SELECT P FROM bst) THEN 'Inner'
        ELSE 'Leaf'
    END AS Node_Type
FROM bst
ORDER BY N;

Output:
N  Node_Type
-----------
1   Leaf
2   Inner
3   Leaf
4   Inner
5   Leaf
6   Inner
7   Leaf
8   Leaf
9   Inner
10  Leaf
11  Inner
12  Leaf
13  Inner
14  Leaf
15  Root


New Companies
-- Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: 

Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, 
total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.

Note:

The tables may contain duplicate records.
The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, 
then the ascending company_codes will be C_1, C_10, and C_2.

Input Format

The following tables contain company data:

Company: The company_code is the code of the company and founder is the founder of the company. 

Lead_Manager: The lead_manager_code is the code of the lead manager, and the company_code is the code of the working company. 

Senior_Manager: The senior_manager_code is the code of the senior manager, the lead_manager_code is the code of its lead manager, 
and the company_code is the code of the working company. 

Manager: The manager_code is the code of the manager, the senior_manager_code is the code of its senior manager, 
the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 

Employee: The employee_code is the code of the employee, the manager_code is the code of its manager, the senior_manager_code is the code of its senior manager, 
the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company. 

Sample Input:

Company table:
     company_code     founder
         C1  			Monika
         C2 		   Samantha

Lead_Manager table:

lead_manager_code      company_code
        LM1					C1 
        LM2					C2

Senior_Manager table:
senior_manager_code  lead_manager_code  company_code
        SM1					LM1				C1 
        SM2					LM1				C1 
        SM3					LM2				C2 

Manager table:
manager_code  senior_manager_code  lead_manager_code  company_code 
     M1				SM1				LM1					C1 
     M2 			SM3				LM2					C2 
     M3 			SM3  			LM2					C2

Employee table:
employee_code  manager_code  senior_manager_code  lead_manager_code  company_code
	E1				M1 				SM1					LM1				C1 
	E2				M1  			SM1					LM1				C1 
	E3				M2  			SM3  				LM2				C2 
	E4				M3  			SM3					LM2  			C2

Sample Output:
company_code  founder  num_LM  num_SM  num_M num_emp
	C1 		   Monika	  1 	  2 	  1 	2
	C2 		  Samantha	  1  	  1  	  2 	2



Query:
SELECT
    C.company_code,
    C.founder,
    COUNT(DISTINCT LM.lead_manager_code) AS Num_LM,
    COUNT(DISTINCT SM.senior_manager_code) AS Num_SM,
    COUNT(DISTINCT Mgr.manager_code) AS Num_Mgrs,
    COUNT(DISTINCT Emp.employee_code) AS Num_Emps
FROM Company C
JOIN Lead_Manager LM
ON C.company_code = LM.company_code
JOIN Senior_Manager SM
ON SM.company_code = C.company_code
AND SM.lead_manager_code = LM.lead_manager_code
JOIN Manager Mgr
ON Mgr.company_code = SM.company_code
AND Mgr.lead_manager_code = SM.lead_manager_code
AND Mgr.senior_manager_code = SM.senior_manager_code
JOIN Employee Emp
ON C.company_code = Emp.company_code
GROUP BY company_code, founder
ORDER BY 1;

Output:
company_code, founder, Num_LM, Num_SM, Num_Mgrs, Num_Emps
C1 Angela 1 2 5 13 
C10 Earl 1 1 2 3 
C100 Aaron 1 2 4 10 
C11 Robert 1 1 1 1 
C12 Amy 1 2 6 14 
C13 Pamela 1 2 5 14 
C14 Maria 1 1 3 5 
C15 Joe 1 1 2 3 
C16 Linda 1 1 3 5 
C17 Melissa 1 2 3 7 
C18 Carol 1 2 5 6 
C19 Paula 1 2 4 7 
C2 Frank 1 1 1 3 
C20 Marilyn 1 1 2 2 
C21 Jennifer 1 1 3 7 
C22 Harry 1 1 3 6 
C23 David 1 1 1 2 
C24 Julia 1 1 2 6 
C25 Kevin 1 1 2 5 
C26 Paul 1 1 1 3 
C27 James 1 1 1 3 
C28 Kelly 1 2 5 9 
C29 Robin 1 2 4 9 
C3 Patrick 1 2 2 5 
C30 Ralph 1 1 2 5 
C31 Gloria 1 1 1 3 
C32 Victor 1 2 4 8 
C33 David 1 2 5 12 
C34 Joyce 1 2 6 10 
C35 Donna 1 2 6 12 
C36 Michelle 1 2 5 11 
C37 Stephanie 1 1 2 5 
C38 Gerald 1 2 4 6 
C39 Walter 1 1 3 7 
C4 Lisa 1 1 1 1 
C40 Christina 1 1 3 6 
C41 Brandon 1 2 3 7 
C42 Elizabeth 1 2 4 8 
C43 Joseph 1 2 4 6 
C44 Lawrence 1 1 3 4 
C45 Marilyn 1 1 1 3 
C46 Lori 1 2 3 9 
C47 Matthew 1 2 3 4 
C48 Jesse 1 1 3 3 
C49 John 1 1 3 8 
C5 Kimberly 1 2 3 9 
C50 Martha 1 1 2 5 
C51 Timothy 1 2 5 12 
C52 Christine 1 1 2 2 
C53 Anthony 1 1 1 1 
C54 Paula 1 2 4 7 
C55 Kimberly 1 2 2 3 
C56 Louise 1 1 1 3 
C57 Martin 1 1 2 5 
C58 Paul 1 2 4 8 
C59 Antonio 1 1 2 4 
C6 Bonnie 1 1 2 6 
C60 Jacqueline 1 1 1 2 
C61 Diana 1 1 1 1 
C62 John 1 2 5 11 
C63 Dorothy 1 2 5 7 
C64 Evelyn 1 1 1 2 
C65 Phillip 1 2 4 8 
C66 Evelyn 1 2 4 11 
C67 Debra 1 1 1 3 
C68 David 1 2 5 9 
C69 Willie 1 1 1 3 
C7 Michael 1 1 1 2 
C70 Brandon 1 2 4 7 
C71 Ann 1 2 5 10 
C72 Emily 1 2 3 7 
C73 Dorothy 1 1 1 2 
C74 Jonathan 1 2 4 7 
C75 Dorothy 1 1 2 4 
C76 Marilyn 1 2 5 12 
C77 Norma 1 2 5 10 
C78 Nancy 1 2 3 7 
C79 Andrew 1 1 2 2 
C8 Todd 1 1 1 3 
C80 Keith 1 1 1 2 
C81 Benjamin 1 1 3 9 
C82 Charles 1 1 2 3 
C83 Alan 1 2 3 4 
C84 Tammy 1 1 1 3 
C85 Anna 1 2 4 8 
C86 James 1 1 3 5 
C87 Robin 1 2 3 5 
C88 Jean 1 1 2 3 
C89 Andrew 1 2 4 7 
C9 Joe 1 1 3 6 
C90 Roy 1 1 2 3 
C91 Diana 1 2 2 2 
C92 Christina 1 1 1 3 
C93 Jesse 1 1 2 2 
C94 Joyce 1 2 5 13 
C95 Patricia 1 1 3 5 
C96 Gregory 1 1 2 2 
C97 Brian 1 1 1 1 
C98 Christine 1 1 2 5 
C99 Lillian 1 1 2 6 