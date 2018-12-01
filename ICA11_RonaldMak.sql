-- Ronald Mak
-- CMPE 2400
-- ICA 11: Aggregates and Aggravation

-- Q1
SELECT	LastName + ', ' + FirstName as 'Name',
		count(OrderID) as 'Num Orders'
FROM	Employees INNER JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, LastName, FirstName
ORDER BY [Num Orders] DESC

-- Q2
SELECT	LastName + ', ' + FirstName as 'Name',
		avg(Freight) as 'Average Freight',
		CONVERT(nvarchar(11),max(OrderDate),106) as 'Newest Order Date'
FROM	Employees INNER JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, LastName, FirstName
ORDER BY [Newest Order Date]

-- Q3
SELECT	CompanyName as 'Supplier',
		Country as 'Country',
		count(ProductID) as 'Num Products',
		avg(UnitPrice) as 'Avg Price'
FROM	Suppliers LEFT OUTER JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
WHERE	CompanyName LIKE '[HURT]%'
GROUP BY Suppliers.SupplierID, CompanyName, Country
ORDER BY [Num Products]

-- Q4
SELECT	CompanyName as 'Supplier',
		Country as 'Country',
		ISNULL(min(UnitPrice),0) as 'Min Price',
		ISNULL(max(UnitPrice),0) as 'Max Price'
FROM	Suppliers LEFT OUTER JOIN Products
		ON Suppliers.SupplierID = Products.SupplierID
WHERE	Country = 'USA'
GROUP BY CompanyName, Country
ORDER BY [Min Price]		

-- Q5
SELECT	CompanyName as 'Customer',
		City as 'City',
		CONVERT(nvarchar(11),OrderDate,106) as 'Order Date',
		count(ProductID) as 'Products in Order'
FROM	Customers LEFT OUTER JOIN Orders
		ON Customers.CustomerID = Orders.CustomerID LEFT OUTER JOIN [Order Details]
			ON Orders.OrderID = [Order Details].OrderID
WHERE	Country = 'Poland' OR City = 'Walla Walla'
GROUP BY CompanyName, City, OrderDate
ORDER BY [Products in Order]

-- Q6 (Question asks to sort by detail items, results picture sorts by sales total)
SELECT	LastName + ', ' + FirstName as 'Name',
		CONVERT(money,sum(Quantity * UnitPrice)) as 'Sales Total',
		count(ProductID) as 'Detail Items'
FROM	Employees LEFT OUTER JOIN Orders
		ON Employees.EmployeeID = Orders.EmployeeID LEFT OUTER JOIN [Order Details]
			ON Orders.OrderID = [Order Details].OrderID
GROUP BY LastName, FirstName
--ORDER BY [Detail Items] DESC
ORDER BY [Sales Total] DESC