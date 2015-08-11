--Problem 1.	All Diablo Characters

select c.Name
from Characters c
order by c.Name


--Problem 2.	Games from 2011 and 2012 year

select top 50
	g.Name [Game],
	CONVERT(VARCHAR(10), g.Start, 21) [Start]
from Games g
where g.Start between CONVERT(DATE, '01-Jan-2011') and CONVERT(DATE, '31-Dec-2012')
order by [Start], g.Name


--Problem 3.	User Email Providers

SELECT
	u.Username [Username],
	RIGHT(u.Email, LEN(u.Email) - CHARINDEX('@', u.Email)) [Email Provider]
from Users u
order by [Email Provider], u.Username


--Problem 4.	Get users with IPAddress like pattern

select
	u.Username [Username],
	u.IpAddress [IP Address]
from Users u
where u.IpAddress like '___.1[0-9]%.[0-9]%.___'
order by u.Username


--Problem 5.	Show All Games with Duration and Part of the Day

select
	g.Name [Game],
	(case
		when CONVERT(TIME, g.Start) between CONVERT(VARCHAR(24), '00:00:00', 114) and CONVERT(VARCHAR(24), '11:59:59:999', 114) then 'Morning'
		when CONVERT(TIME, g.Start) between CONVERT(VARCHAR(24), '12:00:00', 114) and CONVERT(VARCHAR(24), '17:59:59:999', 114) then 'Afternoon'
		else 'Evening'
	end) [Part of the Day],
	(case
		when g.Duration <= 3 then 'Extra Short'
		when g.Duration between 4 and 6 then 'Short'
		when g.Duration > 6 then 'Long'
		else 'Extra Long'
	end) [Duration]
from Games g
order by g.Name, [Duration]


--Problem 6.	Number of Users for Email Provider

select
	RIGHT(u.Email, LEN(u.Email) - CHARINDEX('@', u.Email)) [Email Provider],
	COUNT(RIGHT(u.Email, LEN(u.Email) - CHARINDEX('@', u.Email))) [Number Of Users]
from Users u
group by RIGHT(u.Email, LEN(u.Email) - CHARINDEX('@', u.Email))
order by [Number Of Users] desc, RIGHT(u.Email, LEN(u.Email) - CHARINDEX('@', u.Email))


--Problem 7.	All User in Games

select
	g.Name [Game],
	gt.Name [Game Type],
	u.Username [Username],
	ug.Level [Level],
	ug.Cash [Cash],
	c.Name [Character]
from Games g
join GameTypes gt on gt.Id = g.GameTypeId
join UsersGames ug on ug.GameId = g.Id
join Users u on ug.UserId = u.Id
join Characters c on ug.CharacterId = c.Id
order by ug.Level desc, u.Username, g.Name


--Problem 8.	Users in Games with Their Items

select
	u.Username [Username],
	g.Name [Game],
	count(i.Id) [Items Count],
	sum(i.Price) [Items Price]
from Users u
join UsersGames ug on ug.UserId = u.Id
join Games g on ug.GameId = g.Id
join UserGameItems ugt on ugt.UserGameId = ug.Id
join Items i on ugt.ItemId = i.Id
group by u.Username, u.Id, g.Name, g.Id
having count(i.Id) >= 10
order by [Items Count] desc, [Items Price] desc


--Problem 9.	User in Games with Their Statistics

select
	u.Username [Username],
	g.Name,
	ch.Name,
	s.Strength,
	s2.Strength,
	s3.Strength
from Users u
join UsersGames ug on ug.UserId = u.Id
join Games g on g.Id = ug.GameId
join Characters ch on ch.Id = ug.CharacterId
join [dbo].[Statistics] s on s.Id = ch.Id
join GameTypes gt on g.GameTypeId = gt.Id
join [dbo].[Statistics] s2 on gt.BonusStatsId = s2.Id
join UserGameItems ugt on ug.Id = ugt.UserGameId
join Items i on ugt.ItemId = i.Id
join [dbo].[Statistics] s3 on i.StatisticId = s3.Id
where u.Username = 'skippingside'


--Problem 10.	All Items with Greater than Average Statistics

select
	i.Name [Name],
	i.Price [Price],
	i.MinLevel [MinLevel],
	s.Strength [Strength],
	s.Defence [Defence],
	s.Speed,
	s.Luck,
	s.Mind
