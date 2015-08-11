select
	a.Id,
	a.Title,
	a.Text,
	a.ImageDataURL,
	a.OwnerId,
	a.CategoryId,
	a.TownId,
	a.Date,
	a.StatusId
from Ads a
where a.TownId is null or a.CategoryId is null or a.ImageDataURL is null
order by a.Id