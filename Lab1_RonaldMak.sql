-- Lab 1: Database Creation
-- Ronald Mak
-- CMPE 2400

--Database Creation
USE [master]
GO

if exists 
(
	select	* 
	from	sysdatabases 
	where	name='rmak2_Lab1'
)
		drop database rmak2_Lab1
go

CREATE DATABASE [rmak2_Lab1]
GO

USE [rmak2_Lab1]
GO

--Creating Program table
CREATE TABLE [dbo].[Program] (
	[ProgramID] [varchar](4) NOT NULL,
	[CommonName] [nvarchar](50) NULL
	CONSTRAINT [PK_ProgramID] PRIMARY KEY CLUSTERED
	(
		[ProgramID] ASC
	)
)
GO

--Creating Student table
CREATE TABLE [dbo].[Student] (
	[StudentID] [int] IDENTITY(100000000,1) NOT NULL,
	[FirstName] [nvarchar](24) NOT NULL,
	[LastName] [nvarchar](24) NOT NULL,
	[ProgramID] [varchar](4) NULL
	CONSTRAINT [PK_StudentID] PRIMARY KEY CLUSTERED
	(
		[StudentID] ASC
	)
	CONSTRAINT [FK_Student_Program] FOREIGN KEY ([ProgramID])
	REFERENCES [dbo].[Program] ([ProgramID])
)
GO

--Creating Locker table
CREATE TABLE [dbo].[Locker] (
	[LockerID] [nvarchar](7) NOT NULL,
	[StudentID] [int] NULL,
	[AssignedOn] [datetime] NULL
	CONSTRAINT [PK_LockerID] PRIMARY KEY CLUSTERED
	(
		[LockerID] ASC
	)
	CONSTRAINT [FK_Locker_Student] FOREIGN KEY ([StudentID])
	REFERENCES [dbo].[Student] ([StudentID])
)
GO

--Inserting predetermined values into Program table
INSERT INTO Program
Values	('CMPE', 'Computer Engineering Technology'),
		('CMPA', 'Computer Network Administrator'),
		('NETE', 'Network Engineering Technology')
GO

--Procedure Creation

create proc AddLocker		
	@ErrorMessage as nvarchar(50) output
as

declare @floorNum as int
declare @lockerNum as int
set @floorNum = 1
set @lockerNum = 0

if NOT exists
(
	SELECT	*
	FROM	rmak2_Lab1.INFORMATION_SCHEMA.TABLES
	WHERE	TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Locker'
)
BEGIN
	set @ErrorMessage = 'Table doesn''t exist'
	return -1
END

WHILE (@floorNum <= 3)
BEGIN
	WHILE (@lockerNum <= 49)
	BEGIN				
			INSERT INTO Locker
			Values	('W'+CAST(@floorNum as varchar(3))+'-'+ FORMAT(@lockerNum, '000') + 'A', NULL, NULL),
					('W'+CAST(@floorNum as varchar(3))+'-'+ FORMAT(@lockerNum, '000') + 'B', NULL, NULL)

			set @lockerNum += 1;
	END
	set @lockerNum = 0
	set @floorNum += 1
END
set @ErrorMessage = 'OK'
return 0
GO

--------------------------------------
create proc RemoveLocker
	@LockerID as nchar(7) = null,
	@ErrorMessage as nvarchar(50) output
as
if @LockerID is null
begin
	set @ErrorMessage = 'LockerID can''t be NULL'
	return -1
end

if not exists ( select * from Locker where LockerID = @LockerID )
begin
	set @ErrorMessage = 'LockerID does not exist'
	return -1
end

if exists (select * from Locker where LockerID = @LockerID and StudentID is not null)
begin
	set @ErrorMessage = 'Locker must not be assigned'
	return -1
end

delete from Locker where LockerID = @LockerID
set @ErrorMessage = 'OK'
return 0
GO

--------------------------------------
create proc AssignLocker
	@LockerID as varchar(7) = null,
	@StudentID as int = null,
	@ErrorMessage as nvarchar(50) output
as
if @LockerID is null
begin
	set @ErrorMessage = 'LockerID can''t be NULL'
	return -1
end

if @StudentID is null
begin
	set @ErrorMessage = 'StudentID can''t be NULL'
	return -1
end

if not exists ( select * from Student where StudentID = @StudentID )
begin
	set @ErrorMessage = 'StudentID does not exist'
	return -1
end

if not exists ( select * from Locker where LockerID = @LockerID )
begin
	set @ErrorMessage = 'LockerID does not exist'
	return -1
end

if exists (select * from Locker where LockerID = @LockerID and (StudentID is not null OR AssignedOn is not null))
begin
	set @ErrorMessage = 'Locker must not be assigned'
	return -1	
end

UPDATE	Locker
SET		StudentID = @StudentID,
		AssignedOn = getDate()
WHERE	LockerID = @LockerID

set @ErrorMessage = 'OK'
RETURN	0
GO

--------------------------------------
create proc ReleaseLocker
	@LockerID as varchar(7) = null,
	@ErrorMessage as nvarchar(50) output
