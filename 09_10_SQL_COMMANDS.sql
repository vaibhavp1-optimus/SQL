CREATE DATABASE TutorialDB2;
USE TutorialDB2;

CREATE TABLE Persons(
id INT PRIMARY KEY,
Name VARCHAR(20),
)

INSERT INTO Persons VALUES
(1,'AJAY'),
(2,'VIJAY'),
(3,'ROHAN'),
(4,'ADITYA');

SELECT * from Persons
ORDER BY ID DESC;


--USING ANY AND ALL
SELECT ProductName
FROM Products
WHERE ProductID = ANY
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity > 99);



