-- Ronald Mak
-- CMPE 2400
-- ICA 5 - Select

-- Q1
Select * from customers

-- Q2
Select	CustomerID as 'Customer ID', 
		CompanyName as 'Company Name', 
		ContactName as 'Contact Name', 
		City as 'City' 
from Customers

-- Q3
Select	OrderID as 'Order ID', 
		ShipName as 'Ship Name', 
		OrderDate as 'Order Date', 
		ShipRegion as 'Ship Region' 
from Orders 
WHERE ShipRegion is NOT NULL AND ShippedDate is NULL

-- Q4
declare @unitOrder as int
declare @unitStock as int

set @unitOrder = 11
set @unitStock = 10

Select	ProductName as 'Product Name', 
		UnitPrice as 'Unit Price', 
		UnitsInStock as 'Units in Stock'
from Products
Where UnitsOnOrder < @unitOrder AND UnitsInStock < @unitStock

-- Q5
Select	CompanyName as 'Company Name', 
		City as 'City', 
		CAST(Address as nvarchar(20)) as 'Address'
from Customers
WHERE	Country in ('Brazil', 'Colombia', 'Argentina', 'Peru', 'Venezuela', 'Chile', 'Ecuador', 'Paraguay', 'Uruguay', 'Guyana', 'Suriname', 'French Guiana') AND
		ContactTitle in ('Owner', 'Sales Agent')

-- Q6
Select	ProductName as 'Product Name', 
		QuantityPerUnit as 'Quantity Per Unit', 
		UnitPrice as 'Unit Price'
From Products
WHERE	(QuantityPerUnit LIKE '%jars%' OR QuantityPerUnit LIKE '%bottles%') AND
		(CategoryID <> 1 AND CategoryID <> 8)
		
-- Q7
Select	ProductName as 'Product Name', 
		UnitPrice as 'Unit Price', 
		UnitsInStock as 'Units in Stock', 
		UnitPrice * UnitsInStock as 'Inventory Value'
from Products
WHERE UnitPrice * UnitsInStock < 100 AND Discontinued = 0