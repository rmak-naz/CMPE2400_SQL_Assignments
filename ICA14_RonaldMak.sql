-- Ronald Mak
-- CMPE 2400
-- ICA 14 - Stored Procedures

if exists
    (
        select  [name]
        from    sysobjects
        where   [name] in ('ica14_01', 'ica14_02', 'ica14_03','ica14_04', 'ica14_05')
    )
drop procedure ica14_01, ica14_02, ica14_03,ica14_04, ica14_05
go

-- Q1 (ICA10 Q4)
create proc ica14_01
	@category nvarchar(15),
	@prodName nvarchar(40) output,
	@quantity int output
as

SELECT 	Top 1 @prodName = ProductName,
        @quantity = Quantity 
FROM    NorthwindTraders.dbo.Products LEFT OUTER JOIN NorthwindTraders.dbo.Categories
		ON	Products.CategoryID = Categories.CategoryID LEFT OUTER JOIN NorthwindTraders.dbo.[Order Details]
			ON  Products.ProductID = [Order Details].ProductID  
WHERE	CategoryName = @category
ORDER BY Quantity DESC
GO

declare @prodName nvarchar(40)
declare @quantity int
declare @category nvarchar(15) = 'Beverages'

exec ica14_01 @category, @prodName output, @quantity output

SELECT	@category as 'Category', 
		@prodName as 'ProductName', 
		@quantity as 'Highest Quantity'

set @category = 'Confections'

exec ica14_01 @category, @prodName output, @quantity output
SELECT	@category as 'Category', 
		@prodName as 'ProductName', 
		@quantity as 'Highest Quantity'
GO

-- Q2 (ICA11 Q2)
create proc ica14_02
	@year int,
	@avgFreight money output,
	@name nvarchar(20) output
as
SELECT  Top 1 @name = LastName + ', ' + FirstName,
        @avgFreight = avg(Freight)
FROM    NorthwindTraders.dbo.Employees INNER JOIN NorthwindTraders.dbo.Orders
        ON Employees.EmployeeID = Orders.EmployeeID
WHERE	DatePart(year, OrderDate) = @year
GROUP BY Employees.EmployeeID, LastName, FirstName
ORDER BY avg(Freight) DESC
GO

declare @year int = 1996
declare @avgFreight money
declare @name nvarchar(20)

exec ica14_02 @year, @avgFreight output, @name output
SELECT	@year as 'Year',
		@name as 'Name',
		@avgFreight as 'Biggest Avg Freight'

set @year = 1997
exec ica14_02 @year, @avgFreight output, @name output
SELECT	@year as 'Year',
		@name as 'Name',
		@avgFreight as 'Biggest Avg Freight'
GO

-- Q3 (ICA12 Q3)
create proc ica14_03
	@classID int,
	@asstype varchar(15) = 'all'
as
if (@asstype = 'fe')
	set @asstype = 'Final'
else if (@asstype = 'ica')
	set @asstype = 'Assignment'
else if (@asstype = 'lab')
	set @asstype = 'Lab'
else if (@asstype = 'le')
	set @asstype = 'Lab Exam'
else
	set @asstype = '%'	

SELECT	last_name as 'Last',
		ass_type_desc as 'ass_type_desc',
		Round(min(score / max_score) * 100,1) as 'Low', 
		Round(max(score / max_score) * 100,1) as 'High', 
		Round(avg(score / max_score) * 100,1) as 'Avg'
into	#temptable
FROM	ClassTrak.dbo.Students LEFT OUTER JOIN ClassTrak.dbo.Results
		ON	Students.student_id = Results.student_id LEFT OUTER JOIN ClassTrak.dbo.Requirements
			ON Results.req_id = Requirements.req_id LEFT OUTER JOIN ClassTrak.dbo.Assignment_type
				ON Requirements.ass_type_id = Assignment_type.ass_type_id
WHERE	Results.class_id = @classID
GROUP BY last_name, ass_type_desc

SELECT	Last, ass_type_desc, Low, High, Avg
FROM	#temptable
WHERE   ass_type_desc = @asstype
ORDER BY Avg DESC
GO

declare @cid as int

set @cid = 123
exec ica14_03 @cid, 'ica'

set @cid = 123
exec ica14_03 @cid, 'le'
GO

-- Q4
create proc ica14_04
	@student nvarchar(15),
	@summary int = 0
as
declare @studID as int

SELECT	@studID = student_id
FROM	ClassTrak.dbo.Students
WHERE	first_name = @student

IF (@@ROWCOUNT = 1)
	(SELECT	first_name + ' ' + last_name as 'Name',
			class_desc as 'Class_desc',
			ass_type_id as 'ass_type_id',
			Round(avg(score / max_score * 100),1) as 'Avg'
	INTO	#Q4table
	FROM	ClassTrak.dbo.Students LEFT OUTER JOIN ClassTrak.dbo.Results
			ON	Students.student_id = Results.student_id LEFT OUTER JOIN ClassTrak.dbo.Classes
				ON Results.class_id = Classes.class_id LEFT OUTER JOIN ClassTrak.dbo.Requirements
					ON Classes.class_id = Requirements.class_id	
	WHERE	Students.student_id = @studID
	GROUP BY first_name, last_name, class_desc, ass_type_id)
ELSE
	return -1;

IF (@summary = 0)
	SELECT	Name, Class_desc, ass_type_id, Avg FROM #Q4table
ELSE
	SELECT  Name, Class_desc, avg(Avg) FROM #Q4table
	GROUP BY Name, Class_desc
return 1


GO

declare @retVal as int
exec @retVal = ica14_04 @student = 'Ron'
select @retVal

exec @retVal = ica14_04 @student = 'Ron', @summary = 1
select @retVal
GO

-- Q5 
create proc ica14_05
	@lastName varchar(15)
as
declare @instID as int
declare @fullName as varchar(20)

SELECT	@instID = instructor_id,
		@fullName = first_name + ' ' + last_name
FROM	ClassTrak.dbo.Instructors
WHERE	last_name LIKE '%'+@lastName+'%'

IF (@@ROWCOUNT = 1)
	BEGIN
		SELECT	@fullName as 'Instructor',
				count(distinct Classes.class_id) as 'Num Classes',
				count(distinct student_id) as 'Total Students',
				count(score) as 'Total Graded',
				avg(score/max_score * 100) as 'Avg Awarded'
		FROM	ClassTrak.dbo.Instructors INNER JOIN ClassTrak.dbo.Classes
				ON	Instructors.instructor_id = Classes.instructor_id LEFT OUTER JOIN ClassTrak.dbo.Results
					ON Classes.class_id = Results.class_id LEFT OUTER JOIN ClassTrak.dbo.Requirements
						ON Results.req_id = Requirements.req_id
		WHERE	Instructors.instructor_id = @instID
		GROUP BY first_name, last_name
	END
ELSE
	return -1;
return 1;

GO

declare @retVal as int
exec @retVal = ica14_05 'Cas'
GO			

