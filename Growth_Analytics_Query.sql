/******************************************************************************************************
*******************************************************************************************************
***					++++++      QUERY header    ++++++
***
***		Use case: City Level Growth Analysis
***		Stakeholder requester: Glovo 
***		Source: N/A
***		Report: N/A
***		Country: NG
***	    SQLCode Script   : SQL Server
*******************************************************************************************************
*******************************************************************************************************/

--To report of the previous month (last closed month), that includes the following information at the city level:
-- Total number of orders
-- Total number of orders coming from food partners
-- Share of orders that were delivered in less than 45 minutes
-- Share of orders coming from top stores
-- Share of stores that received no orders
-- Average spend in euros
-- Difference in average spend in euros between prime and non prime users
-- Number of customers who made their first order
-- Average monthly orders by recurrent customer (with recurrent we mean they had also made an order the month before)


-- Total number of orders
Select City, COUNT(id) as Total_Orders
From dbo.orders
group by city;

-- Total number of orders coming from food partners
SELECT o.city, store_name, COUNT(store_id) as Total_Count
From dbo.orders o
Full Join dbo.stores s  --Full Join is not suitable but applicable to get a result based on this data. Left Join is suitable
on o.store_id = s.id
where o.city is null and is_food = 'TRUE'
Group by o.city, store_name;

-- Share of orders that were delivered in less than 45 minutes
WITH city_total as (select
city, count(id) as nr_orders
from  dbo.orders
group by city
)
select o.city
, cast(sum(case when datediff(MINUTE,  Start_time,End_time) < 45 then 1 else 0 end) as float)/cast( max(city_total.nr_orders) as float) share_less_45mins
from  dbo.orders o
join city_total on city_total.city = o.city
group by o.city

select *,datediff(MINUTE, Start_time,End_time )ty
from dbo.orders
				--Faster Alternative---
select o.city
, cast(sum(case when datediff(MINUTE,  Start_time,End_time) < 45 then 1 else 0 end)as float)/cast (count(id) as float) share_less_45mins
from  dbo.orders o
group by o.city	

		
-- Share of orders coming from top stores
Select o.city, SUM(case when s.top_store = 'TRUE'  then 1 else 0 end ) / COUNT(s.id) as share_Top_stores
from dbo.orders o
Join dbo.stores s
on o.store_id = s.id
group by o.city;

-- Share of stores that received no orders
select o.city, sum(case when o.id is null  then 1 else 0 end )/nullif(count(o.id), 0) as No_order_share_count
from dbo.stores s
left Join dbo.orders o
on s.id = o.store_id
group by o.city;


-- Average spend in euros
Select city, AVG(total_cost_eur) as Avg_Spend
From dbo.orders
group by city;

-- Difference in average spend in euros between prime and non prime users
SELECT o.city, avg(case when is_prime = 'FALSE'  then o.total_cost_eur else 0 end )  -
			avg(case when is_prime = 'TRUE'  then o.total_cost_eur else 0 end) as difference_avg_spend   
From dbo.orders o
Join dbo.customers c
on o.customer_id = c.id
where o.city is null
Group by o.city;

-- Number of customers who made their first order
WITH cte_order AS (
  SELECT city, 
    customer_id,
    ROW_NUMBER() OVER(
     PARTITION BY city, customer_id
      ORDER BY 
        start_time
   ) AS RN
    FROM dbo.orders 
  group by city, customer_id, start_time
)
SELECT city, count(customer_id) as No_First_Order_Customers
FROM cte_order
WHERE RN = 1
group by city;

-- Average monthly orders by recurrent customer (with recurrent we mean they had also made an order the month before)
-- ** Please note that I have different variation of this code, I would love to get a feedback from the team if possible
with ordersData as
(select city, DATENAME(MONTH, end_time) as Months,count(Id) as ordersCount 
from  Orders
group by city, DATENAME(MONTH, end_time)),

Recurrentcustomer as
(select c.id,  c.preferred_city, ROW_NUMBER() over (partition by DATENAME(MONTH, end_time) order by c.id) rn, count(o.Id) as ordersCount
from customers c
join orders o
on c.id = o.customer_id
group by c.id, c.preferred_city,DATENAME(MONTH, end_time)
having count(o.Id) > 1)

 SELECT  r.Id as Recurrent_customers, preferred_city, Months,
LEAD(avg(o.ordersCount), 1) OVER (
PARTITION BY preferred_city
ORDER BY Months DESC
) AS Average_monthly_orders
from Recurrentcustomer r 
full outer join ordersData o 
on o.city=r.preferred_city 
group by preferred_city,Months, r.Id;

