select
	a.Title, c.Name [CategoryName], t.Name [TownName], s.Status [Status]
from Ads a
join Categories c
	on a.CategoryId = c.Id
join Towns t
	on a.TownId = t.Id
join AdStatuses s
	on a.StatusId = s.Id
where (t.Name = 'Sofia' or t.Name = 'Blagoevgrad' or t.Name = 'Stara Zagora')
	and s.Status = 'Published'
order by a.Title


select
	a.Title, c.Name [CategoryName], t.Name [TownName], s.Status [Status]
from Ads a
join Categories c
	on a.CategoryId = c.Id
join Towns t
	on a.TownId = t.Id
join AdStatuses s
	on a.StatusId = s.Id
where t.Name in ('Sofia', 'Blagoevgrad', 'Stara Zagora')
	and s.Status = 'Published'
order by a.Title