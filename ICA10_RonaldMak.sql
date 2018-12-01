-- Ronald Mak
-- CMPE 2400
-- ICA 10 - Outer Joins

-- Q1
SELECT	CompanyName as 'Company Name',
		ProductName as 'Product Name',
		UnitPrice as 'Unit Price'
FROM	Suppliers LEFT OUTER JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
ORDER BY CompanyName

-- Q2
SELECT	CompanyName as 'Company Name',
		ProductName as 'Product Name',
		UnitPrice as 'Unit Price'
FROM	Suppliers LEFT OUTER JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
WHERE	ProductName IS NULL
ORDER BY CompanyName

-- Q3
SELECT	LastName + ', ' + FirstName as 'Name',
		OrderDate as 'Order Date'
FROM	Employees LEFT OUTER JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID
WHERE	OrderDate IS NULL

-- Q4
SELECT	Top 5 ProductName as 'Product Name',
		Quantity as 'Quantity'
FROM	Products LEFT OUTER JOIN [Order Details]
		ON	Products.ProductID = [Order Details].ProductID
ORDER BY Quantity ASC

-- Q5
SELECT TOP 10	CompanyName as 'Company',
		ProductName as 'Product',
		Quantity as 'Quantity'
FROM	Suppliers LEFT OUTER JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
			LEFT OUTER JOIN [Order Details]
				ON [Order Details].ProductID = Products.ProductID
ORDER BY Quantity ASC

-- Q6
SELECT	CompanyName as 'Customer/Supplier with Nothing'
FROM	Customers LEFT OUTER JOIN Orders
		ON Customers.CustomerID = Orders.CustomerID
WHERE	Orders.CustomerID IS NULL
UNION
SELECT	CompanyName as 'Customer/Supplier with Nothing'
FROM	Suppliers LEFT OUTER JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
WHERE	Products.ProductID IS NULL
ORDER BY CompanyName

-- Q7
SELECT	'Customer' as 'Type',
		CompanyName as 'Customer/Supplier with Nothing'		
FROM	Customers LEFT OUTER JOIN Orders
		ON Customers.CustomerID = Orders.CustomerID
WHERE	Orders.CustomerID IS NULL
UNION
SELECT	'Supplier' as 'Type',
		CompanyName as 'Customer/Supplier with Nothing'		
FROM	Suppliers LEFT OUTER JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
WHERE	Products.ProductID IS NULL
ORDER BY Type, [Customer/Supplier with Nothing] DESC