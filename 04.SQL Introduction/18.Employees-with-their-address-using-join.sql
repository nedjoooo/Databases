SELECT e.FirstName + ' ' + e.LastName as [Employee Name], a.AddressText as Address, t.Name as Town
FROM Employees e
JOIN Addresses a
	ON e.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID