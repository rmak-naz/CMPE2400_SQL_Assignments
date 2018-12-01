-- ICA3 Control Flow / Looping
-- Ronald Mak
-- CMPE 2400

-- Q1
declare @randNum as int
declare @factor3 as varchar(3)

set @randNum = CONVERT(int, rand() * 100)
IF @randNum % 3 = 0
	set @factor3 = 'Yes'
ELSE
	set @factor3 = 'No'

Select	@randNum as 'Random',
		@factor3 as 'Factor of 3'
go

-- Q2
declare @randNum as int
declare @ballpark as nvarchar(15)

set @randNum = CONVERT(int, rand() * 60)

/*
IF @randNum < 15
	set @ballpark = 'on the hour'	
ELSE IF @randNum < 30
	set @ballpark = 'quarter past'
ELSE IF @randNum < 45
	set @ballpark = 'half past'
ELSE
	set @ballpark = 'quarter to'
	
select	@randNum as 'Minutes',
		@ballpark as 'Ballpark'
go
*/

SELECT	@randNum as 'Minutes',
		CASE 
			WHEN @randNum < 15 OR @randNum = 60 THEN 'On the hour'
			WHEN @randNum < 30 THEN 'Quarter past'
			WHEN @randNum < 45 THEN 'Half past'
			ELSE 'Quarter To'
		END as 'Ballpark'
GO

-- Q3
declare @randNum as int
declare @day as nvarchar(10)
declare @nextWeek as datetime

set @randNum = CONVERT(int, rand() * 6)
set @nextWeek = dateadd(day,@randNum,getdate())

SELECT @randNum as 'Add Days Number', datepart(WEEKDAY, @nextWeek) as 'Weekday',

	CASE 
		WHEN CONVERT(int,datepart(WEEKDAY, @nextWeek)) = 1 THEN 'Yahoo: Sunday'
		WHEN CONVERT(int,datepart(WEEKDAY, @nextWeek)) = 2 THEN 'Got class: Monday'
		WHEN CONVERT(int,datepart(WEEKDAY, @nextWeek)) = 3 THEN 'Got class: Tuesday'
		WHEN CONVERT(int,datepart(WEEKDAY, @nextWeek)) = 4 THEN 'Got class: Wednesday'
		WHEN CONVERT(int,datepart(WEEKDAY, @nextWeek)) = 5 THEN 'Got class: Thursday'
		WHEN CONVERT(int,datepart(WEEKDAY, @nextWeek)) = 6 THEN 'God class: Friday'
		WHEN CONVERT(int,datepart(WEEKDAY, @nextWeek)) = 7 THEN 'Yahoo: Saturday'
	END as 'Status'
GO

-- Q4
declare @iterate as int
declare @randNum as int
declare @iterate_begin as int
declare @factor2 as int
declare @factor3 as int
declare @factor5 as int

set @iterate = rand() * 10000
set @iterate_begin = @iterate
set @factor2 = 0
set @factor3 = 0
set @factor5 = 0

while (@iterate > 0)
	begin
		set @randNum = rand() * 10
		if (@randNum % 5 = 0)
			set @factor5 += 1
		if (@randNum % 3 = 0)
			set @factor3 += 1
		if (@randNum % 2 = 0)
			set @factor2 += 1
		set @iterate -= 1
	end

select	@iterate_begin as 'Iterate',
		@factor2 as 'Factor 2',
		@factor3 as 'Factor 3',
		@factor5 as 'Factor 5'
go

-- Q5
declare @randX as float
declare @randY as float
declare @guessCount as int
declare @pi as float
declare @pi_est as float
declare @inbound as int
declare @distance as float


set @inbound = 0
set @guessCount = 0
set @pi = round(PI(), 9,1)
set @pi_est = 0

while (@pi_est <= (@pi - 0.0002) OR @pi_est >= (@pi + 0.0002))
	begin
		set @guessCount += 1
		set @randX = rand() * 100
		set @randY = rand() * 100
		set @distance = sqrt((power(@randX, 2) + power(@randY, 2)))

		if (@distance <= 100)
			set @inbound += 1
		set @pi_est = round(4 * CONVERT(float,@inbound) / CONVERT(float,@guessCount),9, 1)
	end

select	@pi_est as 'Estimate',
		@pi as 'PI',
		@inbound as 'In',
		@guessCount as 'Tries'
GO






