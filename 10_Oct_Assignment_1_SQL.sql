use [TutorialDB]


CREATE TABLE Species (
SpeciesID int PRIMARY KEY,
CommonName VARCHAR(max),
ScientificName VARCHAR(max),
Habitat CHAR(10),
Venomous bit
);

INSERT INTO Species (SpeciesID, CommonName, ScientificName, Habitat, Venomous)
VALUES 
(1, 'King Cobra', 'Ophiophagus hannah', 'Forests', 1),
(2, 'Bald Eagle', 'Haliaeetus leucocephalus', 'Mountains', 0),
(3, 'Great White Shark', 'Carcharodon carcharias', 'Oceans', 0),
(4, 'Komodo Dragon', 'Varanus komodoensis', 'Islands', 1),
(5, 'African Elephant', 'Loxodonta africana', 'Savannah', 0);


SELECT * FROM Species;
GO;

CREATE TABLE Snakes (
SnakeID int PRIMARY KEY,
SpeciesID int  FOREIGN KEY REFERENCES Species(SpeciesID),
Lengthh float,
Age int,
Color CHAR(10),
);

INSERT INTO Snakes (SnakeID, SpeciesID, Lengthh, Age, Color)
VALUES 
(1, 1, 3.5, 5, 'Brown'),
(2, 1, 4.2, 7, 'Green'),
(3, 4, 2.8, 3, 'Gray'),
(4, 4, 3.1, 4, 'Black'),
(5, 1, 5.0, 6, 'Yellow'),
(6, 1, 13.5, 5, 'Brown'),
(7, 1, 42.2, 7, 'Green'),
(8, 4, 2.18, 3, 'Gray'),
(9, 4, 32.1, 4, 'Black'),
(10, 1, 51.0, 6, 'Yellow'),
(11, 1, 34.5, 5, 'Brown'),
(12, 1, 45.2, 7, 'Green'),
(13, 4, 23.8, 3, 'Gray'),
(14, 4, 37.1, 4, 'Black'),
(15, 1, 59.0, 6, 'Yellow');

SELECT * FROM Snakes;
GO;


CREATE TABLE Sightings (
SightingID int PRIMARY KEY,
SnakeID int  FOREIGN KEY REFERENCES Snakes(SnakeID),
Locationn VARCHAR(max),
SightingDate DATE ,
Observer CHAR(10),
);

INSERT INTO Sightings (SightingID, SnakeID, Locationn, SightingDate, Observer)
VALUES 
(1, 1, 'Amazon Rainforest', '2024-01-15', 'Alice'),
(2, 2, 'Sundarbans', '2024-02-20', 'Bob'),
(3, 3, 'Komodo Island', '2024-03-10', 'Charlie'),
(4, 4, 'Galapagos Islands', '2024-04-05', 'Diana'),
(5, 5, 'Everglades', '2024-05-25', 'Eve'),
(6, 2, 'Sundarbans', '2024-02-20', 'Bob'),
(7, 3, 'Komodo Island', '2024-03-10', 'Bob'),
(8, 4, 'Galapagos Islands', '2024-04-05', 'Diana'),
(9, 5, 'Everglades', '2024-05-25', 'Eve'),
(10, 2, 'Sundarbans', '2024-02-20', 'Bob'),
(11, 2, 'Komodo Island', '2024-03-10', 'Bob'),
(12, 2, 'Galapagos Islands', '2024-04-05', 'Diana'),
(13, 2, 'Everglades', '2024-05-25', 'Eve'),
(14, 2, 'Sundarbans', '2024-02-20', 'Bob'),
(15, 2, 'Komodo Island', '2024-03-10', 'Bob'),
(16, 2, 'Galapagos Islands', '2024-04-05', 'Diana'),
(17, 2, 'Everglades', '2024-05-25', 'Eve'),
(18, 2, 'Everglades', '2024-05-25', 'Alice');

SELECT * FROM Sightings;
GO;


CREATE TABLE ConservationStatus (
StatusID int PRIMARY KEY,
SpeciesID int  FOREIGN KEY REFERENCES Species(SpeciesID),
Statuss VARCHAR(max),
LastUpdated DATE
);
INSERT INTO ConservationStatus (StatusID, SpeciesID, Statuss, LastUpdated)
VALUES 
--(1, 1, 'Endangered', '2024-01-01'),
--(2, 2, 'Least Concern', '2024-02-15'),
--(3, 3, 'Vulnerable', '2024-03-20'),
--(4, 4, 'Critically Endangered', '2024-04-10'),
--(5, 5, 'Near Threatened', '2024-05-05'),
(6, 1, 'Vulnerable', '1990-01-01'),
(7, 2, 'Endangered', '1995-02-15'),
(8, 3, 'Endangered', '1999-03-20'),
(9, 4, 'Endangered', '1992-04-10'),
(10, 5, 'Endangered', '1993-05-05');

SELECT * FROM ConservationStatus;
GO;

--Q1
SELECT s.SightingID , s.SnakeID , s.Locationn , s.SightingDate , s.Observer FROM Sightings as s 
JOIN
Snakes as sn
ON s.SnakeID = sn.SnakeID
JOIN Species as sp	
ON sp.SpeciesID = sn.SpeciesID
Where CommonName = 'King Cobra';

--Q2
SELECT SpeciesId , AVG(Lengthh) AS Average_Length FROM Snakes GROUP BY SpeciesID;

GO

--Q3
--SELECT SnakeID  FROM Snakes
--GROUP BY SnakeID 
--HAVING Lengthh > 
--ORDER BY Lengthh DESC;
--FIND THE TOP 5 LONGEST SNAKES FOR EACH SNAKE
WITH RankedSnakes AS (
    SELECT 
        SnakeID,
        SpeciesID,
        Lengthh,
        Age,
        Color,
        ROW_NUMBER() OVER (PARTITION BY SpeciesID ORDER BY Lengthh DESC) AS Rank
    FROM 
        Snakes
)
SELECT 
    SnakeID,
    SpeciesID,
    Lengthh,
    Age,
    Color
FROM 
    RankedSnakes
WHERE 
    Rank <= 5
ORDER BY 
    SpeciesID , Rank;

--Q4
SELECT TOP 1 Observer, COUNT(Observer)as no_of_obs FROM Sightings
GROUP BY Observer
ORDER BY COUNT(DISTINCT Observer) DESC;

GO

--Q5

SELECT c.SpeciesID , c.LastUpdated , c.Statuss, s.CommonName FROM ConservationStatus as c JOIN
Species as s ON s.SpeciesID = c.SpeciesID
ORDER BY SpeciesID,LastUpdated;

go

 
--Q6
--SELECT DISTINCT snk.SpeciesID , c.statuss FROM Snakes as snk JOIN Sightings as sight
--ON snk.SnakeID = sight.snakeID
--JOIN 
--ConservationStatus as c
--ON c.SpeciesID = Snk.SpeciesID
--WHERE c.statuss = 'endangered'
--and snk.snakeID in (SELECT SnakeID  From Sightings
--WHERE (Select Count(snakeID) From Sightings)> 10);


SELECT DISTINCT snk.SpeciesID, c.Statuss
FROM Snakes AS snk
JOIN Sightings AS sight ON snk.SnakeID = sight.SnakeID
JOIN ConservationStatus AS c ON c.SpeciesID = snk.SpeciesID
WHERE c.Statuss = 'Endangered'
AND snk.SnakeID IN (
    SELECT SnakeID
    FROM Sightings
    GROUP BY SnakeID
    HAVING COUNT(SnakeID) > 10
);









