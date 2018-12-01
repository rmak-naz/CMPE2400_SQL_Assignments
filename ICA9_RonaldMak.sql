-- Ronald Mak
-- CMPE 2400
-- ICA 9 Inner Joins

-- Q1
declare @country as varchar(10)
set @country = 'USA'

SELECT	CompanyName as 'Company Name',
		ProductName as 'Product Name',
		UnitPrice as 'Unit Price'
FROM	Suppliers INNER JOIN Products
ON		Suppliers.SupplierID = Products.SupplierID
WHERE	Suppliers.Country = @country
ORDER BY	CompanyName, ProductName

-- Q2
declare @lastName as varchar(10)
set @lastName = '%ul%'

SELECT	LastName + ', ' + FirstName as 'Name', 
		TerritoryDescription as 'Territory Description'
FROM	Employees INNER JOIN EmployeeTerritories
ON		Employees.EmployeeID = EmployeeTerritories.EmployeeID
		INNER JOIN	Territories
		ON	Territories.TerritoryID = EmployeeTerritories.TerritoryID
WHERE	Employees.LastName LIKE '%ul%'
ORDER BY TerritoryDescription

-- Q3
set @country = 'Sweden'

SELECT	DISTINCT Customers.CustomerID as 'Customer ID',
		ProductName as 'Product Name'
FROM	Customers INNER JOIN Orders
ON		Customers.CustomerID = Orders.CustomerID
		INNER JOIN	[Order Details]
		ON	[Order Details].OrderID = Orders.OrderID
			INNER JOIN Products
			ON	Products.ProductID = [Order Details].ProductID
WHERE	Country = @country AND ProductName LIKE '[U-Z]%'
ORDER BY ProductName

-- Q4
declare @sellPrice as money
set @sellPrice = 69

SELECT	DISTINCT CategoryName as 'Category Name',
		Products.UnitPrice as 'Product Price',
		[Order Details].UnitPrice as 'Selling Price'
FROM	Categories INNER JOIN Products
		ON Categories.CategoryID = Products.CategoryID
		INNER JOIN [Order Details]
			ON [Order Details].ProductID = Products.ProductID
WHERE	Products.UnitPrice <> [Order Details].UnitPrice
	AND [Order Details].UnitPrice > @sellPrice
ORDER BY [Selling Price]

-- Q5
declare @reqDate as int
set @reqDate = 34

SELECT	ShipName as 'Shipper',
		ProductName as 'ProductName'
FROM	Orders INNER JOIN [Order Details]
		ON	Orders.OrderID = [Order Details].OrderID
		INNER JOIN Products
			ON Products.ProductID = [Order Details].ProductID
WHERE	Discontinued = 1 AND DateDiff(DAY,RequiredDate,ShippedDate) > 34