--1. "Teachers" bazasi ve ucun 2 cedvel (POSTS, TEACHERS)
CREATE DATABASE Teachers
GO
USE Teachers
GO

Create TABLE POSTS(
	Id INT PRIMARY KEY,
	Name NVARCHAR(20)
)

Create TABLE TEACHERS(
	Id INT PRIMARY KEY,
	Name NVARCHAR(15),
	Code CHAR(10),
	IdPost INT,
	Tel CHAR(7),
	Salary INT,
	Rise NUMERIC(6,2),
	HireDate DATETIME,
	CONSTRAINT FK_TEACHERS_POSTS FOREIGN KEY (IdPost) REFERENCES POSTS(Id)
)
GO

--2. POSTS cedvelini sil
--TEACHERS cedveli ona FOREIGN KEY ile bagli oldugu ucun evvelce bu elaqe silinmelidir
ALTER TABLE TEACHERS
DROP CONSTRAINT FK_TEACHERS_POSTS

DROP TABLE POSTS
GO

--3. TEACHERS cedvelinden IdPost sutununu sil
ALTER TABLE TEACHERS
DROP COLUMN IdPost
GO

--4. HireDate ucun mehdudiyyet: en azi 01/01/1990
ALTER TABLE TEACHERS
ADD CONSTRAINT CK_TEACHERS_HireDate CHECK (HireDate >= '19900101')
GO

--5. Code sutunu ucun UNIQUE mehdudiyyeti
ALTER TABLE TEACHERS
ADD CONSTRAINT UQ_TEACHERS_Code UNIQUE (Code)
GO

--6. Salary tipini INTEGER-den NUMERIC(6,2)-ye deyis
ALTER TABLE TEACHERS
ALTER COLUMN Salary NUMERIC(6,2)
GO

--7. Maas 1000-den az, 5000-den cox ola bilmez
ALTER TABLE TEACHERS
ADD CONSTRAINT CK_TEACHERS_Salary CHECK (Salary >= 1000 AND Salary <= 5000)
GO

--8. Tel sutununun adini Phone et
EXEC sp_rename 'TEACHERS.Tel', 'Phone', 'COLUMN'
GO

--9. Phone tipini CHAR(7)-den CHAR(11)-e deyis
ALTER TABLE TEACHERS
ALTER COLUMN Phone CHAR(11)
GO

--10. POSTS cedvelini yeniden yarat
Create TABLE POSTS(
	Id INT PRIMARY KEY,
	Name NVARCHAR(20)
)
GO

--11. POSTS.Name ucun vezife mehdudiyyeti (professor, assistant professor, teacher, assistant)
ALTER TABLE POSTS
ADD CONSTRAINT CK_POSTS_Name CHECK (Name IN ('Professor', 'Assistant Professor', 'Teacher', 'Assistant'))
GO

--12. TEACHERS.Name-de (soyad) reqem ola bilmez
ALTER TABLE TEACHERS
ADD CONSTRAINT CK_TEACHERS_Name CHECK (Name NOT LIKE '%[0-9]%')
GO

--13. TEACHERS cedvelinə IdPost (int) sutununu elave et
ALTER TABLE TEACHERS
ADD IdPost INT
GO

--14. TEACHERS.IdPost-u POSTS.Id ile bagla
ALTER TABLE TEACHERS
ADD CONSTRAINT FK_TEACHERS_POSTS FOREIGN KEY (IdPost) REFERENCES POSTS(Id)
GO

--15. Her iki cedveli doldur
--Qeyd: PDF-de 2-ci vezife 'Docent' yazilib. Docent = Assistant Professor, mehdudiyyete uygun olsun deye bele yazilib.
--Tarixler yyyymmdd formatindadir ki, tarixin oxunmasi dil ayarindan asili olmasin.
INSERT INTO POSTS (Id, Name) VALUES (1, N'Professor')
INSERT INTO POSTS (Id, Name) VALUES (2, N'Assistant Professor')
INSERT INTO POSTS (Id, Name) VALUES (3, N'Teacher')
INSERT INTO POSTS (Id, Name) VALUES (4, N'Assistant')

INSERT INTO TEACHERS (Id, Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES (1, N'Sidorov', '0123456789', 1, NULL, 1070, 470, '19920901')
INSERT INTO TEACHERS (Id, Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES (2, N'Ramishevsky', '4567890123', 2, '4567890', 1110, 370, '19980909')
INSERT INTO TEACHERS (Id, Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES (3, N'Horenko', '1234567890', 3, NULL, 2000, 230, '20011010')
INSERT INTO TEACHERS (Id, Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES (4, N'Vibrovsky', '2345678901', 4, NULL, 4000, 170, '20030901')
INSERT INTO TEACHERS (Id, Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES (5, N'Voropaev', NULL, 4, NULL, 1500, 150, '20020902')
INSERT INTO TEACHERS (Id, Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES (6, N'Kuzintsev', '5678901234', 3, '4567890', 3000, 270, '19910101')
GO

--16. VIEW-lar (CREATE VIEW batch-in ilk emri olmalidir, ona gore her birinin arasinda GO var)

--16.1. Butun vezifeler
CREATE VIEW V_AllPosts AS
SELECT Name AS Post_Name
FROM POSTS
GO

--16.2. Butun muellimlerin soyadlari
CREATE VIEW V_AllTeacherNames AS
SELECT Name AS Teacher_Name
FROM TEACHERS
GO

--16.3. Id, soyad, vezife, umumi maas (Salary + Rise), umumi maasa gore siralanmis
--Qeyd: view daxilinde ORDER BY ucun TOP lazimdir. Sira her zaman view-dan secende ORDER BY yazaraq tam temin olunur.
CREATE VIEW V_TeacherTotalSalary AS
SELECT TOP 100 PERCENT
	T.Id,
	T.Name AS Teacher_Name,
	P.Name AS Post_Name,
	T.Salary + T.Rise AS Total_Salary
FROM TEACHERS T
LEFT JOIN POSTS P ON T.IdPost = P.Id
ORDER BY Total_Salary
GO

--16.4. Id, soyad, telefon (yalniz telefonu olanlar)
CREATE VIEW V_TeachersWithPhone AS
SELECT Id, Name AS Teacher_Name, Phone
FROM TEACHERS
WHERE Phone IS NOT NULL
GO

--16.5. Soyad, vezife, ise qebul tarixi [dd/mm/yy]
CREATE VIEW V_HireDateShort AS
SELECT
	T.Name AS Teacher_Name,
	P.Name AS Post_Name,
	CONVERT(VARCHAR(8), T.HireDate, 3) AS Hire_Date
FROM TEACHERS T
LEFT JOIN POSTS P ON T.IdPost = P.Id
GO

--16.6. Soyad, vezife, ise qebul tarixi [dd month_text yyyy]
CREATE VIEW V_HireDateLong AS
SELECT
	T.Name AS Teacher_Name,
	P.Name AS Post_Name,
	FORMAT(T.HireDate, 'dd MMMM yyyy', 'en-US') AS Hire_Date
FROM TEACHERS T
LEFT JOIN POSTS P ON T.IdPost = P.Id
GO

--Yoxlama
SELECT * FROM V_AllPosts
SELECT * FROM V_AllTeacherNames
SELECT * FROM V_TeacherTotalSalary ORDER BY Total_Salary
SELECT * FROM V_TeachersWithPhone
SELECT * FROM V_HireDateShort
SELECT * FROM V_HireDateLong
