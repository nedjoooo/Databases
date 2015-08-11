SELECT e.FirstName + ' '  + e.LastName as [Employee Name], e.ManagerID as Manager
FROM Employees e
WHERE e.ManagerID IS NULL