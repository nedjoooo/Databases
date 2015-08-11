--Problem 1.	Create a database with two tables
--Persons (id (PK), first name, last name, SSN) and Accounts (id (PK), person id (FK), balance).
--Insert few records for testing. 

CREATE DATABASE BankDB
GO

USE BankDB
CREATE TABLE Persons(
	PersonID INT NOT NULL IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	SSN VARCHAR(10) NOT NULL
)

GO

USE BankDB
CREATE TABLE Accounts(
	AccountID INT NOT NULL IDENTITY PRIMARY KEY,
	PersonID INT NOT NULL,
	Balance MONEY DEFAULT 0,
	CONSTRAINT FK_Accounts_Persons FOREIGN KEY(PersonID) REFERENCES Persons(PersonID)
)

USE BankDB
INSERT INTO Persons(FirstName, LastName, SSN)
VALUES 
	('Gosho', 'Goshev', '8012035544'),
	('Pesho', 'Peshev', '8211045224'),
	('Bai', 'Ivan', '4407079982')

GO

USE BankDB
INSERT INTO Accounts(PersonID, Balance)
VALUES 
	(1, 20000),
	(2, 200),
	(3, 8500)

--Write a stored procedure that selects the full names of all persons.

USE BankDB
GO

CREATE PROC dbo.usp_SelectNameOfPersons
AS
	SELECT p.FirstName + ' ' + p.LastName [Person Name], a.Balance [Balance]
	FROM Persons p
	JOIN Accounts a
		ON a.PersonID = p.PersonID
GO

EXEC usp_SelectNameOfPersons

--Problem 2.	Create a stored procedure
--Your task is to create a stored procedure that accepts a number as a parameter and returns all persons 
--who have more money in their accounts than the supplied number.

USE BankDB
CREATE PROC dbo.usp_PersonsWithMoneyAboveSpecified(@balance MONEY = 0)
AS
	SELECT 
		p.FirstName [First Name],
		p.LastName [Last Name],
		p.SSN [SSN],
		a.Balance [Balance]
	FROM Persons p
	JOIN Accounts a
		ON a.PersonID = p.PersonID
	WHERE a.Balance >= @balance

GO

EXEC usp_PersonsWithMoneyAboveSpecified 5000

--Problem 3.	Create a function with parameters
--Your task is to create a function that accepts as parameters – sum, yearly interest rate and number of months.
--It should calculate and return the new sum. Write a SELECT to test whether the function works as expected.

USE BankDB
CREATE FUNCTION ufn_CalculateInterest(@sum MONEY, @interest MONEY, @months INT)
RETURNS MONEY
AS
BEGIN
	RETURN @sum * (1 + ((@interest/100.00)*(@months/12.00)))
END
GO

DECLARE @outputBalance MONEY
SELECT
	@outputBalance = dbo.ufn_CalculateInterest(20000, 6.8, 2)
PRINT @outputBalance

--Problem 4.	Create a stored procedure that uses the function from the previous example.
--Your task is to create a stored procedure that uses the function from the previous example to give an interest 
--to a person's account for one month. It should take the AccountId and the interest rate as parameters.

USE BankDB
CREATE PROC dbo.usp_CalculatePersonInterest(@accountId int, @interest money)
AS
SELECT
	p.FirstName + ' ' + p.LastName [Person Name],
	a.Balance [Balance],
	dbo.ufn_CalculateInterest(a.Balance, @interest, 1) - a.Balance [Monthly interest]
FROM Persons p
JOIN Accounts a
	ON a.PersonID = p.PersonID
WHERE p.PersonID = @accountId
GO

EXEC usp_CalculatePersonInterest 1, 6.8

--Problem 5.	Add two more stored procedures WithdrawMoney and DepositMoney.
--Add two more stored procedures WithdrawMoney (AccountId, money) and DepositMoney (AccountId, money) 
--that operate in transactions.

USE BankDB
CREATE PROC usp_WithdrawMoney(@accountId int, @withdrawalMoney money)
AS
UPDATE Accounts
	SET Balance = Balance - @withdrawalMoney
WHERE AccountID = @accountId
GO

CREATE PROC usp_DepositMoney(@accountId int, @depositMoney money)
AS
UPDATE Accounts
	SET Balance = Balance + @depositMoney
WHERE AccountID = @accountId
GO

CREATE PROC usp_SelectAllPersonsWithTheirBalances
AS
	SELECT
		p.FirstName + ' ' + p.LastName [Person Name], a.Balance [Balance]
	FROM Persons p
	JOIN Accounts a
		ON a.PersonID = p.PersonID
GO

EXEC usp_SelectAllPersonsWithTheirBalances
GO

EXEC usp_WithdrawMoney 1, 2000.00
GO

EXEC usp_SelectAllPersonsWithTheirBalances
GO

EXEC usp_DepositMoney 1, 5000.00
GO

EXEC usp_SelectAllPersonsWithTheirBalances
GO

--Problem 6.	Create table Logs.
--Create another table – Logs (LogID, AccountID, OldSum, NewSum). Add a trigger to the Accounts table 
--that enters a new entry into the Logs table every time the sum on an account changes.

USE BankDB
CREATE TABLE Logs(
	LogID INT NOT NULL IDENTITY PRIMARY KEY,
	AccountID INT NOT NULL,
	OldSum MONEY NOT NULL,
	NewSum MONEY NOT NULL
	CONSTRAINT FK_Logs_Accounts FOREIGN KEY(AccountID) REFERENCES Accounts(AccountID)
)

GO

CREATE TRIGGER tr_AccountsBalanceChanged ON Accounts FOR UPDATE
AS
BEGIN
	INSERT INTO Logs(AccountID, OldSum, NewSum)
	SELECT
		d.AccountID,
		d.Balance,
		i.Balance
	FROM
		DELETED d,
		INSERTED i
