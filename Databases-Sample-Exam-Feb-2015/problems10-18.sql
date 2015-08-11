--Problem 10.	Not Published Ads from the First Month
--Find all not published ads, created in the same month and year like the earliest ad. 
--Display for each ad its id, title, date and status. Sort the results by Id. 
--Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.

select 
	a.Id,
	a.Title,
	a.Date,
	s.Status
from Ads a
join AdStatuses s
	on a.StatusId = s.Id
WHERE s.Status <> 'Published' and (CONVERT(nvarchar, MONTH(a.Date)) + '.' + CONVERT(NVARCHAR, YEAR(a.Date))) =
	(select CONVERT(nvarchar, MONTH(MIN(ad.Date))) + '.' + CONVERT(NVARCHAR, YEAR(MIN(ad.Date))) from Ads ad)
order by a.Id


--Problem 11.	Ads by Status
--Display the count of ads in each status. Sort the results by status. 
--Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.

select
	s.Status,
	count(a.Id) [Count]
from Ads a
join AdStatuses s
	on a.StatusId = s.Id
group by s.Status, s.Id
order by s.Status

--Problem 12.	Ads by Town and Status
--Display the count of ads for each town and each status. Sort the results by town, then by status. 
--Display only non-zero counts. Name the columns exactly like in the table below. 
--Submit for evaluation the result grid with headers.

select t.Name [Town Name], s.Status, count(*) [Count]
from Ads a
join Towns t
	on a.TownId = t.Id
join AdStatuses s
	on a.StatusId = s.Id
group by t.Name, t.Id, s.Status, s.Id
order by t.Name, s.Status

--Ads by Users
--Find the count of ads for each user. Display the username, ads count and "yes" or "no" depending 
--on whether the user belongs to the role "Administrator". Sort the results by username. 
--Display all users, including the users who have no ads. Name the columns exactly like in the table below. 
--Submit for evaluation the result grid with headers.

select 
	u.UserName,
	count(a.Id) [AdsCount],
	(case
		 when u.UserName in (select u.UserName
		from AspNetUsers u
		join AspNetUserRoles ur
			on u.Id = ur.UserId
		join AspNetRoles r
			on r.Id = ur.RoleId
		where r.Name = 'Administrator') then 'yes'
	else 'no'
	end) [IsAdministrator]
from AspNetUsers u
left join Ads a
	on u.Id = a.OwnerId
group by u.UserName, u.Id
order by u.UserName



