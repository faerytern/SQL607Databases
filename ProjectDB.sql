--Normally you should create tables in the order of key hierarchy - make what doesnt need any keys first, then add others that depend on it.
--Otherwise, you could create the tables without relationships, and then use ALTER TABLE queries after to set up the relationships.

CREATE TABLE DEPARTMENT (
DeptNo CHAR(4) PRIMARY KEY NOT NULL,
DeptName VARCHAR(25) NOT NULL,
DeptLocation VARCHAR(30) NULL);


CREATE TABLE EMPLOYEE (
  EmpNo INTEGER PRIMARY KEY NOT NULL, 
  EmpFirstName CHAR(20) NOT NULL,
  EmpLastName CHAR(20) NOT NULL,
  DeptNo CHAR(4) NULL FOREIGN KEY (DeptNo) REFERENCES DEPARTMENT(DeptNo));


CREATE TABLE PROJECT (
  ProjNo CHAR(4) PRIMARY KEY NOT NULL,
  ProjName VARCHAR(15) NOT NULL,
  ProjBudget DECIMAL(12,2) NULL);


CREATE TABLE WORKSON (
  EmpNo INTEGER FOREIGN KEY (EmpNo) REFERENCES EMPLOYEE(EmpNo) ON DELETE SET NULL,
  ProjNo CHAR(4) NOT NULL FOREIGN KEY (ProjNo) REFERENCES PROJECT(ProjNo) ON DELETE CASCADE,
  WonJob VARCHAR (15) NULL,
  WonEnterDate DATE NULL);



INSERT INTO DEPARTMENT VALUES ('d1', 'research','Dallas');
INSERT INTO DEPARTMENT VALUES ('d2', 'accounting','Seattle');
INSERT INTO DEPARTMENT VALUES ('d3', 'marketing','Dallas');

INSERT INTO EMPLOYEE VALUES(25348, 'Matthew', 'Smith'    ,'d3');
INSERT INTO EMPLOYEE VALUES(10102, 'Ann'    , 'Jones'    ,'d3');
INSERT INTO EMPLOYEE VALUES(18316, 'John'   , 'Barrimore','d1');
INSERT INTO EMPLOYEE VALUES(29346, 'James'  , 'James'    ,'d2');
INSERT INTO EMPLOYEE VALUES( 9031, 'Elsa'   , 'Bertoni'  ,'d2');
INSERT INTO EMPLOYEE VALUES( 2581, 'Elke'   , 'Hansel'   ,'d2');
INSERT INTO EMPLOYEE VALUES(28559, 'Sybill' , 'Moser'    ,'d1');


INSERT INTO PROJECT VALUES ('p1', 'Apollo', 120000.00);
INSERT INTO PROJECT VALUES ('p2', 'Gemini', 95000.00);
INSERT INTO PROJECT VALUES ('p3', 'Mercury', 186500.00);



INSERT INTO WORKSON VALUES (10102,'p1', 'analyst', '2006.10.1');
INSERT INTO WORKSON VALUES (10102, 'p3', 'manager', '2008.1.1');
INSERT INTO WORKSON VALUES (25348, 'p2', 'clerk', '2007.2.15');
INSERT INTO WORKSON VALUES (18316, 'p2', NULL, '2007.6.1');
INSERT INTO WORKSON VALUES (29346, 'p2', NULL, '2006.12.15');
INSERT INTO WORKSON VALUES (2581, 'p3', 'analyst', '2007.10.15');
INSERT INTO WORKSON VALUES (9031, 'p1', 'manager', '2007.4.15');
INSERT INTO WORKSON VALUES (28559, 'p1', NULL, '2007.8.1');
INSERT INTO WORKSON VALUES (28559, 'p2', 'clerk', '2008.2.1');
INSERT INTO WORKSON VALUES (9031, 'p3', 'clerk', '2006.11.15'); 
INSERT INTO WORKSON VALUES (29346, 'p1','clerk', '2007.1.4');


--SELECT * FROM EMPLOYEE;
--SELECT * FROM DEPARTMENT;
--SELECT * FROM PROJECT;
--SELECT * FROM WORKSON;
-- Calculated Fields
SELECT 
	ProjNo,
	ProjName,
	ProjBudget*.10 AS Increase,
	ProjBudget+ProjBudget*0.10 AS Total
	FROM PROJECT;

