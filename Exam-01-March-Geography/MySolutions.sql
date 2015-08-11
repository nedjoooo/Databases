--Problem 1.	All Mountain Peaks
--Display all ad mountain peaks in alphabetical order. Submit for evaluation the result grid with headers.

select p.PeakName
from Peaks p
order by p.PeakName

--Problem 2.	Biggest Countries by Population
--Find the 30 biggest countries by population from Europe. Display the country name and population. 
--Sort the results by population (from biggest to smallest), then by country alphabetically. 
--Submit for evaluation the result grid with headers.

select top 30 c.CountryName, c.Population
from Countries c
join Continents cn on c.ContinentCode = cn.ContinentCode
where cn.ContinentName = 'Europe'
order by c.Population desc, c.CountryName

--Problem 3.	Countries and Currency (Euro / Not Euro)
--Find all countries along with information about their currency. 
--Display the country code, country name and information about its currency: either "Euro" or "Not Euro". 
--Sort the results by country name alphabetically. Submit for evaluation the result grid with headers.

select 
	c.CountryName, 
	c.CountryCode,
	(case
		when c.CurrencyCode = 'EUR' then 'Euro'
		else 'Not Euro'
	end) [Currency]
from Countries c
order by c.CountryName

--Problem 4.	Countries Holding 'A' 3 or More Times
--Find all countries that holds the letter 'A' in their name at least 3 times (case insensitively), 
--sorted by ISO code. Display the country name and ISO code. Submit for evaluation the result grid with headers.

select
	 c.CountryName [Country Name],
	 c.IsoCode [ISO Code]
from Countries c
where LEN(c.CountryName) - LEN(replace(c.CountryName, 'a', '')) >= 3
order by c.IsoCode

--Problem 5.	Peaks and Mountains
--Find all peaks along with their mountain sorted by elevation (from the highest to the lowest), 
--then by peak name alphabetically. Display the peak name, mountain range name and elevation. 
--Submit for evaluation the result grid with headers.

select p.PeakName, m.MountainRange [Mountain], p.Elevation
from Peaks p
join Mountains m on p.MountainId = m.Id
order by p.Elevation desc

--Problem 6.	Peaks with Their Mountain, Country and Continent
--Find all peaks along with their mountain, country and continent. When a mountain belongs to multiple countries, 
--display them all. Sort the results by peak name alphabetically, then by country name alphabetically. 
--Submit for evaluation the result grid with headers.

select 
	p.PeakName, 
	m.MountainRange [Mountain], 
	c.CountryName, 
	cn.ContinentName
from Peaks p
join Mountains m on p.MountainId = m.Id
join MountainsCountries mc on m.Id = mc.MountainId
join Countries c on mc.CountryCode = c.CountryCode
join Continents cn on c.ContinentCode = cn.ContinentCode
order by p.PeakName, c.CountryName

--Rivers Passing through 3 or More Countries
--Find all rivers that pass through to 3 or more countries. Display the river name and the number of countries. 
--Sort the results by river name. Submit for evaluation the result grid with headers.

select 
	r.RiverName [River], 
	count(c.CountryCode) [Countries Count]
from Rivers r
join CountriesRivers cr on r.Id = cr.RiverId
join Countries c on cr.CountryCode = c.CountryCode
group by r.RiverName, r.Id
having count(c.CountryCode) >= 3
order by r.RiverName

--Problem 8.	Highest, Lowest and Average Peak Elevation
--Find the highest, lowest and average peak elevation. Submit for evaluation the result grid with headers.

select 
	MAX(p.Elevation) [MaxElevation],
	MIN(p.Elevation) [MinElevation],
	AVG(p.Elevation) [AverageElevation]
from Peaks p

--Problem 9.	Rivers by Country
--For each country in the database, display the number of rivers passing through that country 
--and the total length of these rivers. When a country does not have any river, 
--display 0 as rivers count and as total length. 
--Sort the results by rivers count (from largest to smallest), then by total length (from largest to smallest), 
--then by country alphabetically. Submit for evaluation the result grid with headers.

select 
	c.CountryName,
	cn.ContinentName,
	count(r.Id) [RiversCount],
	isnull(sum(r.Length), 0) [TotalLength]
from Countries c
left join Continents cn on c.ContinentCode = cn.ContinentCode
left join CountriesRivers cr on cr.CountryCode = c.CountryCode
left join Rivers r on cr.RiverId = r.Id
group by c.CountryName, c.CountryCode, cn.ContinentName, cn.ContinentCode
order by count(r.Id) desc, sum(r.Length) desc, c.CountryName

