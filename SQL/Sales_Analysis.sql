/*
=========================================================
Project: Global Sales Performance Analysis
Author: Rahul Bansal
Tools: MySQL, Excel, Power BI
Dataset: Global Superstore
Description:
This SQL script contains business analysis queries
used to build the Power BI dashboard.
=========================================================
*/

ALTER TABLE returns
CHANGE COLUMN `ï»¿Returned` Returned TEXT;
ALTER TABLE returns
CHANGE COLUMN `Order ID` Order_ID VARCHAR(30);

CREATE TABLE customers (
    Customer_ID VARCHAR(30) PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Segment VARCHAR(50) NOT NULL
);

INSERT INTO customers (Customer_ID, Customer_Name, Segment)
SELECT DISTINCT
    Customer_ID,
    Customer_Name,
    Segment
FROM orders;

SELECT COUNT(*) AS Total_Customers
FROM customers;


CREATE TABLE products (
    Product_ID VARCHAR(50) PRIMARY KEY,
    Product_Name VARCHAR(255) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Sub_Category VARCHAR(50) NOT NULL
);


SELECT
    YEAR(Order_Date) AS Year,
    MONTHNAME(Order_Date) AS Month,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);

SELECT
    Category,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM orders
GROUP BY Category
ORDER BY Profit_Margin;

SELECT
    Discount,
    ROUND(SUM(Sales),2) AS Sales,
    ROUND(SUM(Profit),2) AS Profit
FROM orders
GROUP BY Discount
ORDER BY Discount;

-- TOP 10 LOSS MAKING PRODUCTS
SELECT
    Product_Name,
    Category,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY Product_Name, Category
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;

-- Least Profitable Sub-Categories
SELECT
    Sub_Category,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100,2) AS Profit_Margin
FROM orders
GROUP BY Sub_Category
ORDER BY Profit_Margin ASC;

-- Regional Profit Analysis
SELECT
    Region,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100,2) AS Profit_Margin
FROM orders
GROUP BY Region
ORDER BY Profit_Margin ASC;

-- RETURN ANALYSIS
SELECT
    CASE
        WHEN r.Returned = 'Yes' THEN 'Returned'
        ELSE 'Not Returned'
    END AS Return_Status,

    COUNT(o.Order_ID) AS Total_Orders,

    ROUND(SUM(o.Sales),2) AS Total_Sales,

    ROUND(SUM(o.Profit),2) AS Total_Profit

FROM orders o
LEFT JOIN returns r
ON o.Order_ID = r.Order_ID

GROUP BY Return_Status;



-- TOP 10 MOST PROFITABLE CUSTOMERS
SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM orders
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Profit DESC
LIMIT 10;

-- Market-wise Profit Analysis

SELECT
    Market,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM orders
GROUP BY Market
ORDER BY Profit_Margin ASC;

-- Shipping Mode Analysis

SELECT
    Ship_Mode,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM orders
GROUP BY Ship_Mode
ORDER BY Profit_Margin DESC;

-- Top 10 Products by Sales
SELECT
    Product_Name,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM orders
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Year-over-Year Sales
SELECT
    YEAR(Order_Date) AS Year,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM orders
GROUP BY YEAR(Order_Date)
ORDER BY Year;