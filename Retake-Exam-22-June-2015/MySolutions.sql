--Databases Exam (March 2015) – Football

--Problem 1.	All Teams

select t.TeamName
from Teams t
order by t.TeamName


--Problem 2.	Biggest Countries by Population

select top 50 c.CountryName, c.Population
from Countries c
order by c.Population desc, c.CountryName


--Problem 3.	Countries and Currency (Eurzone)

select
	c.CountryName,
	c.CountryCode,
	(case 
		when c.CurrencyCode = 'EUR' then 'Inside'
		else 'Outside'
	end) [Eurozone]
from Countries c
order by c.CountryName


--Problem 4.	Teams Holding Numbers

select
	t.TeamName [Team Name],
	t.CountryCode [Country Code]
from Teams t
where t.TeamName like '%[0-9]%'
order by t.CountryCode


--Problem 5.	International Matches

select 
	ch.CountryName [Home Team],
	ca.CountryName [Away Team],
	im.MatchDate [Match Date]
from InternationalMatches im
join Countries ch on im.HomeCountryCode = ch.CountryCode
join Countries ca on im.AwayCountryCode = ca.CountryCode
order by im.MatchDate desc


--Problem 6.	Teams with their League and League Country

select 
	t.TeamName [Team Name],
	l.LeagueName [League],
	isnull(c.CountryName, 'International') [League Country]
from Teams t
join Leagues_Teams lt on lt.TeamId = t.Id
join Leagues l on lt.LeagueId = l.Id
left join Countries c on l.CountryCode = c.CountryCode
order by t.TeamName, l.LeagueName


--Teams with more than One Match

select
	t.TeamName [Team],
		((select count(tm1.Id)
			from Teams t1
			join TeamMatches tm1 on tm1.HomeTeamId = t1.Id
			where tm1.HomeTeamId = t.Id) + 
		(select count(tm2.Id)
			from Teams t2
			join TeamMatches tm2 on tm2.AwayTeamId = t2.Id
			where tm2.AwayTeamId = t.Id)
		) [Matches Count]
from Teams t
where ((select count(tm1.Id)
			from Teams t1
			join TeamMatches tm1 on tm1.HomeTeamId = t1.Id
			where tm1.HomeTeamId = t.Id) + 
		(select count(tm2.Id)
			from Teams t2
			join TeamMatches tm2 on tm2.AwayTeamId = t2.Id
			where tm2.AwayTeamId = t.Id)
		) > 1
order by t.TeamName


--Problem 8.	Number of Teams and Matches in Leagues

select 
	l.LeagueName [League Name],
	count(t.Id) [Teams],
	(select count(LeagueId)
		from TeamMatches
		where LeagueId = l.Id) [Matches],
	isnull(((select sum(HomeGoals) from TeamMatches where LeagueId = l.Id) +
		(select sum(AwayGoals) from TeamMatches where LeagueId = l.Id)) / (select count(LeagueId)
		from TeamMatches
		where LeagueId = l.Id), 0) [Average Goals]
from Leagues l
left join Leagues_Teams lt on lt.LeagueId = l.Id
left join Teams t on lt.TeamId = t.Id
group by l.LeagueName, l.Id
order by count(t.Id) desc, (select count(LeagueId)
		from TeamMatches
		where LeagueId = l.Id) desc

--Problem 9.	Total Goals per Team in all Matches

select 
	t.TeamName,
	(isnull((select sum(tema.HomeGoals)
		from TeamMatches tema
		where tema.HomeTeamId = t.Id), 0) + isnull((select sum(tema.AwayGoals)
		from TeamMatches tema
		where tema.AwayTeamId = t.Id), 0)
	) [Total Goals]
from Teams t
left join TeamMatches tm on tm.HomeTeamId = t.Id
left join TeamMatches tm2 on tm2.AwayTeamId = t.Id
group by t.TeamName, t.Id
order by [Total Goals] desc, t.TeamName


--Problem 10.	Pairs of Matches on the Same Day

select
	tm1.MatchDate [First Date],
	tm2.MatchDate [Second Date]
from TeamMatches tm1, TeamMatches tm2
where CONVERT(nvarchar(10), tm1.MatchDate ,21) = CONVERT(nvarchar(10), tm2.MatchDate ,21)
	AND tm1.MatchDate < tm2.MatchDate
order by tm1.MatchDate desc, tm2.MatchDate desc


--Problem 11.	Mix of Team Names

select
	LOWER(LEFT(t1.TeamName, LEN(t1.TeamName) - 1) + REVERSE(t2.TeamName)) [Mix]
from Teams t1, Teams t2
where RIGHT(t1.TeamName, 1) = RIGHT(t2.TeamName, 1)
order by [Mix]


--Problem 12.	Countries with International and Team Matches

select
	c.CountryName [Country Name],
	(COUNT(distinct im.Id) + COUNT(distinct i.Id)) [International Matches],
	(COUNT(distinct tm.Id)) [Team Matches]
