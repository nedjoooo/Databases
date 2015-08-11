SELECT e.FirstName + ' ' + e.MiddleName + ' ' + e.LastName as [Employee Name], e.Salary as Salary
FROM Employees e
WHERE e.Salary IN (25000,14000,12500,23600)