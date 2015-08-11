--Problem 1.	All Question Titles

select q.Title
from Questions q
order by q.Title


--Problem 2.	Answers in Date Range

select a.Content, a.CreatedOn
from Answers a
where a.CreatedOn between convert(date, '15-Jun-2012') and convert(date, '21-Mar-2013')
order by a.CreatedOn

--Problem 3.	Users with "1/0" Phones

select
	u.FirstName,
	u.LastName,
	(case
		when u.PhoneNumber is not null then 1
		else 0
	end)
from Users u
order by u.LastName, u.Id


--Problem 4.	Questions with their Author

select
	q.Title,
	u.Username
from Questions q
join Users u on q.UserId = u.Id
order by q.Title