from Items i
join [dbo].[Statistics] s on i.StatisticId = s.Id
where s.Mind > (select AVG(s2.Mind) from [dbo].[Statistics] s2)
	and s.Luck > (select AVG(s2.Luck) from [dbo].[Statistics] s2)
	and s.Speed > (select AVG(s2.Speed) from [dbo].[Statistics] s2)
order by i.Name


--Problem 11.	Display All Items with Information about Forbidden Game Type

select
	i.Name [Item],
	i.Price,
	i.MinLevel,
	gt.Name [Forbidden Game Type]
from Items i
left join GameTypeForbiddenItems gtfi on gtfi.ItemId = i.Id
left join GameTypes gt on gtfi.GameTypeId = gt.Id
order by gt.Name desc, i.Name


--Changes in the Database

--Problem 12.	Buy items for user in game


insert into UserGameItems(ItemId, UserGameId)
values((select i.Id from Items i where i.Name = 'Blackguard'),
		(SELECT Id
			FROM UsersGames
			where GameId = 221 and UserId = 5))

insert into UserGameItems(ItemId, UserGameId)
values((select i.Id from Items i where i.Name = 'Bottomless Potion of Amplification'),
		(SELECT Id
			FROM UsersGames
			where GameId = 221 and UserId = 5))

insert into UserGameItems(ItemId, UserGameId)
values((select i.Id from Items i where i.Name = 'Eye of Etlich (Diablo III)'),
		(SELECT Id
			FROM UsersGames
			where GameId = 221 and UserId = 5))

insert into UserGameItems(ItemId, UserGameId)
values((select i.Id from Items i where i.Name = 'Gem of Efficacious Toxin'),
		(SELECT Id
			FROM UsersGames
			where GameId = 221 and UserId = 5))

insert into UserGameItems(ItemId, UserGameId)
values((select i.Id from Items i where i.Name = 'Golden Gorget of Leoric'),
		(SELECT Id
			FROM UsersGames
			where GameId = 221 and UserId = 5))

insert into UserGameItems(ItemId, UserGameId)
values((select i.Id from Items i where i.Name = 'Hellfire Amulet'),
		(SELECT Id
			FROM UsersGames
			where GameId = 221 and UserId = 5))

update UsersGames
set Cash = Cash - (select sum(i.Price)
					from Items i
					where i.Name in ('Blackguard',
									'Bottomless Potion of Amplification',
									'Eye of Etlich (Diablo III)',
									'Gem of Efficacious Toxin',
									'Golden Gorget of Leoric',
									'Hellfire Amulet'))
where Id = (SELECT Id
  FROM UsersGames
  where GameId = 221 and UserId = 5)


select Cash
from UsersGames
where Id = 235

select 
	u.Username, g.Name, ug.Cash, i.Name [Item Name]
from Users u
join UsersGames ug on ug.UserId = u.Id
join Games g on ug.GameId = g.Id
join UserGameItems ugi on ug.Id = ugi.UserGameId
join Items i on i.Id = ugi.ItemId
where g.Id = (select Id from Games where Name = 'Edinburgh')
order by i.Name


--Problem 13.	Massive shopping

--Problem 14.	Scalar Function: Cash in User Games Odd Rows

use Diablo
go

alter function fn_CashInUsersGames(@game nvarchar(max))
returns decimal(10,2)
begin
	declare @sumCash decimal(10, 2) = 0
	declare cursor_cashes cursor for
		select ug.Cash from UsersGames ug
		join Games g on ug.GameId = g.Id
		where g.Name = @game
		order by ug.Cash desc
	declare @isOdd int = 1
	declare @cash decimal(10, 2) = 0
	open cursor_cashes
	fetch next from cursor_cashes into @cash
	while(@@FETCH_STATUS = 0)
	begin
		if((@isOdd % 2) <> 0)
			set @sumCash = @sumCash + @cash
		set @isOdd = @isOdd + 1
		fetch next from cursor_cashes into @cash
	end
	return @sumCash
end


go

select dbo.fn_CashInUsersGames('Bali') [SumCash]
union
select dbo.fn_CashInUsersGames('Lily Stargazer') [SumCash]
union
select dbo.fn_CashInUsersGames('Love in a mist') [SumCash]
union
select dbo.fn_CashInUsersGames('Mimosa') [SumCash]
union
select dbo.fn_CashInUsersGames('Ming fern') [SumCash]
order by [SumCash]
