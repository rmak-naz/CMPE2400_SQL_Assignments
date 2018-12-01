-- Ronald Mak
-- CMPE 2400
-- ICA 7

-- Q1
declare @freight as int

set @freight = 800

SELECT	LastName as 'Last Name', 
		Title as 'Title'
FROM	Employees
WHERE	EmployeeID IN  (SELECT	EmployeeID
						FROM	Orders
						WHERE	Freight > @freight)
ORDER BY LastName ASC

-- Q2
SELECT	LastName as 'Last Name', 
		Title as 'Title'
FROM	Employees
WHERE	EXISTS  (SELECT	EmployeeID
				 FROM	Orders
				 WHERE	Freight > @freight AND
						Orders.EmployeeID = Employees.EmployeeID)
ORDER BY LastName ASC

-- Q3
SELECT	ProductName as 'Product Name',
		UnitPrice as 'Unit Price'
FROM	Products
WHERE	SupplierID in (SELECT	SupplierID
					   FROM		Suppliers
					   WHERE	Country = 'Sweden') 
	OR  SupplierID in (SELECT	SupplierID
					   FROM		Suppliers
					   WHERE	Country = 'Italy')
ORDER BY UnitPrice ASC

-- Q4
SELECT	ProductName as 'Product Name',
		UnitPrice as 'Unit Price'
FROM	Products
WHERE	EXISTS (SELECT	SupplierID
				FROM	Suppliers
				WHERE	Products.SupplierID = Suppliers.SupplierID AND
						Country = 'Sweden') 
	OR  EXISTS (SELECT	SupplierID
				FROM	Suppliers
				WHERE	Products.SupplierID = Suppliers.SupplierID AND
						Country = 'Italy')
ORDER BY UnitPrice ASC

-- Q5
declare @Price as int
set @Price = 20

SELECT	ProductName as 'Product Name'
FROM	Products
WHERE	CategoryID in (SELECT	CategoryID
					   FROM		Categories
					   WHERE	(CategoryName = 'Confections' OR
								CategoryName = 'Seafood') AND
								UnitPrice > @Price)
ORDER BY CategoryID ASC, ProductName ASC

-- Q6
SELECT	ProductName as 'Product Name'
FROM	Products
WHERE	EXISTS (SELECT	CategoryID
				FROM	Categories
				WHERE	Products.CategoryID = Categories.CategoryID AND
						((CategoryName = 'Confections' OR
						CategoryName = 'Seafood') AND
						UnitPrice > @Price))
ORDER BY CategoryID ASC, ProductName ASC

-- Q7
declare @OrderCost as int

set @OrderCost = 15

SELECT	CompanyName as 'Company Name',
		Country as 'Country'
FROM	Customers
WHERE	CustomerID in (SELECT	CustomerID
					   FROM		Orders
					   WHERE	OrderID in (SELECT	OrderID
											 FROM	[Order Details]
											 WHERE	UnitPrice * Quantity < @OrderCost))
ORDER BY Country ASC

-- Q8
SELECT	CompanyName as 'Company Name',
		Country as 'Country'
FROM	Customers
WHERE	EXISTS (SELECT	CustomerID
				FROM	Orders
				WHERE	Customers.CustomerID = Orders.CustomerID AND 
						EXISTS (SELECT	OrderID
								FROM	[Order Details]
								WHERE	Orders.OrderID = [Order Details].OrderID AND
										UnitPrice * Quantity < @OrderCost))
ORDER BY Country ASC

-- Q9
declare @ReqDays as int
set @ReqDays = 7

SELECT	ProductName as 'Product Name'
FROM	Products
WHERE	ProductID in (SELECT	Distinct ProductID
					  FROM		[Order Details]
					  WHERE		OrderID in (SELECT	OrderID
										    FROM	Orders
											WHERE	DateDiff(DAY,ShippedDate,RequiredDate) > @ReqDays))
	AND ProductID in (SELECT	Distinct ProductID
					  FROM		[Order Details]
					  WHERE		OrderID in (SELECT OrderID FROM Orders WHERE CustomerID in
										   (SELECT CustomerID
											FROM	Customers
										   WHERE	Country = 'UK' OR Country = 'USA')))

ORDER BY ProductName ASC

-- Q10
SELECT	OrderID as 'Order ID',
		ShipCity as 'Ship City'
FROM	Orders
WHERE	ShipCity in (SELECT	DISTINCT City
					 FROM	Suppliers
					 WHERE  Orders.ShipCity = City)