-- UTIVA Capstone Project II
--From the international breweries data recorded for a duration of three years, you are directed to do the following analyses to aid better decision making in order to maximize profit and reduce loss to the lowest minimal.

--------------------- PROFIT ANALYSIS ----------------
--1.	Within the space of the last three years, what was the profit worth of the breweries, inclusive of the anglophone and the francophone territories?
		select sum(Profit) as Total_Profit 
		from dbo.International_Breweries

  -- 2.	Compare the total profit between these two territories in order for the territory manager, Mr. Stone make strategic decision that will aid profit maximization in 2020 
		select case when COUNTRIES in ('Nigeria', 'Ghana')  then 'Anglophone' else 'Francophone' end as Teritory
		,sum(profit) as Profit
		from dbo.International_Breweries
		group by case when COUNTRIES in ('Nigeria', 'Ghana')  then 'Anglophone' else 'Francophone' end;

-- 3.	Country that generated the highest profit in 2019
		select Top 1 countries, sum(profit) as Profit 
		from dbo.International_Breweries
		where Years = 2019
		group by countries
		order by sum(profit) desc
      
--  4. 	Help him find the year with the highest profit.
        select Top 1 YEARS , sum(profit) as Profit 
	    from dbo.International_Breweries
        group by YEARS 
        order by sum(profit) desc
     
--  5. 	Which month in the three years were the least profit generated?
		select Top 1 MONTHS , sum(profit) as Profit 
		from dbo.International_Breweries
        group by MONTHS 
        order by sum(profit) asc
       
--  6.  What was the minimum profit in the month of December 2018?
		select Top 1 months , YEARS,  Profit 
		from dbo.International_Breweries
        where YEARS = 2018 and MONTHS = 'December'
        order by Profit  asc
       
--  7.  Compare the profit in percentage for each of the month in 2019
		with MonthsProfits as 
		(select months, sum (Profit) as total_profit
		from dbo.International_Breweries
		where years = 2019
		group by months)

		select months, total_profit , ((total_profit)/sum(total_profit)over( )*100 ) as percentageprofits
		from MonthsProfits
		order by total_profit desc

--8.    Which particular brand generated the highest profit in Senegal?
		select Top 1 Brands , sum(profit) as Total_Profit 
		from dbo.International_Breweries
		where countries like '%Senegal%'
		group by Brands       
		order by Total_Profit desc


--------------------- BRAND ANALYSIS ----------------

--1.	Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries
		select Top 3 Brands , sum(quantity) as Quantity 
		from dbo.International_Breweries
		where countries in ('senegal', 'Togo', 'Benin')
		and Years BETWEEN '2018' AND  '2019'
		group by Brands
		order by sum(quantity) desc
		 
--2.    Find out the top two choice of consumer brands in Ghana
		select Top 2 Brands , sum(quantity) as Quantity 
		from dbo.International_Breweries
		where countries = 'ghana'
		group by Brands
		order by Quantity desc

--3.    Find out the details of beers consumed in the past three years in the most oil reach country in West Africa
		select * 
		from dbo.International_Breweries
		where brands not like '%malt%';

--4.    Favorite malt brand in Anglophone region between 2018 and 2019
		select Top 1 Brands, sum(quantity) as Quantity 
		from dbo.International_Breweries
		where countries in ('Nigeria', 'Ghana') 
		and Years BETWEEN '2018' AND  '2019' 
		and brands like '%malt%' 
		group by Brands
		Order by Quantity desc

--5.    Which brands sold the highest in 2019 in Nigeria?
		select Brands, sum(quantity) as Quantity 
		from dbo.International_Breweries
		where Years = 2019 and countries = 'Nigeria'
		group by Brands
		order by Quantity desc
		
--6.    Favorites brand in South_South region in Nigeria
		select Top 1 Brands , sum(quantity) as Quantity 
		from dbo.International_Breweries
		where COUNTRIES like '%Nigeria%' and
		Region = 'southsouth'
		group by Brands
		order by sum(quantity) desc
		 
--7.    Beer consumption in Nigeria
		select sum(quantity) as Total_Beer_Consumption 
		from dbo.International_Breweries 
		where countries in ('Nigeria')
		and brands not like '%malt%';

--8.    Level of consumption of Budweiser in the regions in Nigeria
		select Region, sum(quantity) as Consumption_Level 
		from dbo.International_Breweries 
		where countries in ('Nigeria') and 
		brands ='budweiser'
		group by Region
		order by Consumption_Level desc;

--9.    Level of consumption of Budweiser in the regions in Nigeria in 2019 
		select Region, sum(quantity) as Consumption_Level 
		from dbo.International_Breweries 
		where countries in ('Nigeria') and 
		brands ='budweiser'
		and Years = '2019'
		group by Region
		order by Consumption_Level desc;

--------------------- COUNTRY ANALYSIS ----------------

--1.    Country with the highest consumption of beer.
		select Top 1 countries, sum(quantity) as Beer_Consumption
		from dbo.International_Breweries
		where brands not like '%malt%'
		group by countries 
		order by sum(quantity) desc
		
--2.   	Highest sales personnel of Budweiser in Senegal 
		select SALES_REP , sum(quantity) as Sales_Volume
		from dbo.International_Breweries 
		where countries in ('Senegal') and brands ='budweiser'
		group by SALES_REP
		order by sum(quantity) desc
		
--3.    Country with the highest profit of the fourth quarter in 2019
		select Top 1 countries, sum(profit) as Profit 
		from dbo.International_Breweries
		where Years = 2019 and  months in ('october', 'november', 'december')
		group by countries
		order by Profit desc
		










