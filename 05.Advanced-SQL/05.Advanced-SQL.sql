---------------------------------------------------------------------------------------------------
--Problem 1.	Write a SQL query to find the names and salaries of the employees 
--that take the minimal salary in the company.

SELECT e.FirstName, e.LastName, e.Salary
FROM Employees e
WHERE e.Salary = 
	(
		SELECT MIN(m.Salary)
		FROM Employees m
	)

---------------------------------------------------------------------------------------------------
--Problem 2.	Write a SQL query to find the names and salaries of the employees 
--that have a salary that is up to 10% higher than the minimal salary for the company.

SELECT e.FirstName, e.LastName, e.Salary
FROM Employees e
WHERE e.Salary <= 
	(
		SELECT MIN(m.Salary)
		FROM Employees m
	) * 1.1

---------------------------------------------------------------------------------------------------
--Problem 3.	Write a SQL query to find the full name, salary and department of the employees 
--that take the minimal salary in their department.

SELECT
	e.FirstName + ' ' + ISNULL(e.MiddleName, '') + ' ' + e.LastName [Employee Name],
	e.Salary, 
	d.Name [Department Name]
FROM Employees e
JOIN Departments D
	ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = 
	(
		SELECT MIN(m.Salary)
		FROM Employees m
		WHERE e.DepartmentID = m.DepartmentID
	)

---------------------------------------------------------------------------------------------------
--Problem 4.	Write a SQL query to find the average salary in the department #1.

SELECT e.DepartmentID, d.Name, AVG(e.Salary)
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE e.DepartmentID = 1
GROUP BY e.DepartmentID, d.Name

---------------------------------------------------------------------------------------------------
--Problem 5.	Write a SQL query to find the average salary in the "Sales" department.

SELECT AVG(e.Salary) [Average Salary for Sales Department]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'

---------------------------------------------------------------------------------------------------
--Problem 6.	Write a SQL query to find the number of employees in the "Sales" department.

SELECT COUNT(*) [Sales Employees Count]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'

---------------------------------------------------------------------------------------------------
--Problem 7.	Write a SQL query to find the number of all employees that have manager.

SELECT COUNT(*) [Employees with manager]
FROM Employees e
WHERE e.ManagerID IS NOT NULL

---------------------------------------------------------------------------------------------------
--Problem 8.	Write a SQL query to find the number of all employees that have no manager.

SELECT COUNT(*) [Employees with manager]
FROM Employees e
WHERE e.ManagerID IS NULL

---------------------------------------------------------------------------------------------------
--Problem 9.	Write a SQL query to find all departments and the average salary for each of them.

SELECT d.Name Department, AVG(e.Salary) [Average Salary]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name

---------------------------------------------------------------------------------------------------
--Problem 10.	Write a SQL query to find the count of all employees in each department and for each town.

SELECT t.Name Town, d.Name Department, COUNT(*) [Employees count]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
JOIN Addresses a
	ON e.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID
GROUP BY t.Name, d.Name

---------------------------------------------------------------------------------------------------
--Problem 11.	Write a SQL query to find all managers that have exactly 5 employees.

SELECT m.FirstName + ' ' + m.LastName [Manager Name], COUNT(*) [Employees count]
FROM Employees e
RIGHT OUTER JOIN Employees m
	ON e.ManagerID = m.EmployeeID
GROUP BY m.FirstName + ' ' + m.LastName
HAVING COUNT(*) = 5

---------------------------------------------------------------------------------------------------
--Problem 12.	Write a SQL query to find all employees along with their managers.

SELECT e.FirstName + ' ' + e.LastName [Employee Name], ISNULL(m.FirstName + ' ' + m.LastName, 'No manager') [Manager Name]
FROM Employees e
LEFT OUTER JOIN Employees m
	ON e.ManagerID = m.EmployeeID

---------------------------------------------------------------------------------------------------
--Problem 13.	Write a SQL query to find the names of all employees whose last name is exactly 5 characters long. 

