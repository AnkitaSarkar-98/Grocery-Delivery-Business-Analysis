CREATE DATABASE BUNCHA_TECH;
CREATE TABLE USERS_TABLE(
Id int primary key,
User_name varchar(50),
Created_at datetime);
INSERT INTO USERS_TABLE
(Id, User_name, Created_at)
values
(24280, "Kayla Evans", "2023-03-06"),
(24603, "Nichole Robinson", "2023-06-21"),
(24812, "Amanda Luedtke", "2023-03-07"),
(25039, "Cassandra Nelson", "2023-03-17"),
(25040, "Deena Hougard", "2023-03-17"),
(25851, "John Horihan", "2023-04-02"),
(25953, "Katie Cvelbar", "2023-04-03");

select* from users_table;

CREATE TABLE ORDERS_TABLE(
Id int primary key,
BuyerId int,
Created_at date,
Canceled boolean,
FOREIGN KEY (BuyerId) REFERENCES USERS_TABLE(Id));

insert into ORDERS_TABLE
(Id, BuyerId, Created_at, Canceled)
values
(67507, 24280, "2023-03-08",FALSE),
(67618, 25039, "2023-03-29",FALSE),
(68660, 24603, "2023-07-05", TRUE),
(68750, 24280, "2023-04-02", FALSE),
(69645, 25851, "2023-04-07", TRUE),
(70264, 24603, "2023-07-08", FALSE),
(70390, 25953, "2023-04-10", FALSE);
select* from users_table;

Select * 
from ORDERS_TABLE
WHERE Canceled = FALSE;

SELECT 
    BuyerId, 
    Id AS OrderId, 
    Created_at,
    ROW_NUMBER() OVER (PARTITION BY BuyerId ORDER BY Created_at) AS order_rank
FROM ORDERS_TABLE
WHERE Canceled = FALSE;

WITH RankedOrders AS (
    SELECT 
        BuyerId, 
        Created_at AS CurrentOrderTime,
        LAG(Created_at) OVER (PARTITION BY BuyerId ORDER BY Created_at) AS PreviousOrderTime
    FROM ORDERS_TABLE
    WHERE Canceled = FALSE
)
SELECT 
    BuyerId,
    AVG(DATEDIFF(CurrentOrderTime, PreviousOrderTime)) AS AvgDaysBetweenOrders
FROM RankedOrders
WHERE PreviousOrderTime IS NOT NULL
GROUP BY BuyerId;

-- The average time between consecutive orders is 25 days.
    



