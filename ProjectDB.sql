--DROP TABLE WORKSON;
--DROP TABLE PROJECT;
--DROP TABLE EMPLOYEE;
--DROP TABLE DEPARTMENT;

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

--1 List employee number and the project number for all employees working on the MERCURY PROJECT
SELECT WORKSON.EmpNo, PROJECT.ProjNo
  FROM WORKSON, PROJECT
  WHERE WORKSON.ProjNo = PROJECT.ProjNo AND ProjName = 'Mercury';

--2 List employee number and the project number for all employees working on projects with budgets greater than $100,000 (one hundred thousand)
SELECT WORKSON.EmpNo, WORKSON.ProjNo 
  FROM WORKSON, PROJECT
  WHERE WORKSON.ProjNo = PROJECT.ProjNo AND ProjBudget > 100000;

--3 List department name, first name, last name sorted by department name, and last name within department name.
SELECT DEPARTMENT.DeptName, EMPLOYEE.EmpFirstName, EMPLOYEE.EmpLastName 
  FROM DEPARTMENT, EMPLOYEE
  WHERE DEPARTMENT.DeptNo = EMPLOYEE.DeptNo
  ORDER BY DEPARTMENT.DeptName, EmpLastName;

--4 List all employees that have been assigned to a project with a job,
--    the project name, first name, last name, enter date. Sort by enter date descending
SELECT PROJECT.ProjName, EMPLOYEE.EmpFirstName,EMPLOYEE.EmpLastName, WORKSON.WonEnterDate
  FROM WORKSON, EMPLOYEE, PROJECT
  WHERE WORKSON.WonJob IS NOT NULL
  AND PROJECT.ProjNo = WORKSON.ProjNo
  AND EMPLOYEE.EmpNo = workson.EmpNo
  ORDER BY WORKSON.WonEnterDate DESC;

--5  List all department fields and employee fields, for each of an Inner Join, Left Outer Join, Right Outer Join, Full Outer Join
SELECT * FROM DEPARTMENT INNER JOIN EMPLOYEE ON DEPARTMENT.DeptNo = EMPLOYEE.DeptNo;

SELECT * FROM DEPARTMENT LEFT OUTER JOIN EMPLOYEE ON DEPARTMENT.DeptNo = EMPLOYEE.DeptNo;

SELECT * FROM DEPARTMENT RIGHT OUTER JOIN EMPLOYEE ON DEPARTMENT.DeptNo = EMPLOYEE.DeptNo;

SELECT * FROM DEPARTMENT FULL OUTER JOIN EMPLOYEE ON DEPARTMENT.DeptNo = EMPLOYEE.DeptNo;

--6 User an outer join to list the department with no employees assigned to the department (Is supposed to get an empty table since there isnt any with none assigned)
SELECT * 
 FROM DEPARTMENT FULL OUTER JOIN EMPLOYEE 
 ON EMPLOYEE.DeptNo = DEPARTMENT.DeptNo
 WHERE EMPLOYEE.DeptNo IS NULL;

--7 Use a Cross Join of department and employee
SELECT * FROM DEPARTMENT CROSS JOIN EMPLOYEE; -- OR below also works since it's just 2 tables
SELECT * FROM DEPARTMENT, EMPLOYEE;

--8 For department number run a INTERSECT, UNION, and UNION ALL set join for department and employee
SELECT DeptNo FROM DEPARTMENT
  INTERSECT 
SELECT DeptNo FROM EMPLOYEE;

SELECT DeptNo FROM DEPARTMENT
  UNION 
SELECT DeptNo FROM EMPLOYEE;

SELECT DeptNo FROM DEPARTMENT
  UNION ALL 
SELECT DeptNo FROM EMPLOYEE;


DROP TABLE WORKSON;
DROP TABLE PROJECT;
DROP TABLE EMPLOYEE;
DROP TABLE DEPARTMENT;