SELECT e.FirstName, e.LastName
FROM Employees e
WHERE LEN(e.LastName) = 5

---------------------------------------------------------------------------------------------------
--Problem 14.	Write a SQL query to display the current date and time in the following format "day.month.year hour:minutes:seconds:milliseconds".

SELECT CONVERT(NVARCHAR(10),GETDATE(),104) + ' ' + CONVERT(NVARCHAR(12),GETDATE(),114) [Date Time]

---------------------------------------------------------------------------------------------------
--Problem 15.	Write a SQL statement to create a table Users.
--Users should have username, password, full name and last login time. Choose appropriate data types for the table fields.
--Define a primary key column with a primary key constraint. Define the primary key column as identity to facilitate inserting records. 
--Define unique constraint to avoid repeating usernames. Define a check constraint to ensure the password is at least 5 characters long.

CREATE TABLE Users (
	UserID int IDENTITY,
	UserName NVARCHAR(100) NOT NULL UNIQUE,
	Password NVARCHAR(128) NOT NULL,
	FullName NVARCHAR(200) NOT NULL,
	LastLoginTime DATETIME,
	CONSTRAINT PK_Users PRIMARY KEY(UserID),
	CONSTRAINT CK_Users_Password CHECK (LEN(Password) > 5)
)

---------------------------------------------------------------------------------------------------
--Problem 16.	Write a SQL statement to create a view that displays the users from the Users table 
--that have been in the system today.

CREATE VIEW [Today Visitors] AS
SELECT u.FullName [User Name], CONVERT(NVARCHAR(10), u.LastLoginTime, 104) [Last Login Time]
FROM Users u
WHERE CONVERT(DATE, u.LastLoginTime) = CONVERT(DATE, GETDATE())

---------------------------------------------------------------------------------------------------
--Problem 17.	Write a SQL statement to create a table Groups.
--Groups should have unique name (use unique constraint). Define primary key and identity column.

CREATE TABLE Groups (
	GroupID int IDENTITY,
	Name NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Groups PRIMARY KEY(GroupID),
	CONSTRAINT UK_Groups_Name UNIQUE(Name)
)

---------------------------------------------------------------------------------------------------
--Problem 18.	Write a SQL statement to add a column GroupID to the table Users.

ALTER TABLE Users ADD GroupID int

ALTER TABLE Users
ADD CONSTRAINT FK_Users_Groups
	FOREIGN KEY(GroupID)
	REFERENCES Groups(GroupID)

---------------------------------------------------------------------------------------------------
--Problem 19.	Write SQL statements to insert several records in the Users and Groups tables.

INSERT INTO Groups(Name)
VALUES ('moderator'), ('golden');

INSERT INTO Users(UserName, Password, FullName, LastLoginTime, GroupID)
VALUES
	('goshko', 123456, 'Gosho Goshev', GETDATE(), 1),
	('peshko', 654321, 'Pesho Peshev', CONVERT(DATE, '06-23-2015'), 2)

---------------------------------------------------------------------------------------------------
--Problem 20.	Write SQL statements to update some of the records in the Users and Groups tables.

UPDATE Users
    SET UserName = 'gosho',
		FullName = 'Goshko'
    WHERE UserName = 'goshko'

UPDATE Groups
	SET Name = 'advanced'
	WHERE GroupID = 2

---------------------------------------------------------------------------------------------------
--Problem 21.	Write SQL statements to delete some of the records from the Users and Groups tables.

DELETE FROM Users
WHERE UserName = 'gosho';

DELETE FROM Groups
WHERE Name = 'advanced';

---------------------------------------------------------------------------------------------------
--Problem 22.	Write SQL statements to insert in the Users table the names of all employees
--from the Employees table.

INSERT INTO Users (UserName, Password, FullName, LastLoginTime, GroupID)
	SELECT
		LOWER(e.FirstName) + LOWER(e.LastName),
		LOWER(LEFT(e.FirstName, 5)) + LOWER(RIGHT(e.LastName, 5)) + 'mypass',
		e.FirstName + ' ' + ISNULL(e.MiddleName, '') + ' ' + e.LastName,
		e.HireDate,
		NULL
	FROM Employees e

