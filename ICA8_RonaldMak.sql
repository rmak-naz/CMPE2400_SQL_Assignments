-- Ronald Mak
-- CMPE 2400
-- ICA 8

-- Q1
SELECT	top 1 CompanyName as 'Supplier Company Name',
		Country as 'Country'
FROM	Suppliers
ORDER BY Country ASC

-- Q2
SELECT	top 1 with ties CompanyName as 'Supplier Company Name',
		Country as 'Country'
FROM	Suppliers
ORDER BY Country ASC

-- Q3
SELECT	Top 10 percent ProductName as 'Product Name',
		UnitsInStock as 'Units in Stock'
FROM	Products
ORDER BY UnitsInStock DESC

-- Q4
SELECT	CompanyName as 'Company Name',
		Country as 'Country'
FROM	Customers
WHERE	CustomerID in (SELECT	Top 8 CustomerID
						FROM	Orders
						Order by Freight DESC)

-- Q5
SELECT	CustomerID as 'Customer ID',
		OrderID as 'Order ID',
		CAST(OrderDate as (varchar(11) ) as 'Order Date'
FROM	Orders
WHERE	OrderID in (SELECT	Top 3 OrderID
						FROM	[Order Details]
						Order By Quantity DESC)