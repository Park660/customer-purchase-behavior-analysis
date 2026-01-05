use StudentsDB

 CREATE TABLE df_customers_behavior (
    customer_id                VARCHAR(50),
    age                        INT,
    gender                     VARCHAR(10),
    income                     DECIMAL(12,2),
    location                   VARCHAR(50),
    customer_segment            VARCHAR(20),

    transaction_id             VARCHAR(50),
    date                        DATETIME,
    product_category            VARCHAR(50),
    product_id                 VARCHAR(50),

    quantity                   INT,
    unit_price                 DECIMAL(10,2),
    total_spent                DECIMAL(14,2),

    payment_method             VARCHAR(20),
    discount_applied            VARCHAR(10),

    loyalty_points_used        INT,
    previous_purchases         INT,
    average_spending           DECIMAL(12,2),

    last_purchase_days_ago     INT,
    browsing_time_before_purchase INT,
    preferred_shopping_time    VARCHAR(20),

    customer_satisfaction_rating INT
);
 select * from  df_customers_behavior



 -- 1. Total Revenue

  select sum(total_spent) as Total_Revenue from df_customers_behavior

 --2. Revenue by Product Category

  select  product_category,sum(total_spent) as Revenue from df_customers_behavior
  group by product_category
  order by Revenue desc

-- 3.Top 5 High-Value Customers

 select top 5 customer_id,sum(total_spent) as Total_spent from df_customers_behavior
 group by customer_id
 order by Total_spent desc

 --4. Customer Segment Performance

  select customer_segment ,round(avg(total_spent),2) as avg_spending from df_customers_behavior
  group by customer_segment
  order  by avg_spending asc

  --5. Gender-wise Revenue

   select gender ,sum(total_spent) as Revenue from df_customers_behavior WHERE gender IS NOT NULL
   group by gender 
   order by Revenue desc
   
        select product_category,avg(customer_satisfaction_rating) as avg_rating  from df_customers_behavior
        group by product_category

    -- 7. Monthly Sales Trends

    SELECT MONTH(date) AS month,
       SUM(total_spent) AS revenue
FROM df_customers_behavior
GROUP BY MONTH(date)
ORDER BY month;

--8. Ranking Customers (WINDOW FUNCTION)

  select customer_id, total_spent,   rank()  over(order by total_spent desc) as spending_rnk 
  from df_customers_behavior

  select location ,sum(total_spent) as Total_spent from df_customers_behavior 
  group by location
         
         WITH ranked_products AS (
        SELECT
        location,
        product_category,
        COUNT(*) AS cnt,
        ROW_NUMBER() OVER (
            PARTITION BY location
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM df_customers_behavior
    GROUP BY location, product_category
)
SELECT 
    location,
    product_category
FROM ranked_products
WHERE rn <=2;

select * from df_customers_behavior

 select preferred_shopping_time,sum(total_spent)  as Total_spent from df_customers_behavior
 group by preferred_shopping_time
 order by Total_spent desc


  select payment_method ,count(payment_method) from df_customers_behavior group by payment_method 

 select count(discount_applied) from df_customers_behavior
 where discount_applied='Yes'


   alter table df_customers_behavior
   drop column income


   select min(age) from df_customers_behavior

   with ranked_gender as (
    select gender,
    product_category,
    count(*) as cnt,
    ROW_NUMBER() over(partition by gender order by count(*)  desc) as rn
            from df_customers_behavior
            group by gender,product_category 
            )
       select gender,product_category from ranked_gender
       where rn <=2
