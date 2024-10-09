--CREATING A DATABASE AND USING IT
CREATE DATABASE TutorialDB
GO

use TutorialDB;
GO


--CREATING A TABLE AND INSERTING VALUES
CREATE TABLE  manager(
Manager_id int PRIMARY KEY ,
Manager_name VARCHAR(20) NOT NULL);

INSERT INTO manager VALUES 
(1, 'Rohan'),
(2, 'Yaid'),
(3,'Zohan');

SELECt *  from manager;
GO

--USING DDL COMMANDS 
ALTER TABLE manager 
ADD age INT DEFAULT 18 NOT NULL;
GO
ALTER TABLE manager
ADD age INT;
GO
--ADDING DATE
ALTER TABLE manager
ADD date DATE;

ALTER TABLE manager 
DROP Column Manager_id;
GO
DROP TABLE Student;
GO

--AUTO INCREMENT ON PERSON_ID
CREATE TABLE Persons (
    Personid int IDENTITY(1,1) PRIMARY KEY,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
);
GO

--RENAMING COLUMN NAME TO NEW NAME USING STORED PROCEDURE
EXEC sp_rename 'manager.age',  'My_age', 'COLUMN';
GO


--USING DML COMMNADS
DELETE from manager
where My_age = 18;
GO

--USING UPDATE
UPDATE manager
SET age = 25
WHERE Manager_id = 3;
GO

UPDATE manager
SET date = '2024-06-09'
where Manager_id = 1;

--ADDING THE FOREIGN KEY CONSTRAINT
CREATE TABLE student (
Student_id INT PRIMARY KEY,
Student_name VARCHAR(30),
Manager_id INT REFERENCES manager(Manager_id));
GO

--DQL
SELECT * FROM manager
WHERE Manager_name = 'Rohan';
GO

--CREATING INDEX
CREATE INDEX Manager_name_idx
ON manager(manager_name);

--WORKING WITH VIEWS
CREATE VIEW My_view as
SELECT * FROM manager 
WHERE Manager_id = 1;

Select * From My_view;

--WORKING WITH GROUUP BY AND HAVING
ALTER TABLE manager
ADD Department VARCHAR(10);

UPDATE manager
SET Department = 'HR'
WHERE Manager_id = 3;

--COUNTING NUMBER OF EMPLOYEESIN EACH DEPARTMENT
SELECT Count(Manager_id) AS COUNT_OF_EMP, Department
From Manager GROUP BY Department;

SELECT Count(Manager_id) AS COUNT_OF_EMP, Department
From Manager GROUP BY Department
HAVING AVG(age) >= 20;

SELECT Count(Manager_id) AS COUNT_OF_EMP, Department
From Manager GROUP BY Department
HAVING age >= 20;

--JOINS
SELECT E.Emp_name as Employee , M.Manager_name as Manager From Employee as e  
Inner JOIN Manager as M
ON e.emp_id = m.manager_id;


