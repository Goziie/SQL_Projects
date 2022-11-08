--This project's main aim is to use SQL to analyze the SuperStore's dataset and answer a few questions.

select *
from Superstore

--Total Profits from all Products
select round(Sum(Profit), 2) as Total_Profits
From Superstore

--Total Sales generated from all products 
select round(sum(sales),0) as Total_Sales
From superstore
where sales is not null and quantity is not null

-- Count of Customers
Select count(distinct([Customer ID])) as Customer_Count
from Superstore

--Top 10 products by Sales
select TOP 10 [product Name], round(sum(sales), 0) as Total_Sales
from superstore
where sales is not null and quantity is not null
Group by [product Name]
order by 2 desc

-- ## Analyse the Products at Sub-Category level ##

--Top 10 Selling Sub-Categories
select Top 10 [Sub-Category],  round(sum(sales), 0) as Total_Sales
from superstore
Group by [Sub-Category] 
order by 2 desc

-- Top 10 Profitable Sub-Categories 
select Top 10 [Sub-Category], Convert(int, Sum(Profit) )as Top_Profits
from superstore
Group by [Sub-Category]
order by 2 desc

--Least Profitable Sub-Categories & Cities
select Top 10 [Sub-Category],  Convert(int, Sum(Profit) )as Top_Profits
from superstore
Group by [Sub-Category]
order by 2 

--Region Wise Sub-Category Products Sales 
select [Sub-Category], Region, round(sum(sales), 0) as Total_Sales
from superstore
Group by [Sub-Category], Region
order by 3 desc


-- ## Analyse the Products at Sub-Category level ##

-- Sales of each Segment
Select Segment, Round(sum(sales), 0) as Total_Sales
from superstore
group by Segment
Order by Total_Sales desc

-- Sales & Profits of 10 Best Customers
select Top 10 [customer name], Convert(int, Sum(sales) )as Top_Sales, Round(sum(profit), 0) as Total_Profits
from superstore
where profit not like '-%' and sales is not null and quantity is not null
group by [customer name]
order by 2 desc

-- Frequent Customer Purchase
Select Top 10 [customer name], count([customer name]) as OrderCount
from superstore
where sales is not null and quantity is not null
group by [customer name]
order by OrderCount desc

-- Analyze the Orders & Sales
with Test_cte as
(Select Country , Convert(int, Sum(sales))as Total_Sales,
      Case when [Order ID] like '%2014%' then '2014'
	       when [Order ID] like '%2015%' then '2015'
		   when [Order ID] like '%2016%' then '2016'
		   when [Order ID] like '%2017%' then '2017'
		   Else 'Error' End as Sales_Year
from superstore
where sales is not null and quantity is not null
Group by Country,[Order ID] )
 
Select Country, Sales_Year, sum(Total_sales) as Sales_Total
from Test_cte
Group by Country, Sales_Year
Order By Sales_Total desc

--7 Top 10 Products each year(2014, 2015, 2016, 2017)
-- 2014
Select TOP 10 [Product Name], Round(Sum(Profit),0) as Profit
from superstore
where year([Order Date]) = '2014' and sales is not null and quantity is not null
group by [product Name]
order by 2 desc

-- 2015
Select TOP 10 [Product Name], Round(Sum(Profit),0) as Profit
from superstore
where year([Order Date]) = '2015' and sales is not null and quantity is not null
group by [product Name]
order by 2 desc

-- 2016
Select TOP 10 [Product Name], Round(Sum(Profit),0) as Profit
from superstore
where year([Order Date]) = '2016' and sales is not null and quantity is not null
group by [product Name]
order by 2 desc

-- 2017
Select TOP 10 [Product Name], Round(Sum(Profit),0) as Profit
from superstore
where year([Order Date]) = '2017' and sales is not null and quantity is not null
group by [product Name]
order by 2 desc

-- ## Analyze the Geography ##

-- Most Profitable transaction cities
with profit_cte as 
(select City, sum (Profit) as total_profit
 from superstore
 group by City)

select city, total_profit ,cast((total_profit)/sum(total_profit)over( )*100 as int) as percentage_profit
 from profit_cte
 
 order by total_profit desc

-- Most Profitable transaction States
with Stateprofit_cte as 
(select State, sum (Profit) as total_profit
 from superstore
 group by State)

select State, cast(total_profit as int) as Total_Profit,cast((total_profit)/sum(total_profit)over( )*100 as int) as percentage_profit
 from Stateprofit_cte
 
 order by total_profit desc


-- Transaction counts in different states
Select  State, count(distinct(Sales)) as OrderCount_PerState
from superstore
where sales is not null and quantity is not null
group by State
order by OrderCount_PerState desc

--Preferred Shipping Mode
Select [Ship Mode], Sum(quantity) as Order_Volume 
from superstore
group by [Ship Mode]
Order by Order_Volume  desc