as

if @LockerID is null
begin
	set @ErrorMessage = 'LockerID can''t be NULL'
	return -1
end

--if exists (select * from Locker where LockerID = @LockerID and (StudentID is not null OR AssignedOn is not null))
--begin
--	set @ErrorMessage = 'Locker must not be assigned'
--	return -1	
--end

UPDATE	Locker
SET		StudentID = null,
		AssignedOn = null
WHERE	LockerID = @LockerID

set @ErrorMessage = 'OK'
RETURN	0
GO

--------------------------------------
create proc AddStudent
	--@StudentID as int = null,
	@FirstName as nvarchar(24) = null,
	@LastName as nvarchar(24) = null,
	@ProgramID as varchar(4) = null,
	@ErrorMessage as nvarchar(50) output
as
--if @StudentID is null
--begin
--	set @ErrorMessage = 'StudentID can''t be NULL'
--	return -1
--end

if @FirstName is null
begin
	set @ErrorMessage = 'FirstName can''t be NULL'
	return -1
end

if @LastName is null
begin
	set @ErrorMessage = 'LastName can''t be NULL'
	return -1
end

if LEN(@FirstName) > 24
begin
	set @ErrorMessage = 'FirstName too long'
	return -1
end

if LEN(@LastName) > 24
begin
	set @ErrorMessage = 'LastName too long'
	return -1
end

--if exists (select * from Student where StudentID = @StudentID)
--begin
--	set @ErrorMessage = 'Student already exists'
--	return -1
--end

if not exists (select * from Program where ProgramID = @ProgramID)
begin
	set @ErrorMessage = 'Program doesn''t exist'
	return -1
end

--PRINT	'Inserting student: ' + StudentID
INSERT INTO Student
Values		(@FirstName, @LastName, @ProgramID)

set @ErrorMessage = 'OK'
RETURN 0
GO

--------------------------------------
create proc UpdateStudent
	@StudentID as int = null,
	@FirstName as nvarchar(24) = null,
	@LastName as nvarchar(24) = null,
	@ProgramID as varchar(4) = null,
	@ErrorMessage as nvarchar(50) output
as
if @StudentID is null
begin
	set @ErrorMessage = 'StudentID can''t be NULL'
	return -1
end

if @FirstName is null
begin
	set @ErrorMessage = 'FirstName can''t be NULL'
	return -1
end

if @LastName is null
begin
	set @ErrorMessage = 'LastName can''t be NULL'
	return -1
end

if LEN(@FirstName) > 24
begin
	set @ErrorMessage = 'FirstName too long'
	return -1
end

if LEN(@LastName) > 24
begin
	set @ErrorMessage = 'LastName too long'
	return -1
end

if not exists (select * from Student where StudentID = @StudentID)
begin
	set @ErrorMessage = 'Student doesn''t exists'
	return -1
end

if not exists (select * from Program where ProgramID = @ProgramID)
begin
	set @ErrorMessage = 'Program doesn''t exist'
	return -1
end

UPDATE	Student
SET		FirstName = @FirstName,
		LastName = @LastName,
		ProgramID = @ProgramID
WHERE	StudentID = @StudentID

set @ErrorMessage = 'OK'
return 0
GO

--------------------------------------
create proc DeleteStudent
	@StudentID as int = null,
	@ErrorMessage as nvarchar(50) output
as
if @StudentID is null
begin
	set @ErrorMessage = 'StudentID can''t be NULL'
	return -1
end

if not exists (select * from Student where StudentID = @StudentID)
begin
	set @ErrorMessage = 'Student doesn''t exists'
	return -1
end

if exists (select * from Locker where StudentID = @StudentID)
begin
	declare @LockerID as varchar(7)	
	declare @retVal as int

	SELECT	@LockerID = LockerID
	FROM	Locker
	WHERE	StudentID = @StudentID
	
	exec @retVal = ReleaseLocker @LockerID, @ErrorMessage output
END

DELETE	Student
WHERE	StudentID = @StudentID

set @ErrorMessage = 'OK'
return 0
GO

--------------------------------------
--Checks

--Check premade Program table
SELECT * FROM Program

declare @retVal as int
declare @ErrorMessage as nvarchar(50)

--Check filling of locker table
exec @retVal = AddLocker @ErrorMessage output
SELECT 'Added Lockers', @retVal, @ErrorMessage
SELECT * FROM Locker

--Check RemoveLocker
exec @retVal = RemoveLocker 'W2-001A', @ErrorMessage
SELECT 'Removed Locker', 'W2-001A', @retVal, @ErrorMessage
SELECT *, @retVal as 'RetVal' FROM Locker WHERE LockerID = 'W2-001A'

