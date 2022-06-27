drop table if exists HousePrice

select year(observation_date) YEAR, AVG(MSPUS) AVG_HOUSE_SALES_PRICE into HousePrice from RealEstate..HouseSalesPrice
GROUP BY year(observation_date)

select * from HousePrice
-----------------------------------------------------------------------------------------------------------------------------
drop table if exists MedianIncome

select Year, [Median Household Income] into MedianIncome from RealEstate..MEDIANINCOME

select * from MedianIncome
-----------------------------------------------------------------------------------------------------------------------------
drop table if exists TotalPopulation

select label year, [Total Population] into TotalPopulation from RealEstate..Population
-----------------------------------------------------------------------------------------------------------------------------
drop table if exists IR

select year, Interest_rate into IR from
(select year([Release Date]) year, Actual Interest_rate
, row_number() over(partition by year([Release Date]) order by year([Release Date]), month([Release Date]) desc) r from RealEstate..InterestRates) t
where r =1
order by year asc

select * from IR
-----------------------------------------------------------------------------------------------------------------------------
drop table if exists RealGDP

select Year, [Real GDP (trillions)] gdp_in_tr into RealGDP from RealEstate..GDP
-----------------------------------------------------------------------------------------------------------------------------
drop table if exists CPIData

select YEAR, AVE# into CPIData from RealEstate..CPI

Select * from CPIData
-----------------------------------------------------------------------------------------------------------------------------

select a.YEAR, AVG_HOUSE_SALES_PRICE [AverageSalesPrice (in $)], cast(replace(substring([Median Household Income],2,len([Median Household Income])-1),',','') as float) as [Median Household Income]
, [Total Population], Interest_rate, cast(replace(replace(gdp_in_tr,'$',''),',','.') as float) GDP, AVE# CPI 
from HousePrice a inner join MedianIncome b on a.YEAR=b.Year inner join TotalPopulation c on a.YEAR=c.year 
inner join IR d on d.year=a.YEAR inner join RealGDP e on e.Year=a.YEAR inner join CPIData f on f.YEAR=a.YEAR