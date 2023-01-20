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
