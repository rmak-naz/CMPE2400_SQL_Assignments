-- Ronald Mak
-- CMPE 2400
-- ICA 06

-- Q1
declare @lowPrice as smallmoney
declare @highPrice as smallmoney

set @lowPrice = 17.45
set @highPrice = 19.45

Select	ProductName as 'ProductName',
		UnitPrice as 'Unit Price'
FROM	Products
WHERE	UnitPrice BETWEEN @lowPrice AND @highPrice

-- Q2
declare @lowReorder as int
declare @highReorder as int

set @lowReorder = 1150
set @highReorder = 5000

SELECT	ProductName as 'ProductName',
		UnitPrice as 'Unit Price',
		ReorderLevel as 'Reorder Level',
		ReorderLevel * UnitPrice as 'Reorder Cost'
FROM Products
WHERE ReorderLevel * UnitPrice BETWEEN @lowReorder AND @highReorder
ORDER BY (ReorderLevel * UnitPrice) asc

-- Q3
declare @likeString as varchar(50)

set @likeString = '%ade%'

SELECT	ProductName as 'ProductName',
		QuantityPerUnit as 'Quantity Per Unit'
FROM Products
WHERE ProductName LIKE @likeString
ORDER BY ProductName asc

-- Q4
declare @discountVal as int

set @discountVal = 1375

SELECT	UnitPrice as 'Unit Price',
		Quantity as 'Quantity',
		Discount as 'Discount',
		(UnitPrice * Quantity * Discount) as 'Discount Value'
FROM [Order Details]
WHERE (UnitPrice * Quantity * Discount) >= @discountVal
ORDER BY (UnitPrice * Quantity * Discount) desc 

-- Q5
SELECT	Country as 'Country',
		City as 'City',
		CompanyName as 'Company Name'
FROM Customers
WHERE Phone LIKE '([159]__)%'
ORDER BY Country ASC

-- Q6
SELECT	CustomerID as 'Customer ID',
		OrderID as 'Order ID',
		DATEDIFF(day, RequiredDate, ShippedDate) as 'Delay Days'
FROM Orders
WHERE	DATEDIFF(day, RequiredDate, ShippedDate) > 7 AND
		CUSTOMERID NOT LIKE '[M-Z]%'
ORDER BY DATEDIFF(day, RequiredDate, ShippedDate) ASC

-- Q7
SELECT	CompanyName as 'Company Name',
		City as 'City',
		PostalCode as 'Postal Code'
FROM	Customers
WHERE	(PostalCode LIKE '[A-Z][1-9][A-Z] [1-9][A-Z][1-9]' OR
		PostalCode LIKE '[A-Z][A-Z][1-9][A-Z] [1-9][A-Z][A-Z]' OR
		PostalCode LIKE '[A-Z][A-Z][1-9] [1-9][A-Z][A-Z]' OR
		PostalCode LIKE '[A-Z][1-9][A-Z] [1-9][A-Z][A-Z]' OR
		PostalCode LIKE '[A-Z][1-9] [1-9][A-Z][A-Z]' OR
		PostalCode LIKE '[A-Z][1-9][1-9] [1-9][A-Z][A-Z]' OR
		PostalCode LIKE '[A-Z][A-Z][1-9][1-9] [1-9][A-Z][A-Z]') AND
		CompanyName NOT LIKE '%s'
ORDER BY City ASC

-- Q8
SELECT	distinct Discount as 'Discount'
FROM	[Order Details]

-- Q9
declare @maxVal as int

set @maxVal = 20

SELECT	distinct ProductID as 'Product ID',
		Round((UnitPrice - (UnitPrice * Discount)) * Quantity, 0) as 'Value'
FROM	[Order Details]
WHERE	Round((UnitPrice - (UnitPrice * Discount)) * Quantity, 0) < @maxVal AND
		(UnitPrice - (UnitPrice * Discount)) * Quantity / Round((UnitPrice - (UnitPrice * Discount)) * Quantity, 0) = 1
ORDER BY Value DESC, ProductID DESC