---------------------------------------------------------------------------------------------------
--Problem 23.	Write a SQL statement that changes the password to NULL for all users 
--that have not been in the system since 10.03.2010.

ALTER TABLE Users
ALTER COLUMN Password NVARCHAR(128) NULL

UPDATE Users
	SET Password = NULL
	WHERE LastLoginTime < CONVERT(DATE, '12-31-2003')

---------------------------------------------------------------------------------------------------
--Problem 24.	Write a SQL statement that deletes all users without passwords (NULL password).

ALTER TABLE Users
ALTER COLUMN Password NVARCHAR(128) NULL

DELETE FROM Users
WHERE Password IS NULL

---------------------------------------------------------------------------------------------------
--Problem 25.	Write a SQL query to display the average employee salary by department and job title.

SELECT d.Name [Department], e.JobTitle [Job Title], AVG(e.Salary) [Average Salary]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, e.JobTitle, d.Name

---------------------------------------------------------------------------------------------------
--Problem 26.	Write a SQL query to display the minimal employee salary by department and job title
--along with the name of some of the employees that take it.

SELECT 
	d.Name [Department], 
	e.JobTitle [Job Title],
	e.FirstName + ' ' + e.LastName [Employee], 
	e.Salary [Salary]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle, e.FirstName + ' ' + e.LastName, e.Salary, e.DepartmentID
HAVING e.Salary = (
		SELECT MIN(m.Salary)
		FROM Employees m
		WHERE e.DepartmentID = m.DepartmentID AND e.JobTitle = m.JobTitle
	)

---------------------------------------------------------------------------------------------------
--Problem 27.	Write a SQL query to display the town where maximal number of employees work.

SELECT TOP 1 t.Name [Town], COUNT(e.EmployeeID) [Number of employees]
FROM Employees e
JOIN Addresses a
	ON e.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID
GROUP BY t.Name
ORDER BY COUNT(e.EmployeeID) DESC

---------------------------------------------------------------------------------------------------
--Problem 28.	Write a SQL query to display the number of managers from each town.

SELECT t.Name [Town], COUNT(DISTINCT e.ManagerID) [Number of managers]
FROM Employees e
JOIN Employees m
	ON e.ManagerID = m.EmployeeID
JOIN Addresses a
	ON m.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID
GROUP BY t.Name, t.TownID
ORDER BY t.Name

---------------------------------------------------------------------------------------------------
--Problem 29.	Write a SQL to create table WorkHours to store work reports for each employee.

CREATE TABLE WorkHours (
	WorkHoursEmployeeID int IDENTITY NOT NULL,
	WorkDate DATE NOT NULL,
	Task NVARCHAR(MAX) NOT NULL,
	WorkHours int NOT NULL,
	Comments NVARCHAR(MAX),
	EmployeeID int NOT NULL,
	CONSTRAINT PK_WorkHours PRIMARY KEY(WorkHoursEmployeeID),
	CONSTRAINT FK_WorkHours_Employees FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID)
)

---------------------------------------------------------------------------------------------------
--Problem 30.	Issue few SQL statements to insert, update and delete of some data in the table.

INSERT INTO WorkHours(WorkDate, Task, WorkHours, Comments, EmployeeID)
VALUES
	(CONVERT(DATE, '06-29-2015'), 'Starting new project - VENICIUS', 6, NULL, 3),
	(CONVERT(DATE, '07-01-2015'), 'Programming server-side project - VENICIUS', 24, NULL, 74),
	(CONVERT(DATE, '07-06-2015'), 'Programming client-side project - VENICIUS', 40, NULL, 263),
	(CONVERT(DATE, '07-06-2015'), 'Quality management project - VENICIUS', 32, NULL, 41),
	(CONVERT(DATE, '07-06-2015'), 'Presentation project - VENICIUS', 8, NULL, 109)