--Check AddStudent
exec @retVal = AddStudent 'Ronald', 'Mak', 'CMPE', @ErrorMessage output
SELECT @retVal, @ErrorMessage
exec @retVal = AddStudent 'Janelia', 'Ngo', 'CMPA', @ErrorMessage output
SELECT @retVal, @ErrorMessage
exec @retVal = AddStudent 'FTest1', 'LTest1', 'NETE', @ErrorMessage output
SELECT @retVal, @ErrorMessage
exec @retVal = AddStudent 'FTest2', 'LTest2', NULL, @ErrorMessage output
SELECT @retVal, @ErrorMessage
exec @retVal = AddStudent 'FTest3', 'LTest3', NULL, @ErrorMessage output
SELECT @retVal, @ErrorMessage
exec @retVal = AddStudent 'FTest4', 'LTest4', NULL, @ErrorMessage output
SELECT @retVal, @ErrorMessage
exec @retVal = AddStudent 'FTest5', 'LTest5', NULL, @ErrorMessage output
SELECT @retVal, @ErrorMessage

SELECT * FROM Student

--Check AssignLocker
exec @retVal = AssignLocker 'W3-045A', 100000000, @ErrorMessage output
SELECT *, @retVal as 'RetVal', @ErrorMessage as 'Error' FROM Locker WHERE LockerID = 'W3-045A'

--Check ReleaseLocker
exec @retVal = ReleaseLocker 'W3-045A', @ErrorMessage output
SELECT *, @retVal as 'RetVal', @ErrorMessage as 'Error' FROM Locker WHERE LockerID = 'W3-045A'

--Check UpdateStudent
exec @retVal = UpdateStudent 100000002, 'Up_FTest1', 'Up_LTest1', 'CMPE', @ErrorMessage output
SELECT *, @retVal as 'RetVal', @ErrorMessage as 'Error' FROM Student WHERE StudentID = 100000002

--Check DeleteStudent
exec @retVal = AssignLocker 'W3-045B', 100000002, @ErrorMessage output
SELECT *, @retVal as 'RetVal', @ErrorMessage as 'Error' FROM Locker WHERE LockerID = 'W3-045B'

exec @retVal = DeleteStudent 100000002, @ErrorMessage output
SELECT *, @retVal as 'RetVal', @ErrorMessage as 'Error' FROM Student
SELECT * FROM Locker WHERE LockerID = 'W3-045B'

--Error Checking:

--Error check for AddStudent
---Invalid ProgramID
exec @retVal = AddStudent 'FTest1', 'LTest1', 'NET5', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---Invalid LastName > 24 (SQL auto truncates down to max length and inserts)
exec @retVal = AddStudent 'FTest1', '12345678901234567890123456', 'NETE', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---Invalid FirstName > 24
exec @retVal = AddStudent '12345678901234567890123456', 'LTest1', 'NETE', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---NULL FirstName
exec @retVal = AddStudent NULL, 'LTest1', 'NET5', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---NULL LastName
exec @retVal = AddStudent 'FTest1', NULL , 'NET5', @ErrorMessage output
SELECT @retVal, @ErrorMessage

SELECT * FROM Student

--Error Check for RemoveLocker
---Invalid Locker
exec @retVal = RemoveLocker 'W4-001A', @ErrorMessage output
SELECT 'Invalid Locker', 'W4-001A', @retVal, @ErrorMessage
---Assigned Locker
exec @retVal = AssignLocker 'W3-044B', 100000001, @ErrorMessage output
SELECT *, @retVal as 'RetVal', @ErrorMessage as 'Error' FROM Locker WHERE LockerID = 'W3-044B'
exec @retVal = RemoveLocker 'W3-044B', @ErrorMEssage output
SELECT 'W3-044B', @retVal, @ErrorMessage

--Error Check for UpdateStudent
---Student doesn't exist
exec @retVal = UpdateStudent 100000002, 'Up_FTest1', 'Up_LTest1', 'NET5', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---Invalid ProgramID
exec @retVal = UpdateStudent 100000003, 'Up_FTest1', 'Up_LTest1', 'NET5', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---Invalid LastName > 24 (SQL auto truncates down to max length and inserts)
exec @retVal = UpdateStudent 100000003, 'Up_FTest1', 'Up_12345678901234567890123456', 'NETE', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---Invalid FirstName > 24
exec @retVal = UpdateStudent 100000003, 'Up_12345678901234567890123456', 'Up_LTest1', 'NETE', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---NULL FirstName
exec @retVal = UpdateStudent 100000003, NULL, 'LTest1', 'NET5', @ErrorMessage output
SELECT @retVal, @ErrorMessage
---NULL LastName
exec @retVal = UpdateStudent 100000003, 'FTest1', NULL , 'NET5', @ErrorMessage output
SELECT @retVal, @ErrorMessage

SELECT * FROM Student

--Error Check for DeleteStudent
exec @retVal = AssignLocker 'W3-046B', 100000004, @ErrorMessage output
SELECT @retVal as 'RetVal', @ErrorMessage as 'Error' FROM Locker WHERE LockerID = 'W3-045B'
--Invalid StudentID
exec @retVal = DeleteStudent 100000009, @ErrorMessage output
SELECT @retVal as 'RetVal', @ErrorMessage as 'Error'
--Null StudentID
exec @retVal = DeleteStudent NULL, @ErrorMessage output
SELECT @retVal as 'RetVal', @ErrorMessage as 'Error'


GO