from Countries c
left join InternationalMatches im on im.HomeCountryCode = c.CountryCode
left join InternationalMatches i on i.AwayCountryCode = c.CountryCode
left join Leagues l on l.CountryCode = c.CountryCode
left join TeamMatches tm on tm.LeagueId = l.Id
group by c.CountryName, c.CountryCode
having (COUNT(distinct im.Id) + COUNT(distinct i.Id)) > 0
	or (COUNT(distinct tm.Id)) > 0
order by [International Matches] desc, [Team Matches] desc, c.CountryName


--Part II – Changes in the Database

--Problem 13.	Non-international Matches

use Football
go

create table FriendlyMatches(
	Id int not null identity primary key,
	HomeTeamID int not null,
	AwayTeamId int not null,
	MatchDate datetime
)

alter table FriendlyMatches
add constraint FK_FriendlyMatches_Teams_HomeTeam
foreign key (HomeTeamID) references Teams(Id)

alter table FriendlyMatches
add constraint FK_FriendlyMatches_Teams_AwayTeam
foreign key (AwayTeamId) references Teams(Id)

INSERT INTO Teams(TeamName) VALUES
 ('US All Stars'),
 ('Formula 1 Drivers'),
 ('Actors'),
 ('FIFA Legends'),
 ('UEFA Legends'),
 ('Svetlio & The Legends')
GO

INSERT INTO FriendlyMatches(
  HomeTeamId, AwayTeamId, MatchDate) VALUES
  
((SELECT Id FROM Teams WHERE TeamName='US All Stars'), 
 (SELECT Id FROM Teams WHERE TeamName='Liverpool'),
 '30-Jun-2015 17:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Formula 1 Drivers'), 
 (SELECT Id FROM Teams WHERE TeamName='Porto'),
 '12-May-2015 10:00'),
 
((SELECT Id FROM Teams WHERE TeamName='Actors'), 
 (SELECT Id FROM Teams WHERE TeamName='Manchester United'),
 '30-Jan-2015 17:00'),

((SELECT Id FROM Teams WHERE TeamName='FIFA Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='UEFA Legends'),
 '23-Dec-2015 18:00'),

((SELECT Id FROM Teams WHERE TeamName='Svetlio & The Legends'), 
 (SELECT Id FROM Teams WHERE TeamName='Ludogorets'),
 '22-Jun-2015 21:00')

GO


select
	t1.TeamName [Home Team],
	t2.TeamName [Away Team],
	fm.MatchDate [Match Date]
from FriendlyMatches fm
join Teams t1 on fm.HomeTeamID = t1.Id
join Teams t2 on fm.AwayTeamId = t2.Id
union
select
	t1.TeamName [Home Team],
	t2.TeamName [Away Team],
	tm.MatchDate [Match Date]
from TeamMatches tm
join Teams t1 on tm.HomeTeamId = t1.Id
join Teams t2 on tm.AwayTeamId = t2.Id
order by fm.MatchDate desc


--Problem 14.	Seasonal Matches

use Football
go

ALTER TABLE Leagues  
ADD IsSeasonal BIT NOT NULL DEFAULT 0

insert into TeamMatches(HomeTeamId, AwayTeamId, HomeGoals, AwayGoals, MatchDate, LeagueId)
values(
		(select t.Id from Teams t where t.TeamName = 'Empoli'),
		(select t.Id from Teams t where t.TeamName = 'Parma'),
		2,
		2,
		'19-Apr-2015 16:00',
		(select l.Id from Leagues l where l.LeagueName = 'Italian Serie A'))

insert into TeamMatches(HomeTeamId, AwayTeamId, HomeGoals, AwayGoals, MatchDate, LeagueId)
values(
		(select t.Id from Teams t where t.TeamName = 'Internazionale'),
		(select t.Id from Teams t where t.TeamName = 'AC Milan'),
		0,
		0,
		'19-Apr-2015 21:45',
		(select l.Id from Leagues l where l.LeagueName = 'Italian Serie A'))

update Leagues
	set IsSeasonal = 1
where Id in (select l.Id 
				from Leagues l
				join TeamMatches tm on tm.LeagueId = l.Id
				group by l.Id
				having COUNT(tm.LeagueId) > 0
)


declare @matchDate  date = '10-Apr-2015'
select
	t1.TeamName [Home Team],
	tm.HomeGoals [Home Goals],
	t2.TeamName [Away Team],
	tm.AwayGoals [Away Goals],
	l.LeagueName [League Name]
from TeamMatches tm
join Teams t1 on t1.Id = tm.HomeTeamId
join Teams t2 on t2.Id = tm.AwayTeamId
join Leagues l on tm.LeagueId = l.Id
where l.IsSeasonal = 1 and tm.MatchDate > @matchDate
order by l.LeagueName, tm.HomeGoals desc, tm.AwayGoals desc