--(Problem 14.	Ads by Town
--Find the count of ads for each town. Display the ads count and town name or "(no town)" for the ads without a town. 
--Display only the towns, which hold 2 or 3 ads. Sort the results by town name. 
--Name the columns exactly like in the table below. Submit for evaluation the result grid with headers

select COUNT(a.Id) [AdsCount], ISNULL(t.Name, '(no town)') [Town]
from Ads a
left outer join Towns t on a.TownId = t.Id
group by t.Name, t.Id
having COUNT(a.Id) between 2 and 3
order by t.Name


--Problem 15.	Pairs of Dates within 12 Hours
--Consider the dates of the ads. Find among them all pairs of different dates, 
--such that the second date is no later than 12 hours after the first date. 
--Sort the dates in increasing order by the first date, then by the second date. 
--Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.

select a.Date [FirstDate], b.Date [SecondDate]
from Ads a, Ads b
where b.Date <= (DATEADD(HOUR, 12, a.Date)) and a.Date <> b.Date and b.Date > a.Date
order by a.Date, b.Date


--Part II – Changes in the Database
--You are given a MS SQL Server database "Ads" holding advertisements, organized by categories and towns, 
--available as SQL script. Your task is to modify the database schema and data and write SQL queries 
--for displaying data from the database.

--Problem 16.	Ads by Country

--1.	Create a table Countries(Id, Name). Use auto-increment for the primary key. 
--Add a new column CountryId in the Towns table to link each town to some country (non-mandatory link). 
--Create a foreign key between the Countries and Towns tables.

create table Countries(
	Id int not null identity primary key,
	Name nvarchar(50)
)

alter table Towns add CountryId int

alter table Towns
add constraint FK_Towns_Countries
foreign key (CountryId) references Countries(Id)

--2.	Execute the following SQL script (it should pass without any errors):

INSERT INTO Countries(Name) VALUES ('Bulgaria'), ('Germany'), ('France')

UPDATE Towns SET CountryId = (SELECT Id FROM Countries WHERE Name='Bulgaria')

INSERT INTO Towns VALUES
('Munich', (SELECT Id FROM Countries WHERE Name='Germany')),
('Frankfurt', (SELECT Id FROM Countries WHERE Name='Germany')),
('Berlin', (SELECT Id FROM Countries WHERE Name='Germany')),
('Hamburg', (SELECT Id FROM Countries WHERE Name='Germany')),
('Paris', (SELECT Id FROM Countries WHERE Name='France')),
('Lyon', (SELECT Id FROM Countries WHERE Name='France')),
('Nantes', (SELECT Id FROM Countries WHERE Name='France'))

--3.	Write and execute a SQL command that changes the town to "Paris" for all ads created at Friday.

update Ads
	set TownId = 29
	where DATENAME(dw, Date) = 'Friday'

--4.	Write and execute a SQL command that changes the town to "Hamburg" for all ads created at Thursday.

select * from Ads
where DATENAME(dw, Date) = 'Thursday'

update Ads
	set TownId = (select Id from Towns where Name = 'Hamburg')
	where DATENAME(dw, Date) = 'Thursday'

--5.	Delete all ads created by user in role "Partner".

delete from Ads
where Id in (select a.Id from Ads a
				join AspNetUsers u on a.OwnerId = u.Id
				join AspNetUserRoles ur on ur.UserId = u.Id
				join AspNetRoles r on r.Id = ur.RoleId
				where r.Name = 'Partner')

--6.	Add a new add holding the following information: Title="Free Book", Text="Free C# Book", 
--Date={current date and time}, Owner="nakov", Status="Waiting Approval".

insert into Ads(Title, Text, Date, OwnerId, StatusId)
values('Free Book',
		 'Free C# Book', 
		 GETDATE(), 
		 (select u.Id from AspNetUsers u where u.Name = 'nakov'),
		 (select s.Id from AdStatuses s where s.Status = 'Waiting Approval')
	)

--7.	Find the count of ads for each town. Display the ads count, the town name and the country name. 
--Include also the ads without a town and country. Sort the results by town, then by country. 
--Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.

select t.Name [Town], c.Name [Country], COUNT(a.Id) [AdsCount]
from Towns t
full join Countries c on t.CountryId = c.Id
full join Ads a on a.TownId = t.Id
group by t.Name, t.Id, c.Name, c.Id
order by t.Name, c.Name


--Part III – Stored Procedures
--Problem 17.	Create a View and a Stored Function

create view AllAds
as
select 
	a.Id,
	a.Title,
	u.UserName [Author],
	a.Date,
	t.Name [Town],
	c.Name [Category],
	s.Status
	 from Ads a
left join AspNetUsers u on a.OwnerId = u.Id
left join Towns t on a.TownId = t.Id
left join Categories c on a.CategoryId = c.Id
left join AdStatuses s on a.StatusId = s.Id

create function fn_ListUsersAds()
returns @ads table(UserName nvarchar(max), AdDates nvarchar(max))
begin
	declare cursor_users cursor read_only fast_forward for
		select UserName from AspNetUsers
	declare @username nvarchar(max)
	open cursor_users
	fetch next from cursor_users into @username
	while(@@FETCH_STATUS = 0)
	begin
		declare @dates nvarchar(max) = null
		--------------------------------------
		declare 
			cursor_dates cursor read_only fast_forward for
			select Date from AllAds a
				where a.Author = @username order by Date
		declare @date DATE  = null
		open cursor_dates
		fetch next from cursor_dates into @date
		while(@@FETCH_STATUS = 0)
		begin
			if @dates is null
				set @dates = CONVERT(NVARCHAR(8), @date, 112)
			else
				set @dates = @dates + '; ' + CONVERT(NVARCHAR(8), @date, 112)
			fetch next from cursor_dates into @date
		end	
		close cursor_dates
		deallocate cursor_dates
		--------------------------------------
		insert into @ads values(@username, @dates)
		fetch next from cursor_users into @username
	end	
	close cursor_users
	deallocate cursor_users
  return
end

go

select * from fn_ListUsersAds() a
order by a.UserName desc

if(OBJECT_ID('fn_ListUsersAds') is not null)
drop function fn_ListUsersAds