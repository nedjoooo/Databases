select 
	a.Title [Title],
	a.Date [Date], 
	(case
		when a.ImageDataURL IS NULL then 'no'
		else 'yes'
	end) [Has Image]
from Ads a
order by a.Id