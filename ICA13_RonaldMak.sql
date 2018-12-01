-- Ronald Mak
-- CMPE 2400
-- ICA 13 Stored Procedures

-- Q1 (ICA11 Q1)
if exists
	(
		select 	[name]
		from 	sysobjects
		where 	[name] = 'ica13_01'
	)
drop procedure ica13_01
go


create proc ica13_01
as
SELECT	LastName + ', ' + FirstName as 'Name',
		count(OrderID) as 'Num Orders'
FROM	NorthwindTraders.dbo.Employees INNER JOIN NorthwindTraders.dbo.Orders
		ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, LastName, FirstName
ORDER BY [Num Orders] DESC
GO

execute ica13_01

-- Q2 (ICA11 Q6)
if exists
	(
		select 	[name]
		from 	sysobjects
		where 	[name] = 'ica13_02'
	)
drop procedure ica13_02
go

create proc ica13_02
as
SELECT	LastName + ', ' + FirstName as 'Name',
		CONVERT(money,sum(Quantity * UnitPrice)) as 'Sales Total',
		count(ProductID) as 'Detail Items'
FROM	NorthwindTraders.dbo.Employees LEFT OUTER JOIN NorthwindTraders.dbo.Orders
		ON Employees.EmployeeID = Orders.EmployeeID LEFT OUTER JOIN NorthwindTraders.dbo.[Order Details]
			ON Orders.OrderID = [Order Details].OrderID
GROUP BY LastName, FirstName
ORDER BY [Sales Total] DESC
GO

execute ica13_02

-- Q3 (ICA7 Q7)
if exists
	(
		select 	[name]
		from 	sysobjects
		where 	[name] = 'ica13_03'
	)
drop procedure ica13_03
go

create proc ica13_03
	@maxPrice money = null
as
SELECT	CompanyName as 'Company Name',
		Country as 'Country'
FROM	NorthwindTraders.dbo.Customers
WHERE	CustomerID in (SELECT	CustomerID
					   FROM		NorthwindTraders.dbo.Orders
					   WHERE	OrderID in (SELECT	OrderID
											 FROM	NorthwindTraders.dbo.[Order Details]
											 WHERE	UnitPrice * Quantity < @maxPrice))
ORDER BY Country ASC
GO

execute ica13_03 15

-- Q4 (ICA7 Q6)
if exists
	(
		select 	[name]
		from 	sysobjects
		where 	[name] = 'ica13_04'
	)
drop procedure ica13_04
go

create proc ica13_04
	@minPrice money = null,
	@categoryName nvarchar(15) = ''
as
SELECT	ProductName as 'Product Name'
FROM	NorthwindTraders.dbo.Products
WHERE	EXISTS (SELECT	CategoryID
				FROM	NorthwindTraders.dbo.Categories
				WHERE	Products.CategoryID = Categories.CategoryID AND
						((CategoryName = @categoryName) AND
						UnitPrice > @minPrice))
ORDER BY CategoryID ASC, ProductName ASC
GO

execute ica13_04 20, 'Confections'

-- Q5 (ICA11 Q4)
if exists
	(
		select 	[name]
		from 	sysobjects
		where 	[name] = 'ica13_05'
	)
drop procedure ica13_05
go

create proc ica13_05
	@minPrice money = null,
	@country nvarchar(15) = 'USA'
as
SELECT	CompanyName as 'Supplier',
		Country as 'Country',
		ISNULL(min(UnitPrice),0) as 'Min Price',
		ISNULL(max(UnitPrice),0) as 'Max Price'
FROM	NorthwindTraders.dbo.Suppliers LEFT OUTER JOIN NorthwindTraders.dbo.Products
		ON Suppliers.SupplierID = Products.SupplierID
WHERE	Country = @country
GROUP BY CompanyName, Country
	HAVING ISNULL(min(UnitPrice),0) > @minPrice
ORDER BY [Min Price]	
GO

execute ica13_05 15
execute ica13_05 @minPrice = 15
execute ica13_05 @minPrice = 5, @country = 'UK'

-- Q6 (ICA12 Q1)
if exists
	(
		select 	[name]
		from 	sysobjects
		where 	[name] = 'ica13_06'
	)
drop procedure ica13_06
go

create proc ica13_06
	@class_id int = 0
as
SELECT	ass_type_desc as 'Type',
		Round(avg(score),2) as 'Raw Avg',
		Round(avg(score / max_score) * 100,2) as 'Avg',
		count(score) as 'Num'
FROM	ClassTrak.dbo.Assignment_type LEFT OUTER JOIN ClassTrak.dbo.Requirements
		ON Assignment_type.ass_type_id = Requirements.ass_type_id LEFT OUTER JOIN ClassTrak.dbo.Results
			ON Requirements.req_id = Results.req_id
WHERE	Results.class_id = @class_id
GROUP BY ass_type_desc
GO

execute ica13_06 88
execute ica13_06 @class_id = 89

-- Q7 (ICA12 Q5)
if exists
	(
		select 	[name]
		from 	sysobjects
		where 	[name] = 'ica13_07'
	)
drop procedure ica13_07
go

create proc ica13_07
	@year int,
	@minAvg int = 50,
	@minSize int = 10
as
SELECT	last_name + ', ' + first_name as 'Student',
		class_desc as 'Class',
		ass_type_desc as 'Type',
		count(score) as 'Submitted',
		Round(avg(score / max_score) * 100,1) as 'Avg'
FROM	ClassTrak.dbo.Students LEFT OUTER JOIN ClassTrak.dbo.Results
		ON	students.student_id = Results.student_id LEFT OUTER JOIN ClassTrak.dbo.Classes
			ON	Results.class_id = Classes.class_id LEFT OUTER JOIN ClassTrak.dbo.Requirements
				ON Results.Req_id = Requirements.Req_id LEFT OUTER JOIN ClassTrak.dbo.Assignment_type
					ON Requirements.ass_type_id = Assignment_type.ass_type_id
WHERE	Datepart(year,Classes.start_date) = @year AND score IS NOT NULL
GROUP BY last_name, first_name, class_desc, ass_type_desc
	HAVING	avg(score / max_score) * 100 < @minAvg
		AND count(score) > @minSize
ORDER BY [Student]
GO

execute ica13_07 @year=2011
execute ica13_07 @year=2011, @minAvg=40, @minSize=15