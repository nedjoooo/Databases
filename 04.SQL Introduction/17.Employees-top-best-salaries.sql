SELECT TOP 5 e.FirstName + ' ' + e.LastName as [Employee Name], e.Salary
FROM Employees e
ORDER BY e.Salary DESC