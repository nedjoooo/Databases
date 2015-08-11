SELECT d.DepartmentID as [Department Id], d.Name as [Department Name], e.FirstName + ' ' + e.LastName as [Manager Name]
FROM Departments d
JOIN Employees e
	ON d.ManagerID = e.EmployeeID