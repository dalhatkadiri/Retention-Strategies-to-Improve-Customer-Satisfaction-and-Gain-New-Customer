

'Retention Strategies to Improve Customer Satisfaction and Gain New Customers

1. Introduction
In the highly competitive retail industry, customer retention and acquisition are crucial for sustained growth. This project focuses on analyzing key data from a retail company to devise effective retention strategies. By leveraging SQL queries, we will extract insights from various datasets to understand customer behavior, identify satisfaction drivers, and formulate actionable strategies.

2. Data Overview
The datasets available for analysis include:

	i.   Transaction Document: Records of transactions including order dates, employee IDs, customer IDs, product IDs, quantities, payment methods, and discounts.
	ii.  Return Table: Details of returned products, including reasons for returns and conditions of items.
	iii. Customer Document: Customer profiles with demographic information and contact details.
	iv.  Product Document: Product details such as categories, prices, and stock levels.
	v.   Store: Information on store locations, addresses, warehouse capacities, and major issues faced.
	vi.  Employee: Employee details including their roles and hire dates.

3. Create the tables & Transform the Order_Date to DATE Format

Ai. Starting with Transaction Table as Transaction_Doc'

CREATE TABLE Transaction_Doc(
				Serial_Number NUMERIC,
				Transaction_ID VARCHAR(100) PRIMARY KEY,
				Order_Date DATE,
				Employee_ID VARCHAR (100),
				Customer_ID VARCHAR(100),
				Product_ID VARCHAR(100),
				Quantity_Supplied NUMERIC,
				Payment_Method VARCHAR(50),
				Discount_Rate NUMERIC,
				Tax_Details NUMERIC,
				Refunds_and_Chargebacks VARCHAR(10)
							)
'ii. Import the dataset into the table' 

	COPY Transaction_Doc
	FROM 'C:\Users\USER\Desktop\Project 1\Transaction_Doc.csv'DELIMITER','
	
'iii. Inspect the table'

	SELECT *
	FROM Transaction_Doc


'Bi. Return Table as Return_Doc'

CREATE TABLE Return_Doc(
				Return_ID VARCHAR(100) PRIMARY KEY,
				Transaction_ID VARCHAR(100),
				Employee_ID VARCHAR(100),
				Return_Date DATE,
				Return_Status VARCHAR(100),
				Return_Type VARCHAR(50),
				Reason_for_the_return VARCHAR (1000),
				Condition_of_the_item VARCHAR(250),
				Customer_Feedback_on_Return_Process VARCHAR(1000)
							)
'ii. Import the dataset into the table' 

	COPY Return_Doc
	FROM 'C:\Users\USER\Desktop\Project 1\Return_Document.csv'DELIMITER','
	
'iii. Inspect the table'

	SELECT *
	FROM Return_Doc


'Ci. Customer Table as Customer_Doc'

CREATE TABLE Customer_Doc(
				Serial_No VARCHAR(50),
				Customer_ID VARCHAR(100) PRIMARY KEY,
				Employee_ID VARCHAR(100),
				Registration_Date DATE,
				Customer_Name VARCHAR(100),
				Age INT,
				Occupation VARCHAR (100),
				Gender VARCHAR(50),
				Location_within_US VARCHAR(100),
				Email_address VARCHAR(50),
				Phone_number VARCHAR(100),
				Social_Security_Number VARCHAR(100)
							)
'ii. Import the dataset into the table' 

	COPY Customer_Doc
	FROM 'C:\Users\USER\Desktop\Project 1\Customer_Doc.csv'DELIMITER','
	
'iii. Inspect the table'

	SELECT *
	FROM Customer_Doc



'Di. Product Table as Product_Doc'

CREATE TABLE Product_Doc(
				Product_ID VARCHAR(100) PRIMARY KEY,
				Product_Name VARCHAR(100),
				Category VARCHAR(100),
				Unit_Price NUMERIC,
				Stock_Levels NUMERIC,
				Supplier_Details VARCHAR(100),
				Product_Ratings NUMERIC,
				Store_ID VARCHAR(100)
							)
'ii. Import the dataset into the table' 

	COPY Product_Doc
	FROM 'C:\Users\USER\Desktop\Project 1\Product_Doc.csv'DELIMITER','
	
'iii. Inspect the table'

	SELECT *
	FROM Product_Doc



'Ei. Store Table as Store_Doc'

CREATE TABLE Store_Doc(
				Store_ID VARCHAR(100) PRIMARY KEY,
				Store_Location VARCHAR(100),
				Store_Address VARCHAR(500),
				Store_Keeper_Employee_ID VARCHAR(100),
				Warehouse_Capacity_sq_ft VARCHAR(50),
				Last_Major_Issue VARCHAR(500) 
							)
'ii. Import the dataset into the table' 

	COPY Store_Doc
	FROM 'C:\Users\USER\Desktop\Project 1\Store_Document.csv'DELIMITER','
	
'iii. Inspect the table'

	SELECT *
	FROM Store_Doc



'Fi. Employee Table as Employee_Doc'

CREATE TABLE Employee_Doc(
				Employee_ID VARCHAR(100) PRIMARY KEY,
				Full_Name VARCHAR(100),
				Department VARCHAR(50),
				Designation VARCHAR(50),
				Hire_Date DATE,
				Highest_Qualification VARCHAR(100)
							)
'ii. Import the dataset into the table' 

	COPY Employee_Doc
	FROM 'C:\Users\USER\Desktop\Project 1\Employee_Documents.csv'DELIMITER','
	
'iii. Inspect the table'

	SELECT *
	FROM Employee_Doc




