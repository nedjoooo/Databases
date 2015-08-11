select
	a.Title, c.Name [CategoryName], t.Name [TownName], s.Status [Status]
from Ads a
left join Categories c
	on a.CategoryId = c.Id
left join Towns t
	on a.TownId = t.Id
left join AdStatuses s
	on a.StatusId = s.Id
order by a.Id