SELECT EmpNo,
	   trim(EmpFirstName) + ' ' + trim(EmpLastName) AS FullName
	FROM EMPLOYEE;

SELECT ProjNo, EmpNo, WonJob,
	   DATEDIFF(year,WonEnterDate,GETDATE()) AS YearsOnProject
	FROM WORKSON;

-- Unintended behaviour, just moves the decimal marker up and leaves a bunch of trailing zeroes
SELECT ProjName,
		ROUND( (ProjBudget/1000) , 3 ) 'Budget in Thousands (Lots of trailing decimal points despite ProjBudget being Decimal(12,2) )'
	FROM PROJECT;
-- Works as intended, Whole number then 2 dp
SELECT ProjName,
		ROUND(ProjBudget,3) 'Budget with 2dp added onto the end of the whole number'
	FROM PROJECT;
-- Workaround for the first problem, read https://stackoverflow.com/questions/50811639/sql-server-round-not-working
-- Using a decimal value in any calculation does not preserve the set decimal places and instead creates a new decimal(/orfloat?) that has many dp. This isn't changed properly by Round() either.
SELECT ProjName,
		ROUND( CONVERT(DECIMAL(18,2),(ProjBudget/1000) ),3) 'Method 1 Budget in Thousands with fixed decimal places'
	FROM PROJECT;

SELECT ProjName,
		ROUND( cast( (ProjBudget/1000)AS DECIMAL(18,2) ),3) 'Method 2 Budget in Thousands with fixed decimal places'
	FROM PROJECT;


-- Noted slide 6 alternative method to using datavalue AS customname

-- GroupBy
-- By one field
SELECT WonJob
  FROM WorksOn
  GROUP BY WonJob;
-- By two fields, duplicates WonJobs if ProjNo becomes different
SELECT ProjNo, WonJob
  FROM WORKSON
  GROUP BY ProjNo, WonJob

SELECT MIN(EmpNo) 'Lowest Employee Number' FROM EMPLOYEE;
-- Selects the lowest LastName sorted alphabetically
SELECT MIN(EmpLastName) 'LowestEmployeeLastName' FROM EMPLOYEE;

SELECT MIN(EmpNo) 'LowestEmpNo' FROM EMPLOYEE;

/*
SELECT EmpLastName , MIN(EmpNo ) FROM EMPLOYEE ; ? or
SELECT MIN (EmpNo), EmpLastName FROM EMPLOYEE ;
(? or) is a question to us on which query works - answer is neither lol
*/
-- Get the right output
/*
  SELECT EmpNo , EmpLastName FROM EMPLOYEE 
  WHERE EmpNo = SELECT MIN(EmpNo) FROM EMPLOYEE;
*/
--I AM A FOOL! THE ANSWER WAS RIGHT BELOW THE CHOICES ALL ALONG AND I ASSUMED IT WAS A DIFFERENT QUERY TO TRY
SELECT EmpNo 'Lowest Employee Number', EmpLastName 'Last Name' FROM EMPLOYEE
	WHERE EmpNo = (SELECT MIN(EmpNo) FROM EMPLOYEE);

-- This does not get the manager most recently appointed in the project, but rather 
--  gets the manager most recently appointed out of ALL projects
SELECT EmpNo FROM WORKSON
	WHERE WonEnterDate = 
		(SELECT MAX(WonEnterDate) FROM WORKSON WHERE WonJob = 'Manager');

              
-- As Dan pointed out, (Yes, the Dan Ouyang) It makes more sense to have DROP TABLEs at the bottom/end after you do all your processing. Also confuses the text editor less! Dan hates commments though, he's said that Chinese people keep notes, not comments, and don't care if someone else has to come along and take over because they only care about themselves and their own achievements. I like not having that mindset.    
-- Drop tables have a certain order too unless yu disable the relationships/keys first
-- eg. Workson references Project and Employee, but Workson isn't referenced by anything so drop it first
--     Now Project and Employee are free, remove them.
--     Now Department is not referenced since we removed Employee, so we can drop it.
DROP TABLE WORKSON;
DROP TABLE PROJECT;
DROP TABLE EMPLOYEE;
DROP TABLE DEPARTMENT;