--Problem 10.	Count of Countries by Currency
--Find the number of countries for each currency. Display three columns: currency code, 
--currency description and number of countries. Sort the results by number of countries (from highest to lowest), 
--then by currency description alphabetically. Name the columns exactly like in the table below. 
--Submit for evaluation the result grid with headers.

select 
	cr.CurrencyCode,
	cr.Description [Currency],
	count(c.CurrencyCode) [NumberOfCountries]
from Currencies cr
left join Countries c on cr.CurrencyCode = c.CurrencyCode
group by cr.CurrencyCode, cr.Description
order by count(c.CurrencyCode) desc, cr.Description

--Population and Area by Continent
--For each continent, display the total area and total population of all its countries. 
--Sort the results by population from highest to lowest. Submit for evaluation the result grid with headers.

select 
	cn.ContinentName,
	SUM(c.AreaInSqKm) [CountriesArea],
	SUM(CONVERT(bigint, c.Population)) [CountriesPopulation]
from Continents cn
join Countries c on cn.ContinentCode = c.ContinentCode
group by cn.ContinentName, cn.ContinentCode
order by SUM(CONVERT(bigint, c.Population)) desc

--Problem 12.	Highest Peak and Longest River by Country
--For each country, find the elevation of the highest peak and the length of the longest river, 
--sorted by the highest peak elevation (from highest to lowest), 
--then by the longest river length (from longest to smallest), then by country name (alphabetically). 
--Display NULL when no data is available in some of the columns. Submit for evaluation the result grid with headers.

select 
	c.CountryName,
	max(p.Elevation) [HighestPeakElevation],
	max(r.Length) [LongestRiverLength]
from Countries c
left join MountainsCountries mc on mc.CountryCode = c.CountryCode
left join Mountains m on mc.MountainId = m.Id
left join Peaks p on m.Id = p.MountainId
left join CountriesRivers cr on cr.CountryCode = c.CountryCode
left join Rivers r on cr.RiverId = r.Id
group by c.CountryName, c.CountryCode
order by max(p.Elevation) desc, max(r.Length) desc, c.CountryName

--Problem 13.	Mix of Peak and River Names
--Combine all peak names with all river names, so that the last letter of each peak name is the same like 
--the first letter of its corresponding river name. Display the peak names, river names, and the obtained mix. 
--Sort the results by the obtained mix. Submit for evaluation the result grid with headers.

select 
	p.PeakName,
	r.RiverName,
	LOWER(LEFT(p.PeakName, LEN(p.PeakName) - 1) + r.RiverName) [Mix]
from Peaks p, Rivers r
where RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
order by LOWER(LEFT(p.PeakName, LEN(p.PeakName) - 1) + r.RiverName)


--Highest Peak Name and Elevation by Country
--For each country, find the name and elevation of the highest peak, along with its mountain. 
--When no peaks are available in some country, display elevation 0, "(no highest peak)" as peak name 
--and "(no mountain)" as mountain name. When multiple peaks in some country have the same elevation, 
--display all of them. Sort the results by country name alphabetically, then by highest peak name alphabetically. 
--Submit for evaluation the result grid with headers.

select 
	c.CountryName [Country],
	isnull((select pk.PeakName 
			from Peaks pk 
			where pk.Elevation = max(p.Elevation)),
		'(no highest peak)') [Highest Peak Name],
	isnull(max(p.Elevation), 0) [Highest Peak Elevation],
	isnull((select mo.MountainRange
			from Mountains mo
			join Peaks pe on mo.Id = pe.MountainId
			where pe.Elevation = max(p.Elevation)), 
		'(no mountain)') [Mountain]
from Countries c
left join MountainsCountries mc on mc.CountryCode = c.CountryCode
left join Mountains m on mc.MountainId = m.Id
left join Peaks p on p.MountainId = m.Id
group by c.CountryName, c.CountryCode
order by c.CountryName, [Highest Peak Name]

--Problem 15.	Monasteries by Country
--1.	Create a table Monasteries(Id, Name, CountryCode). Use auto-increment for the primary key. 
--Create a foreign key between the tables Monasteries and Countries.

use Geography
go

create table Monasteries(
	Id int not null identity primary key,
	Name nvarchar(100) not null,
	CountryCode char(2) not null
)

go

alter table Monasteries
add constraint FK_Monasteries_Countries
foreign key(CountryCode) references Countries(CountryCode)

--2.	Execute the following SQL script (it should pass without any errors):

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')


--3.	Write a SQL command to add a new Boolean column IsDeleted in the Countries table 
--(defaults to false). Note that there is no "Boolean" type in SQL server, 
--so you should use an alternative.

use Geography
go

ALTER TABLE Countries 
ADD IsDeleted BIT NOT NULL DEFAULT 0

