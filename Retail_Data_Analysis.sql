----Title      :- Retail Transactions
----Created by :- Gaurav Varma
----Date       :- 29-09-2022    
---Tool used   :- Postgre SQL

/* 
Description :-
		* This is a Retail Transactions SQL Project. This database contains 1 table "Retail"ABORT
		* "Retail" table has 10 columns and 75620 rows
		
Approach :- 
		* Understanding the dataset
		* Creating business questions
		* Analysing the dataset through the SQL queries and finding useful insights
		
*/		

---1) Create a Table "Retails" with appropriate datatypes for columns
CREATE TABLE Retail
(
transaction_date date,
transaction_hour time,
location_state VARCHAR,
location_city VARCHAR,
rewards_number VARCHAR,
rewards_member VARCHAR,
num_of_items INT,
coupon_flag VARCHAR,
discount_amt DECIMAL,
order_amt DECIMAL
);

--2) Import data from the csv file 'Retail_Transactions.csv' attached in resources to "Retail" table
-- setting the datetype stype as mdy(month,day,year) to avoid any error
set datestyle = mdy;
Copy retail from 'D:\Retail_DataSet_SQL_Project\Retail Transactions.csv' CSV header;

SELECT * from Retail;

---3) Get an output with a total order amount month wise sorted by months in a descending order
SELECT
	SUM(Retail.order_amt) AS Total_Order_Amount,
	EXTRACT(Month from retail.transaction_date) as Month_NUmber
FROM Retail
GROUP BY Month_Number
ORDER BY Month_Number DESC;

---4) Get an output with a total Order Amount month wise sorted by ordered amount highest to lowet

SELECT
	SUM(Retail.order_amt) AS Total_Order_Amount,
	EXTRACT(Month from Retail.transaction_date) as Month_name,
FROM Retail
GROUP BY Month_name
ORDER BY Total_Order_Amount DESC;

---5) Get an output which represents maximum ordered amount
SELECT MAX(Total_Sales)
FROM(SELECT 
	 	SUM(Retail.order_amt) AS Total_Sales,
		EXTRACT(Month from Retail.transaction_date) as Month_name
	FROM Retail
	GROUP BY Month_name
	ORDER BY Total_Sales DESC) as Max_Sale;


---6) Get the min order amount(Method : View)

CREATE VIEW Lowest_Sale AS

SELECT
	SUM(Retail.order_amt) AS Total_Sales,
	EXTRACT(Month from Retail.transaction_date) as Month_name
FROM Retail
GROUP BY Month_name
ORDER BY Total_Sales DESC;

SELECT MIN(Total_Sales) as Minimum_Sale
FROM Lowest_Sale;


---7) Get the minimum Order Amount (Methon- Subquery)
SELECT MIN(Total_Sales)
FROM(SELECT 
	 	SUM(Retail.order_amt) AS Total_Sales,
		EXTRACT(Month from Retail.transaction_date) as Month_name
	FROM Retail
	GROUP BY Month_name
	ORDER BY Total_Sales DESC) as Min_Sale;
	

---8) Get an output presenting total order amount from each city from high to low

SELECT 
	 	SUM(Retail.order_amt) AS Total_Sales,
		location_city
	FROM Retail
	GROUP BY location_city
	ORDER BY Total_Sales DESC;


---9) Get an output presenting total order amount for each state from high to low

SELECT 
	 	SUM(Retail.order_amt) AS Total_Sales,
		location_state
FROM Retail
GROUP BY location_state
ORDER BY Total_Sales DESC;


----10) Get an output presenting total order amount made by company in every hour
SELECT 
	 	SUM(Retail.order_amt) AS Total_Sales,
		EXTRACT(HOUR from Retail.transaction_hour) as Each_Hour
FROM Retail
GROUP BY Each_Hour
ORDER BY Total_Sales DESC;


---11) Get an output presenting count of rewards which were genuine

SELECT COUNT(Retail.Rewards_number) as Total_Genuine_Reward_Count
FROM retail
WHERE rewards_member = 'TRUE';
	

---12) Get an output presenting count of rewards which were fake
SELECT COUNT(Retail.Rewards_number) as Total_Genuine_Reward_Count
FROM retail
WHERE rewards_member = 'FALSE';


--- 13) Give an output which represents total, max, min, avg discount given to the customer in each city and if the value is in decimal then round off to 3 decimal points

SELECT
	Retail.location_city as City_Name,
	SUM(Retail.discount_amt) as Total_discount,
	MAX(Retail.discount_amt) as Maximum_discount,
	MIN(Retail.discount_amt) as Minimum_discount,
	ROUND(AVG(Retail.discount_amt),3) as Average_discount
FROM Retail
GROUP BY location_city;



---14) Calculate the discount% given to the customer in each city
SELECT 
	Retail.location_city as City_Name,
	round((sum(Retail.discount_amt))/(sum(Retail.order_amt))*100,2) as Discount_Percentage
FROM retail
GROUP BY City_Name
Order by Discount_Percentage DESC;

--- 15) Give an output which represents total,max,min,avg Ordered Amount given to the customer in each city


SELECT 
	Retail.location_city as City_Name,
	SUM(Retail.order_amt) as Total_Order_Amount,
	MAX(Retail.order_amt) as Maximum_Order_Amount,
	MIN(Retail.order_amt) as Minimum_Order_Amount,
	AVG(Retail.order_amt) as Average_Order_Amount
FROM Retail
GROUP BY City_Name;



--- 16) Give an output which represents total,max,min,avg Number of order's(total number of items) ordered by the customers in each city

SELECT 
	Retail.location_city as City_Name,
	SUM(Retail.num_of_items) as Total_Orders,
	MAX(Retail.num_of_items) as Maximum_No_of_Items_Ordered,
	MIN(Retail.num_of_items) as Maximum_No_of_Items_Ordered,
	ROUND(AVG(Retail.num_of_items),2) as Average_No_of_Orders
FROM Retail
GROUP BY City_Name
ORDER BY Total_Orders;



--- 17) Identify state and city wise maximum amount of sales

SELECT 
	Retail.location_state as state_name,
	Retail.location_city as City,
	SUM(Retail.order_amt) as Total_Sales
FROM Retail
GROUP BY state_name,City
ORDER BY Total_Sales DESC;
