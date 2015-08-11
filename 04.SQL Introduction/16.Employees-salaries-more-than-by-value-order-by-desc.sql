SELECT e.FirstName + ' '  + e.LastName as [Employee Name], e.Salary as Salary
FROM Employees e
WHERE e.Salary > 50000
ORDER BY e.Salary DESC