SELECT * FROM brucha_task2.orders;

-- 1.Identify customers who haven't placed an order in the last 60 days but had at least 2 orders before

WITH CustomerOrderCounts AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count,
        MAX(order_date) AS last_order_date
    FROM brucha_task2.orders
    GROUP BY customer_id
    HAVING COUNT(order_id) >= 2
)
SELECT customer_id 
FROM CustomerOrderCounts
WHERE DATEDIFF(CURDATE(), last_order_date) > 60;

-- 2.Calculate the average time between consecutive orders for repeat customers

WITH RankedOrders AS (
    SELECT 
        customer_id, 
        order_date AS current_order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
    FROM brucha_task2.orders
)
SELECT 
    customer_id,
    AVG(DATEDIFF(current_order_date, previous_order_date)) AS avg_days_between_orders
FROM RankedOrders
WHERE previous_order_date IS NOT NULL
GROUP BY customer_id;

-- 3.Determine the top 10% of customers by total spend and their average order value


WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent,
        AVG(total_amount) AS avg_order_value
    FROM brucha_task2.orders
    GROUP BY customer_id
),
CustomerRanked AS (
    SELECT *,
           NTILE(10) OVER (ORDER BY total_spent DESC) AS percentile_rank
    FROM CustomerSpend
)
SELECT customer_id, total_spent, avg_order_value
FROM CustomerRanked
WHERE percentile_rank = 1;
 
 
 -- 4.Analyze delivery time efficiency by calculating the percentage of on-time deliveries per region

SELECT 
    o.city AS region,
    COUNT(CASE WHEN d.delivery_status = 'On Time' THEN 1 END) * 100.0 / COUNT(*) AS on_time_percentage
FROM brucha_task2.delivery_performance d
JOIN brucha_task2.orders o ON d.order_id = o.order_id
GROUP BY o.city;
