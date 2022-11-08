--1. What is the total amount each customer spent at the restaurant?
Select s.customer_id, sum(price) as total_amount
from dbo.sales s
join dbo.menu m on 
s.product_id = m.product_id
group by customer_id

--Customer A spent $76.
--Customer B spent $74.
--Customer C spent $36.

 --2. How many days has each customer visited the restaurant?
 Select s.customer_id, count(distinct(order_date)) as Visit_count
 from dbo.sales s
 group by customer_id 

--Customer A visited 4 times.
--Customer B visited 6 times.
--Customer C visited 2 times.

 --3. What was the first item from the menu purchased by each customer?
 WITH ordered_sales_cte AS
(
   SELECT customer_id, order_date, product_name,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date) AS rank
   FROM dbo.sales AS s
   JOIN dbo.menu AS m
      ON s.product_id = m.product_id
)

SELECT customer_id, product_name
FROM ordered_sales_cte
WHERE rank = 1
GROUP BY customer_id, product_name;

--Customer A's first orders are curry and sushi.
--Customer B's first order is curry.
--Customer C's first order is ramen.

--4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT Top 1 (COUNT(s.product_id)) AS most_purchased, m.product_name
FROM dbo.sales AS s
JOIN dbo.menu AS m
   ON s.product_id = m.product_id
GROUP BY s.product_id, product_name
ORDER BY most_purchased DESC;

--Most purchased item on the menu is ramen which is 8 times. Yummy!

--5. Which item was the most popular for each customer?
WITH fav_item_cte AS
(
   SELECT s.customer_id, m.product_name, COUNT(m.product_id) AS order_count,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY COUNT(s.customer_id) DESC) AS rank
   FROM dbo.menu AS m
   JOIN dbo.sales AS s
      ON m.product_id = s.product_id
   GROUP BY s.customer_id, m.product_name
)

SELECT customer_id, product_name, order_count
FROM fav_item_cte 
WHERE rank = 1;

--Customer A and C's favourite item is ramen.
--Customer B enjoys all items on the menu. He/she is a true foodie, sounds like me!

--6. Which item was purchased first by the customer after they became a member?
WITH member_sales_cte AS 
(
   SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
      DENSE_RANK() OVER(PARTITION BY s.customer_id
      ORDER BY s.order_date) AS rank
   FROM sales AS s
   JOIN members AS m
      ON s.customer_id = m.customer_id
   WHERE s.order_date >= m.join_date
   )
SELECT s.customer_id, s.order_date, m2.product_name 
FROM member_sales_cte AS s
JOIN menu AS m2
   ON s.product_id = m2.product_id
WHERE rank = 1;

--Customer A's first order as member is curry.
--Customer B's first order as member is sushi.

--7. Which item was purchased just before the customer became a member?
WITH prior_member_purchased_cte AS 
(
   SELECT s.customer_id, m.join_date, s.order_date, s.product_id,
         DENSE_RANK() OVER(PARTITION BY s.customer_id
         ORDER BY s.order_date DESC) AS rank
   FROM sales AS s
   JOIN members AS m
      ON s.customer_id = m.customer_id
   WHERE s.order_date < m.join_date
)

SELECT s.customer_id, s.order_date, m2.product_name 
FROM prior_member_purchased_cte AS s
JOIN menu AS m2
   ON s.product_id = m2.product_id
WHERE rank = 1;

--Customer A’s last order before becoming a member is sushi and curry.
--Whereas for Customer B, it's sushi. That must have been a real good sushi!

--8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(DISTINCT s.product_id) AS unique_menu_item, 
   SUM(mm.price) AS total_sales
FROM sales AS s
JOIN members AS m
   ON s.customer_id = m.customer_id
JOIN menu AS mm
   ON s.product_id = mm.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;

--Before becoming members,

--Customer A spent $ 25 on 2 items.
--Customer B spent $40 on 2 items.

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?
WITH price_points_cte AS
(
   SELECT *, 
      CASE
         WHEN product_id = 1 THEN price * 20
         ELSE price * 10
      END AS points
   FROM menu
)

SELECT s.customer_id, SUM(p.points) AS total_points
FROM price_points_cte AS p
JOIN sales AS s
   ON p.product_id = s.product_id
GROUP BY s.customer_id

--Total points for Customer A is 860.
--Total points for Customer B is 940.
--Total points for Customer C is 360.

