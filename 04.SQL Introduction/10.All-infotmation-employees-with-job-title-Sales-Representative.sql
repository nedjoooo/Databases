SELECT e.EmployeeID AS [Employee ID],
		e.FirstName + ' ' + e.MiddleName + ' ' + e.LastName AS [Employee Name],
		e.JobTitle AS [Job Title],
		d.Name AS [Department Name],
		m.FirstName + ' ' + m.LastName as [Manager Name],
		e.HireDate as [Hire Date],
		e.Salary as Salary,
		a.AddressText as Adrress,
		t.Name as Town
FROM Employees e
	JOIN Departments d
		ON d.DepartmentID = e.DepartmentID
	JOIN Employees m
		ON e.ManagerID = m.EmployeeID
	JOIN Addresses a
		ON a.AddressID = e.AddressID
	JOIN Towns t
		ON a.TownID = t.TownID
WHERE e.JobTitle = 'Sales Representative'