'4. ANALYSIS AND INSIGHTS

Sales Timelines'

SELECT Order_Date, COUNT(Transaction_ID) AS Number_of_Purchases,ROUND(AVG(Quantity_Supplied),0) AS Average_Quantity_Purchase, ROUND(AVG(Discount_Rate),2) AS Average_Discount_given
FROM Transaction_Doc td
LEFT JOIN Customer_Doc cd
ON td.Customer_ID = cd.Customer_ID
GROUP BY Order_Date 
ORDER BY Order_Date ASC


'a. Customer Purchase Patterns
To understand customer purchase patterns, we can query the Transaction Document to analyze the frequency and volume of purchases. 
This helps identify loyal customers and those who might be at risk of churning.'

SELECT Customer_Name, COUNT(Transaction_ID) AS Number_of_Purchases,ROUND(AVG(Quantity_Supplied),0) AS Average_Quantity_Purchase, ROUND(AVG(Discount_Rate),2) AS Average_Discount_given
FROM Transaction_Doc td
LEFT JOIN Customer_Doc cd
ON td.Customer_ID = cd.Customer_ID
GROUP BY Customer_Name 
ORDER BY Number_of_Purchases DESC

'Additionally, to gain insight into the geographical distribution of customers in relation to their purchasing behavior'

SELECT cd.Location_Within_US, COUNT(td.Transaction_ID) AS Number_of_Purchases,SUM(td.Quantity_Supplied) AS Total_Quantity, ROUND(AVG(td.Discount_Rate),2) AS Average_Discount_given
FROM Transaction_Doc td
LEFT JOIN Customer_Doc cd
ON cd.Customer_ID = td.Customer_ID
GROUP BY cd.Location_Within_US
ORDER BY Number_of_Purchases DESC

'while also examining their age groups.'


SELECT b.Age_Group, SUM(b.Number_of_Purchases) AS Frequency_of_Transactions, ROUND(AVG(b.total_quantity),2) AS Total_Quantity_Purchase
FROM(
	SELECT
	CASE
	WHEN a.Age >= 18 AND a.Age<= 25 THEN '18 - 25'
	WHEN a.Age >= 26 AND a.Age<= 35 THEN '26 - 35'
	WHEN a.Age >= 36 AND a.Age<= 45 THEN '36 - 45'
	WHEN a.Age >= 46 AND a.Age<= 64 THEN '46 - 64'
	WHEN a.Age >= 65 AND a.Age<= 75 THEN '65 - 75'
	ELSE '75 & Above'
	END AS Age_Group,*
	FROM(
		SELECT cd.Age, COUNT(td.Transaction_ID) AS Number_of_Purchases,SUM(td.Quantity_Supplied) AS Total_Quantity, ROUND(AVG(td.Discount_Rate),2) AS Average_Discount_given
		FROM Transaction_Doc td
		LEFT JOIN Customer_Doc cd
		ON cd.Customer_ID = td.Customer_ID
		GROUP BY cd.Age
		ORDER BY cd.Age DESC
		) a
	ORDER BY a.Number_of_Purchases DESC
	) b
GROUP BY b.Age_Group
ORDER BY b.Age_Group DESC




'5. REASON FOR RETURNS
Analyzing return reasons from the Return Table helps identify common issues with products or services
that may affect customer satisfaction.'


SELECT Reason_for_the_return, COUNT(*) AS Number_of_Returns
FROM Return_Doc
GROUP BY Reason_for_the_return
ORDER BY Number_of_Returns DESC

'6.Product Performance
Evaluating product performance using data from the Transaction Document can help identify
top-performing products and those that need improvement.'

SELECT pd.Product_name, pd.Category, ROUND(AVG(pd.Product_Ratings),1) AS Average_Rating,COUNT(td.Product_ID) AS No_of_Purchases,SUM(td.Quantity_Supplied) AS Total_Quantity_Supplied, SUM(Stock_Levels) AS Stock_Level_Balance
FROM Transaction_Doc td
LEFT JOIN Product_Doc pd
ON td.Product_ID = pd.Product_ID
GROUP BY pd.Product_name, pd.Category
ORDER BY Average_Rating DESC, No_of_Purchases DESC


'7. Store Performance
Analyzing store performance based on the Store dataset helps identify locations with high sales
and customer satisfaction, and those that require attention.'


SELECT Store_Location, COUNT(Transaction_ID) AS Number_of_Transactions, SUM(Quantity_supplied) AS Total_Quantity
FROM Transaction_Doc td
LEFT JOIN Product_Doc pd
ON td.Product_ID = pd.Product_ID
LEFT JOIN Store_Doc sd
ON pd.Store_ID = sd.Store_ID
GROUP BY Store_Location
ORDER BY  Total_Quantity DESC


'8.  Strategy Formulation
Based on the analysis, the following strategies can be implemented to improve customer retention and acquisition:

Personalized Marketing: Utilize customer segmentation to create targeted marketing campaigns that cater to specific demographics and purchase behaviors.
Product Quality Improvement: Address common return reasons by improving product quality and ensuring accurate descriptions and images.
Loyalty Programs: Develop loyalty programs that reward frequent shoppers with discounts, exclusive offers, and early access to new products.
Customer Feedback Mechanisms: Implement robust feedback mechanisms to continuously gather customer opinions and make necessary improvements.
Employee Training: Enhance employee training programs to improve customer service and ensure a consistent shopping experience across all stores.
5. Conclusion
By analyzing key datasets using SQL, we can gain valuable insights into customer behavior and product performance.
These insights enable us to formulate effective retention strategies that enhance customer satisfaction and drive growth'





























































































































































































































