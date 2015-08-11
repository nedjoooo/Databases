SELECT e.FirstName + ' ' + e.LastName as [Employee Name], d.Name as [Department Name], e.HireDate as [Hire Date]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE (d.Name = 'Sales' OR d.Name = 'Finance')
		AND (e.HireDate BETWEEN '1995-1-1' AND '2005-12-31')