SELECT e.FirstName + ' ' + e.LastName as [Employee Name], m.FirstName + ' ' + m.LastName
FROM Employees e
LEFT OUTER JOIN Employees m
	ON e.ManagerID = m.EmployeeID