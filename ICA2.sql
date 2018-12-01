-- ICA2 Ronald Mak

-- Q1
declare @halloweenDate as datetime
set @halloweenDate = '2016-10-31'

Select	DATEDIFF(day, getdate(), @halloweenDate) as 'Days Away',
		CONVERT(nvarchar(20), @halloweenDate, 102) as 'Date of Halloween 2016'
go

-- Q2
declare @todayDate as datetime
declare @futureDate as datetime
set @todayDate = getdate()
set @futureDate = dateadd(minute, 1000000, @todayDate)

Select	CAST(datename(month, @todayDate) as nvarchar(10)) + ' ' + 
		CAST(datepart(day, @todayDate) as nvarchar(2)) + ' ' + 
		CONVERT(nvarchar(4), datepart(year, @todayDate)) as 'Today', 
		CONVERT(nvarchar(20), @futureDate, 20) as 'Future'
go

-- Q3
declare @rcvdpct as float
declare @intPackRec as float
declare @intPackSent as float

set @intPackRec = CONVERT(float,@@PACK_RECEIVED)
set @intPackSent = CONVERT(float,@@PACK_SENT)
set @rcvdpct = @intPackRec / @intPackSent * 100

Select	CAST(@@LANGUAGE as nvarchar(12)) as 'Lang', 
		CAST(@@SERVERNAME as nvarchar(12)) as 'Server', 
		@@PACK_RECEIVED as 'Received',
		@@PACK_SENT as 'Sent',
		CAST(@rcvdpct as int) as 'Rcvd %'
go

-- Q4
declare @todayWeek as nvarchar(24)
declare @todayDay as nvarchar(2)

set @todayWeek = dateName(WEEKDAY,getdate())
set @todayDay = datepart(day,getdate())

Select	@todayWeek + '(' + @todayDay + ')' as 'Name(#)',
		IIF(@todayDay % 2 = 0, 'Even Day', 'Odd Day') as 'Day Kind',
		IIF(CHARINDEX('u',@todayWeek,0) != 0, 'Yup', 'Nope') as 'Includes u'
go
