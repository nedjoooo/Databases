--Problem 1.	Create a table in SQL Server
--Your task is to create a table in SQL Server with 10 000 000 entries (date + text).
-- Search in the table by date range. Check the speed (without caching).

USE master
GO

CREATE DATABASE PerformanceDB
GO

USE PerformanceDB
GO

--Create table
CREATE TABLE TestTable(
	RecordID INT NOT NULL PRIMARY KEY IDENTITY,
	RecordDate DATETIME NOT NULL,
	RecordText NVARCHAR(8) NOT NULL
)

GO

--Fill table with 10 000 000 rows
DECLARE @Counter int = 0
WHILE (@Counter < 10000000)
BEGIN
  INSERT INTO TestTable(RecordDate, RecordText)
  VALUES(GETDATE(), CONVERT(NVARCHAR, @Counter))
  SET @Counter = @Counter + 1
END

USE PerformanceDB
GO

-- Empty the SQL Server cache
CHECKPOINT; DBCC DROPCLEANBUFFERS;
GO

-- Search in the table by date range.
SELECT t.RecordDate, t.RecordText
FROM TestTable t
WHERE t.RecordDate >= CONVERT(DATETIME, '2015-07-05 18:14:45.647')
AND t.RecordDate <= CONVERT(DATETIME, '2015-07-05 18:40:33.593')


--Problem 2.	Add an index to speed-up the search by date
--Your task is to add an index to speed-up the search by date. Test the search speed 
--(after cleaning the cache).

USE PerformanceDB
GO

--Create index
CREATE INDEX IX_TestTable_Date
    ON TestTable(RecordDate); 
GO

-- Empty the SQL Server cache
CHECKPOINT; DBCC DROPCLEANBUFFERS;
GO

-- Search in the table by date range.
SELECT t.RecordDate, t.RecordText
FROM TestTable t
WHERE t.RecordDate >= CONVERT(DATETIME, '2015-07-05 18:14:45.647')
AND t.RecordDate <= CONVERT(DATETIME, '2015-07-05 18:40:33.593')