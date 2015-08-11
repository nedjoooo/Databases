SELECT e.FirstName + ' ' + e.LastName as [Employee Name], a.AddressText as Address, t.Name as Town
FROM Employees e, Addresses a, Towns t
WHERE e.AddressID = a.AddressID AND a.TownID = t.TownID