UPDATE WorkHours
	SET WorkHours = 32
	WHERE EmployeeID = 74

DELETE FROM WorkHours
WHERE Task = 'Presentation project - VENICIUS'

---------------------------------------------------------------------------------------------------
--Problem 31.	Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.

CREATE TABLE WorkHoursLogs (
	WorkHoursLogID int IDENTITY NOT NULL PRIMARY KEY,
	WorkHoursID int NOT NULL,
	OldEmployeeID int NOT NULL,
	NewEmployeeID int NOT NULL,
	OldWorkDate DATE NOT NULL,
	NewWorkDate DATE NOT NULL,
	OldTask	NVARCHAR(MAX) NOT NULL,
	NewTask NVARCHAR(MAX) NOT NULL,
	OldWorkHours int NOT NULL,
	NewWorkHours int NOT NULL,
	OldComments NVARCHAR(MAX),
	NewComments NVARCHAR(MAX),
	Command NVARCHAR(100)
)

GO

CREATE TRIGGER tr_WorkHoursUpdate ON WorkHours FOR UPDATE
AS
BEGIN
INSERT INTO WorkHoursLogs (
	WorkHoursID,
	OldEmployeeID,
	NewEmployeeID,
	OldWorkDate,
	NewWorkDate,
	OldTask,
	NewTask,
	OldWorkHours,
	NewWorkHours,
	OldComments,
	NewComments,
	Command )
SELECT
	d.WorkHoursEmployeeID,
	d.EmployeeID,
	i.EmployeeID,
	d.WorkDate,
	i.WorkDate,
	d.Task,
	i.Task,
	d.WorkHours,
	i.WorkHours,
	d.Comments,
	i.Comments,
	'UPDATE'
	FROM 
		DELETED d,
		INSERTED i
END
GO

UPDATE WorkHours
	SET WorkDate = GETDATE(),
		Task = 'Starting new best project - VENICIUS',
		WorkHours = 8,
		Comments = 'Changing date project - VENICIUS'
	WHERE WorkHoursEmployeeID = 1

---------------------------------------------------------------------------------------------------
--Problem 32.	Start a database transaction, delete all employees from the 'Sales' department
--along with all dependent records from the pother tables. At the end rollback the transaction.

ALTER TABLE Employees
DROP CONSTRAINT FK_Employees_Departments

ALTER TABLE Departments
DROP CONSTRAINT FK_Departments_Employees

BEGIN TRAN
DELETE e
	FROM Employees e
	JOIN Departments d
		ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ROLLBACK TRAN

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Departments
	FOREIGN KEY(DepartmentID)
	REFERENCES Departments(DepartmentID)

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_Employees
	FOREIGN KEY(ManagerID)
	REFERENCES Employees(EmployeeID)

---------------------------------------------------------------------------------------------------
--Problem 33.	Start a database transaction and drop the table EmployeesProjects.

BEGIN TRAN
DROP TABLE EmployeesProjects
ROLLBACK TRAN

---------------------------------------------------------------------------------------------------
--Problem 34.	Find how to use temporary tables in SQL Server.
--Using temporary tables backup all records from EmployeesProjects
--and restore them back after dropping and re-creating the table.

CREATE TABLE #EmployeesProjectsTemporary (
	EmployeeID INT NOT NULL,
	ProjectID INT NOT NULL
)

INSERT INTO #EmployeesProjectsTemporary(EmployeeID, ProjectID)
SELECT EmployeeID, ProjectID
FROM EmployeesProjects

DROP TABLE EmployeesProjects

CREATE TABLE EmployeesProjects(
	EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID) NOT NULL,
	ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID) NOT NULL
)

INSERT INTO EmployeesProjects(EmployeeID, ProjectID)
SELECT EmployeeID, ProjectID
FROM #EmployeesProjectsTemporary

---------------------------------------------------------------------------------------------------