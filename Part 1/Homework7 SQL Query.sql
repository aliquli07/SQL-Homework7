CREATE DATABASE Academy7
GO
USE Academy7
GO

Create TABLE Teachers(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
	Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
)

Create TABLE Assistants(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeacherId INT NOT NULL,
	FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

Create TABLE Curators(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeacherId INT NOT NULL,
	FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

Create TABLE Deans(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeacherId INT NOT NULL,
	FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

Create TABLE Heads(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TeacherId INT NOT NULL,
	FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

Create TABLE Faculties(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
	DeanId INT NOT NULL,
	FOREIGN KEY (DeanId) REFERENCES Deans(Id)
)

Create TABLE Departments(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
	FacultyId INT NOT NULL,
	HeadId INT NOT NULL,
	FOREIGN KEY (FacultyId) REFERENCES Faculties(Id),
	FOREIGN KEY (HeadId) REFERENCES Heads(Id)
)

Create TABLE Groups(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
	[Year] INT NOT NULL CHECK ([Year] BETWEEN 1 AND 5),
	DepartmentId INT NOT NULL,
	FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
)

Create TABLE GroupsCurators(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	CuratorId INT NOT NULL,
	GroupId INT NOT NULL,
	FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
	FOREIGN KEY (GroupId) REFERENCES Groups(Id)
)

Create TABLE Subjects(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
)

--Diqqet: PDF-de LectureRooms.Building 1-5 araligindadir, amma 9-cu sorgu 6-ci bina teleb edir.
--Ona gore bu cedvelde araliq 1-6 edilib.
Create TABLE LectureRooms(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 6),
	Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
)

Create TABLE Lectures(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	SubjectId INT NOT NULL,
	TeacherId INT NOT NULL,
	FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
	FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
)

Create TABLE GroupsLectures(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	GroupId INT NOT NULL,
	LectureId INT NOT NULL,
	FOREIGN KEY (GroupId) REFERENCES Groups(Id),
	FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
)

Create TABLE Schedules(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Class INT NOT NULL CHECK (Class BETWEEN 1 AND 8),
	DayOfWeek INT NOT NULL CHECK (DayOfWeek BETWEEN 1 AND 7),
	Week INT NOT NULL CHECK (Week BETWEEN 1 AND 52),
	LectureId INT NOT NULL,
	LectureRoomId INT NOT NULL,
	FOREIGN KEY (LectureId) REFERENCES Lectures(Id),
	FOREIGN KEY (LectureRoomId) REFERENCES LectureRooms(Id)
)
GO

--INSERTS (evvel esas cedveller, sonra elaqeli cedveller)
INSERT INTO Teachers (Name, Surname) VALUES
	('Edward', 'Hopper'),
	('Alex', 'Carmack'),
	('Samantha', 'Adams'),
	('John', 'Smith'),
	('Dave', 'McQueen'),
	('Linda', 'Taylor'),
	('Mark', 'Evans'),
	('Anna', 'Brown'),
	('Peter', 'Hall'),
	('Sophia', 'Young'),
	('Robert', 'King')

INSERT INTO Deans (TeacherId) VALUES (3), (9)

INSERT INTO Heads (TeacherId) VALUES (4), (5), (6)

INSERT INTO Curators (TeacherId) VALUES (7), (8), (10)

INSERT INTO Assistants (TeacherId) VALUES (10), (11)

INSERT INTO Faculties (Building, Name, DeanId) VALUES
	(1, 'Computer Science', 1),
	(2, 'Economics', 2)

INSERT INTO Departments (Building, Name, FacultyId, HeadId) VALUES
	(1, 'Software Development', 1, 1),
	(1, 'Information Systems', 1, 2),
	(3, 'Accounting', 2, 3)

INSERT INTO Groups (Name, [Year], DepartmentId) VALUES
	('F505', 5, 1),
	('P101', 1, 1),
	('D221', 5, 2),
	('A305', 3, 3)

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
	(1, 1),
	(2, 3),
	(3, 4)

INSERT INTO Subjects (Name) VALUES
	('Database Theory'),
	('Programming'),
	('Algorithms'),
	('Accounting Basics'),
	('Graphics')

INSERT INTO LectureRooms (Building, Name) VALUES
	(1, 'B103'),
	(1, 'B104'),
	(2, 'C201'),
	(6, 'A311'),
	(6, 'A104'),
	(3, 'D301'),
	(5, 'E501')

INSERT INTO Lectures (SubjectId, TeacherId) VALUES
	(1, 1),
	(2, 2),
	(3, 2),
	(5, 2),
	(4, 11),
	(1, 10),
	(2, 7),
	(3, 8),
	(2, 11)

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
	(1, 1), (1, 2), (1, 6), (1, 7), (1, 9),
	(2, 4),
	(3, 1), (3, 3), (3, 8),
	(4, 5)

INSERT INTO Schedules (Class, DayOfWeek, Week, LectureId, LectureRoomId) VALUES
	(1, 1, 1, 1, 1),
	(2, 3, 2, 1, 3),
	(3, 2, 1, 2, 4),
	(1, 4, 1, 3, 4),
	(2, 5, 1, 4, 5),
	(3, 3, 2, 7, 1),
	(1, 2, 1, 6, 2),
	(4, 4, 1, 8, 5),
	(2, 3, 1, 9, 6),
	(5, 1, 1, 5, 7)
GO

--1. Edward Hopper-in ders dediyi auditoriyalar
SELECT DISTINCT LR.Name
FROM Teachers T
JOIN Lectures L ON L.TeacherId = T.Id
JOIN Schedules S ON S.LectureId = L.Id
JOIN LectureRooms LR ON S.LectureRoomId = LR.Id
WHERE T.Name = 'Edward' AND T.Surname = 'Hopper'

--2. F505 qrupuna ders deyen assistentler
SELECT DISTINCT T.Name + ' ' + T.Surname AS Assistant_Name
FROM Assistants A
JOIN Teachers T ON A.TeacherId = T.Id
JOIN Lectures L ON L.TeacherId = T.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON GL.GroupId = G.Id
WHERE G.Name = 'F505'

--3. Alex Carmack-in 5-ci kurs qruplarina kecdiyi fennler
SELECT DISTINCT Sub.Name AS Subject_Name
FROM Teachers T
JOIN Lectures L ON L.TeacherId = T.Id
JOIN Subjects Sub ON L.SubjectId = Sub.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON GL.GroupId = G.Id
WHERE T.Name = 'Alex' AND T.Surname = 'Carmack' AND G.[Year] = 5

--4. Bazar ertesi (1) gunu ders demeyen muellimler
SELECT T.Name + ' ' + T.Surname AS Teacher_Name
FROM Teachers T
WHERE NOT EXISTS (
	SELECT 1
	FROM Lectures L
	JOIN Schedules S ON S.LectureId = L.Id
	WHERE L.TeacherId = T.Id AND S.DayOfWeek = 1
)

--5. 2-ci hefte, cercive gunu (3), 3-cu cut derste bos olan auditoriyalar ve binalari
SELECT LR.Name, LR.Building
FROM LectureRooms LR
WHERE NOT EXISTS (
	SELECT 1
	FROM Schedules S
	WHERE S.LectureRoomId = LR.Id
		AND S.Week = 2 AND S.DayOfWeek = 3 AND S.Class = 3
)

--6. Computer Science fakultesinin muellimleri (qruplarina ders deyenler),
--Software Development kafedrasinin qruplarina kuratorluq etmeyenler
SELECT DISTINCT T.Name + ' ' + T.Surname AS Teacher_Name
FROM Teachers T
JOIN Lectures L ON L.TeacherId = T.Id
JOIN GroupsLectures GL ON GL.LectureId = L.Id
JOIN Groups G ON GL.GroupId = G.Id
JOIN Departments D ON G.DepartmentId = D.Id
JOIN Faculties F ON D.FacultyId = F.Id
WHERE F.Name = 'Computer Science'
	AND NOT EXISTS (
		SELECT 1
		FROM Curators C
		JOIN GroupsCurators GC ON GC.CuratorId = C.Id
		JOIN Groups G2 ON GC.GroupId = G2.Id
		JOIN Departments D2 ON G2.DepartmentId = D2.Id
		WHERE C.TeacherId = T.Id AND D2.Name = 'Software Development'
	)

--7. Fakulte, kafedra ve auditoriya cedvellerindeki butun binalarin nomreleri
SELECT Building FROM Faculties
UNION
SELECT Building FROM Departments
UNION
SELECT Building FROM LectureRooms

--8. Muellimlerin tam adlari sira ile: dekanlar, kafedra mudirleri, muellimler, kuratorlar, assistentler
SELECT T.Name + ' ' + T.Surname AS Full_Name, 1 AS Sort_Order
FROM Teachers T
JOIN Deans D ON D.TeacherId = T.Id
UNION
SELECT T.Name + ' ' + T.Surname, 2
FROM Teachers T
JOIN Heads H ON H.TeacherId = T.Id
UNION
SELECT T.Name + ' ' + T.Surname, 3
FROM Teachers T
WHERE T.Id NOT IN (SELECT TeacherId FROM Deans)
	AND T.Id NOT IN (SELECT TeacherId FROM Heads)
	AND T.Id NOT IN (SELECT TeacherId FROM Curators)
	AND T.Id NOT IN (SELECT TeacherId FROM Assistants)
UNION
SELECT T.Name + ' ' + T.Surname, 4
FROM Teachers T
JOIN Curators C ON C.TeacherId = T.Id
UNION
SELECT T.Name + ' ' + T.Surname, 5
FROM Teachers T
JOIN Assistants A ON A.TeacherId = T.Id
ORDER BY Sort_Order, Full_Name

--9. 6-ci binadaki A311 ve A104 auditoriyalarinda ders olan heftenin gunleri (tekrarsiz)
SELECT DISTINCT S.DayOfWeek
FROM Schedules S
JOIN LectureRooms LR ON S.LectureRoomId = LR.Id
WHERE LR.Building = 6 AND LR.Name IN ('A311', 'A104')