--4.	Write and execute a SQL command to mark as deleted all countries that have more than 3 rivers.

use Geography
go

update Countries
set IsDeleted = 1
where CountryCode in (select c.CountryCode
						from Countries c
						join CountriesRivers cr on c.CountryCode = cr.CountryCode
						join Rivers r on cr.RiverId = r.Id
						group by c.CountryCode
						having COUNT(r.Id) > 3)

--5.	Write a query to display all monasteries along with their countries sorted by monastery name. 
--Skip all deleted countries and their monasteries. Submit for evaluation the result grid with headers.

select m.Name [Monastery], c.CountryName [Country]
from Monasteries m
join Countries c on m.CountryCode = c.CountryCode
where c.IsDeleted = 0
order by m.Name


--Problem 16.	Monasteries by Continents and Countries

--1.	Write and execute a SQL command that changes the country named "Myanmar" to its other name "Burma".

update Countries
set CountryName = 'Burma'
where CountryName = 'Myanmar'

--2.	Add a new monastery holding the following information: Name="Hanga Abbey", Country="Tanzania".

insert into Monasteries(Name, CountryCode)
values('Hanga Abbey',
		(select c.CountryCode
			from Countries c
			where c.CountryName = 'Tanzania')
		)

--3.	Add a new monastery holding the following information: Name="Myin-Tin-Daik", Country="Myanmar".

insert into Monasteries(Name, CountryCode)
values('Myin-Tin-Daik',
		(select c.CountryCode
			from Countries c
			where c.CountryName = 'Myanmar')
		)

--4.	Find the count of monasteries for each continent and not deleted country. 
--Display the continent name, the country name and the count of monasteries. 
--Include also the countries with 0 monasteries. 
--Sort the results by monasteries count (from largest to lowest), then by country name alphabetically. 
--Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.

select 
	cn.ContinentName,
	c.CountryName,
	count(m.Id) [MonasteriesCount]
from Continents cn
left join Countries c on c.ContinentCode = cn.ContinentCode
left join Monasteries m on c.CountryCode = m.CountryCode
group by cn.ContinentCode, cn.ContinentName, c.CountryCode, c.CountryName
having c.CountryCode in (
							select CountryCode
							from Countries
							where IsDeleted = 0
							)
order by [MonasteriesCount] desc, c.CountryName


--Problem 17.	Stored Function: Mountain Peaks JSON

--Create a stored function fn_MountainsPeaksJSON that lists all mountains alphabetically 
-- along with all its peaks alphabetically. Format the output as JSON string without any whitespace.

alter function fn_MountainsPeaksJSON()
returns nvarchar(max)
begin
	declare @mountaunsPeaksJson nvarchar(max) = '{"mountains":['
	declare cursor_mountains cursor read_only fast_forward for
		select MountainRange from Mountains
	declare @mountain nvarchar(max)
	open cursor_mountains
	fetch next from cursor_mountains into @mountain
	while(@@FETCH_STATUS = 0)
	begin
		declare @mountainJson nvarchar(max)
		set @mountainJson = '{"name":"' + @mountain + '","peaks":['
		declare cursor_peaks cursor read_only fast_forward for
			select p.PeakName, p.Elevation from Peaks p
			join Mountains m on m.Id = p.MountainId
			where m.MountainRange = @mountain
		declare @peak nvarchar(max)
		declare @elevation int
		open cursor_peaks
		fetch next from cursor_peaks into @peak, @elevation
		while(@@FETCH_STATUS = 0)
		begin
			declare @peakJson nvarchar(max)
			set @peakJson = '{"name":"' + @peak +'","elevation":' + 
				convert(nvarchar(max), @elevation) + '}'						
			fetch next from cursor_peaks into @peak, @elevation
			if @@FETCH_STATUS = 0
				set @peakJson = @peakJson + ','
			set @mountainJson = @mountainJson + @peakJson
		end
		close cursor_peaks
		deallocate cursor_peaks
		set @mountainJson = @mountainJson + ']}'		
		fetch next from cursor_mountains into @mountain
		if @@FETCH_STATUS = 0
				set @mountainJson = @mountainJson + ','
		set @mountaunsPeaksJson = @mountaunsPeaksJson + @mountainJson
	end
	close cursor_mountains
	deallocate cursor_mountains
	set @mountaunsPeaksJson = @mountaunsPeaksJson + ']}'
	return @mountaunsPeaksJson
end

go

SELECT dbo.fn_MountainsPeaksJSON()

go

if(OBJECT_ID('fn_MountainsPeaksJSON') is not null)
drop function fn_MountainsPeaksJSON