CREATE DATABASE ASSESSMENT;
USE ASSESSMENT;

CREATE TABLE Product(
Product_ID VARCHAR(3) PRIMARY KEY,
Product_Name VARCHAR(20),
Cost_Per_Item INT);

INSERT INTO Product VALUES
('P1','Pen', 10),
('P2','Scale', 15),
('P3','Note Book', 25);

SELECT * FROM Product;
Go

CREATE TABLE t_user_master(
User_ID VARCHAR(3) PRIMARY KEY,
User_Name VARCHAR(20));

INSERT INTO t_user_master VALUES
('U1','Alfred Lawrence'),
('U2','William Paul'),
('U3','Edward Fillip');

SELECT * FROM t_user_master ;
Go

CREATE TABLE t_transaction(
User_ID VARCHAR(3),
Product_ID VARCHAR(3),
Transaction_Date DATE,
Transaction_Type VARCHAR(10),
Transaction_Amount INT);

SELECT * FROM t_transaction;

INSERT INTO t_transaction VALUES
--('U1','P1','10-10-2010','Order',150),
('U1','P1','11-20-2010','Payment',750),
('U1','P1','11-20-2010','Order',200),
('U1','P3','11-25-2010','Order',50),
('U3','P2','11-26-2010','Order',100),
('U2','P1','12-15-2010','Order',75),
('U3','P2','01-15-2011','Payment',250);

--SELECT U.User_Name, P.Product_Name FROM t_user_master as U Full JOIN Product as P ON U.User_ID = P.Product_ID FULL JOIN t_transaction as t ON
--t.User_ID = t.Product_ID;

--SELECT U.User_Name, P.Product_Name FROM t_user_master as U Full JOIN t_transaction as t  ON U.User_ID = t.User_ID FULL JOIN  Product as P ON
--P.Product_ID = t.Product_ID;

--QUERY1
SELECT U.User_Name, P.Product_Name, Sum(t.Transaction_Amount / p.Cost_Per_Item) as Ordered_Quantity , SUM(Transaction_Amount) as Amount_Paid ,
MAX(Transaction_date) as Last_transaction_date ,(SUM(Transaction_Amount) - (Sum(t.Transaction_Amount / p.Cost_Per_Item) *  p.Cost_Per_Item)) as Balance 
FROM t_user_master as U Full JOIN t_transaction as t  ON U.User_ID = t.User_ID FULL JOIN  Product as P ON
P.Product_ID = t.Product_ID GROUP BY User_Name, Product_Name , Cost_Per_Item;



--ordered qty
--SELECT t.Transaction_Amount / p.Cost_Per_Item as Ordered_Quantity From t_transaction as t JOIN Product as p ON t.Product_ID = p.Product_ID;
--



--QUERY2
CREATE TABLE employees
(employee_id INT PRIMARY KEY,
name VARCHAR(30),
department VARCHAR(30),
hire_date DATE);

INSERT INTO employees VALUES
--(1, 'MAY' , 'HR' , '01-01-2000')
(2, 'JOE' , 'DEV' , '02-01-2000'),
(3, 'NOAH' , 'IT' , '03-01-2000'),
(4, 'FIN' , 'HR' , '04-01-2000');

SELECT * FROM employees;
GO

CREATE TABLE departments
(department_id INT PRIMARY KEY,
department_name VARCHAR(30));

INSERT INTO departments VALUES
(1,'IT'),
(2,'HR'),
(3,'DEV'),
(4,'FIN');

SELECT * FROM departments;
GO

CREATE TABLE sales
(sale_id INT PRIMARY KEY,
employee_id INT FOREIGN KEY REFERENCES	employees(employee_id),
sale_date DATE,
amount DECIMAL
);

INSERT INTO sales VALUES
(1,1,'02-02-2003',100), 
(2,2,'03-02-2004',50), 
(3,1,'04-02-2002',1000), 
(4,3,'05-02-2001',500), 
(5,4,'06-02-2003',20);


SELECT * FROM sales;


CREATE TABLE performance_reviews
(review_id INT PRIMARY KEY , 
employee_id INT FOREIGN KEY REFERENCES employees(employee_id),
review_date DATE ,
score INT);

INSERT INTO performance_reviews VALUES
(1,1,'03-03-2005',9),
(2,2,'03-04-2005',7),
(3,3,'03-05-2005',8),
(4,4,'03-06-2005',6);

SELECT * FROM performance_reviews;


--Q1
WITH RankedEmployees As(
	SELECT 
			Employee_id,
			SUM(amount) as total_sales,
			Rank() OVER (ORDER BY sum(amount) DESC ) AS Rank
    FROM 
        sales 
	GROUP BY
	employee_id

	)

SELECT 
    employee_id,total_sales
FROM 
    Rankedemployees
ORDER BY 
      Rank;
	



	SELECT 
			e.employee_id,
			e.department,
			AVG(score) as score,
			DENSE_Rank() OVER ( PARTITION BY  e.department ORDER BY AVG(score) DESC ) AS Rank
    FROM 
        performance_reviews as p JOIN employees as e ON e.employee_id = p.employee_id
	GROUP BY
	e.employee_id, e.department

--SELECT 
--    employee_id, score, rank
--FROM 
--    Rankedemployees1
ORDER BY
    score DESC,  Rank;



	--q3
	SELECT * FROM(
	SELECT
	ep.employee_id,
	ep.name,
	ep.department,
	sum(sl.amount) as salesAmount,
	ROW_NUMBER() OVER (PARTITION BY ep.department ORDER BY SUM(Sl.amount) DESC) AS Rank
	FROM 
	employees as ep 
	join sales as sl on sl.employee_id = ep.employee_id

	Group by
		ep.employee_id,
		ep.name,
		ep.department)
		AS RANK1 WHERE RANK <=3;

--Q4

SELECT * FROM(
	SELECT
	ep.employee_id,
	ep.name,
	ep.department,
    p.score,     
	sum(sl.amount) as salesAmount,
	ROW_NUMBER() OVER (PARTITION BY ep.department ORDER BY SUM(Sl.amount) DESC) AS Rank
	FROM 
	employees as ep 
	join sales as sl on sl.employee_id = ep.employee_id
	join performance_reviews as p ON p.employee_id = ep.employee_id

	Group by
		ep.employee_id,
		ep.name,
		ep.department,
        p.score    
		)
		AS RANK1 WHERE RANK <=1;










