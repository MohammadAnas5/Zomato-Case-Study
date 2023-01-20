--1 What is the total amount each customer spent on zomato ?
SELECT s.user_id,sum(p.price)
FROM sales s 
JOIN product p  
ON s.product_id=p.product_id 
GROUP by s.us

--2 How many days each customer visited zomato ?
SELECT user_id,COUNT(created_at) 
FROM sales 
GROUP by user_id

--3  What was the first product purchased by each customer ? which is our catchy or attracting product 
--  increase it production to decrease delivery time  and also add same type of product to increase its sales
SELECT sales.user_id,sales.product_id 
FROM sales 
where sales.created_at 
IN (SELECT MIN(sales.created_at) 
    FROM `sales` 
    GROUP by sales.user_id)

-- with rank function 
SELECT * FROM ( 
  SELECT *,rank() over(
                       PARTITION by user_id 
                       ORDER by created_at) rnk 
  from sales)a 
  WHERE rnk =1; 
  
--4  What is the most purchased item on the menu and how many times was it purchased by all customer ? 
-- we able to understand teste of customer going from where to where,then we provide differnt ads for new users and old users
--a.
SELECT product_id,COUNT(product_id) a FROM `sales` GROUP by product_id ORDER by a DESC LIMIT 1 

--b. 
With t1 as (SELECT * FROM sales 
            WHERE product_id 
               IN (SELECT product_id 
                   FROM (SELECT product_id,COUNT(product_id) a 
                         FROM `sales` 
                         GROUP by product_id 
                         ORDER by a DESC 
                         LIMIT 1) A ) ) 

SELECT user_id, COUNT(user_id) FROM t1 GROUP by user_id

-- 5 Which item is most popular for each customer ? 

-- pertcular user buy perticular item how many times,
with t1 as (
  SELECT user_id,product_id,COUNT(product_id)cnt 
  FROM `sales` 
  GROUP by user_id,product_id )

SELECT user_id, product_id 
FROM (SELECT *,rank() over(PARTITION by user_id ORDER BY cnt DESC) rnk 
      from t1)a 
      WHERE rnk=1

--6 Which item was purchased first by the customer after the become a gold member ? 

-- order placed after the gold membership taken by that perticular users
WITH t1 AS(SELECT s.user_id,s.product_id,s.created_at 
           FROM sales s join gold_user_signup g ON g.user_id=s.user_id WHERE g.gold_signup_date<=s.created_at)

SELECT user_id,product_id FROM (SELECT *,rank() over(PARTITION BY user_id ORDER by created_at ) rnk from t1 )a WHERE rnk=1 

--7 Which item was purchased just before they become a gold member ? 

WITH t1 AS(SELECT s.user_id,s.product_id,s.created_at 
           FROM sales s 
           join gold_user_signup g 
           ON g.user_id=s.user_id 
           WHERE g.gold_signup_date>s.created_at)

SELECT user_id,product_id FROM (
                                SELECT *,rank() over(PARTITION BY user_id ORDER by created_at DESC ) rnk 
                                from t1 )a 
                                WHERE rnk=1
