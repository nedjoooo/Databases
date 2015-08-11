SELECT e.FirstName + ' ' + e.MiddleName + ' ' + e.LastName as [Employee Name], e.Salary as Salary
FROM Employees e
WHERE e.Salary BETWEEN 20000 AND 30000