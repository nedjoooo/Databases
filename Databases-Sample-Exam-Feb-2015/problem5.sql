select
	a.Title, t.Name [Town]
from Ads a
left join Towns t
	on a.TownId = t.Id
order by a.Id