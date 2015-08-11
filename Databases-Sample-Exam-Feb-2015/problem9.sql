select top 10
	a.Title,
	a.Date,
	s.Status
from Ads a
join AdStatuses s
	on a.StatusId = s.Id
order by a.Date desc