END

GO

EXEC usp_SelectAllPersonsWithTheirBalances
GO

EXEC usp_WithdrawMoney 1, 2000.00
GO

SELECT * FROM Logs

EXEC usp_DepositMoney 1, 5000.00
GO

EXEC usp_SelectAllPersonsWithTheirBalances
GO

SELECT * FROM Logs

GO

CREATE TRIGGER tr_AccountsBalanceInserted ON Accounts FOR INSERT
AS
BEGIN
	INSERT INTO Logs(AccountID, OldSum, NewSum)
	SELECT
		i.AccountID,
		0,
		i.Balance
	FROM
		INSERTED i
END

GO

USE BankDB
INSERT INTO Persons(FirstName, LastName, SSN)
VALUES 
	('Misho', 'Mishev', '7601018822')

GO

INSERT INTO Accounts(PersonID, Balance)
VALUES 
	(4, 40000)

GO

SELECT * FROM Logs

--Problem 7.	Define function in the SoftUni database.
--Define a function in the database SoftUni that returns all Employee's names (first or middle or last name) 
--and all town's names that are comprised of given set of letters. 

--Example: 'oistmiahf' will return 'Sofia', 'Smith', but not 'Rob' and 'Guy'.

USE SoftUni
GO

CREATE FUNCTION ufn_CheckIfLettersWordsInExistingString(@word NVARCHAR(MAX), @searchingString NVARCHAR(MAX))
RETURNS INT
AS
BEGIN
	DECLARE @char NVARCHAR(1)
	DECLARE @index INT = 1
	DECLARE @indexPosition INT = 1
	DECLARE @wordLength INT = LEN(@word)
	WHILE(@indexPosition <= @wordLength)
		BEGIN
			SET @char = SUBSTRING(@word, @indexPosition, @index)
			IF(CHARINDEX(@char, @searchingString) > 0)
				BEGIN
					SET @indexPosition = @indexPosition + 1
				END
			ELSE
				BEGIN
					RETURN 0
				BREAK
		END
	END
	RETURN 1
END

GO

CREATE FUNCTION ufn_EmployeesAndTownsMatchgGivenSetOfLetters(@givenString NVARCHAR(MAX))
RETURNS @tbl_MatchingFieldsWords TABLE(Match NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO @tbl_MatchingFieldsWords
		SELECT FirstName
		FROM Employees
		WHERE dbo.ufn_CheckIfLettersWordsInExistingString(FirstName, @givenString) = 1
	INSERT INTO @tbl_MatchingFieldsWords
		SELECT MiddleName
		FROM Employees
		WHERE dbo.ufn_CheckIfLettersWordsInExistingString(MiddleName, @givenString) = 1
	INSERT INTO @tbl_MatchingFieldsWords
		SELECT LastName
		FROM Employees
		WHERE dbo.ufn_CheckIfLettersWordsInExistingString(LastName, @givenString) = 1
	INSERT INTO @tbl_MatchingFieldsWords
		SELECT Name
		FROM Towns
		WHERE dbo.ufn_CheckIfLettersWordsInExistingString(Name, @givenString) = 1
	RETURN
END
GO

SELECT * FROM ufn_EmployeesAndTownsMatchgGivenSetOfLetters('oistmiahf')

--Problem 8.	Using database cursor write a T-SQL

--Using database cursor write a T-SQL script that scans all employees and their addresses and prints 
--all pairs of employees that live in the same town.

USE SoftUni
GO
DECLARE empCursor CURSOR READ_ONLY FOR
	SELECT 
		e.FirstName [First Name],
		e.LastName [Last Name],
		T.Name [Town]
	FROM Employees e
	JOIN Addresses a
		ON e.AddressID = a.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID

GO

OPEN empCursor
DECLARE 
	@firstName NVARCHAR(50),
	@lastName NVARCHAR(50),
	@townName NVARCHAR(50),
	@currentFirstName NVARCHAR(50),
	@currentLastName NVARCHAR(50),
	@currentTownName NVARCHAR(50)
FETCH NEXT FROM empCursor INTO @firstName, @lastName, @townName
WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @currentFirstName = @firstName
		SET @currentLastName = @lastName
		SET @currentTownName = @townName
		FETCH NEXT FROM empCursor INTO @firstName, @lastName, @townName
		IF(@currentTownName = @townName)
			PRINT @townName + ': ' + 
					@currentFirstName + ' ' + @currentLastName + ', ' + 
					@firstName + ' ' + @lastName
	END

GO

CLOSE empCursor
DEALLOCATE empCursor

--Problem 9.	Define a .NET aggregate function
--Define a .NET aggregate function StrConcat that takes as input a sequence of strings 
--and return a single string that consists of the input strings separated by ','.

USE SoftUni
GO

CREATE FUNCTION ufn_StrConcat(@input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @char NVARCHAR(1)
	DECLARE @output NVARCHAR(MAX)
	DECLARE @inputLength INT = LEN(@input)
	DECLARE @index INT = 1
	DECLARE @indexPosition INT = 1
	WHILE(@indexPosition <= @inputLength)
		BEGIN
			SET @char = SUBSTRING(@input, @indexPosition, @index)
			IF @indexPosition = 1
				SET @output = @char
			ELSE IF @char <> ' '
				SET @output = @output + @char
			ELSE
				SET @output = @output + ', '
			SET @indexPosition = @indexPosition + 1
		END
	RETURN @output
END

GO

SELECT dbo.ufn_StrConcat(FirstName + ' ' + LastName) [Employee Name]
FROM Employees
