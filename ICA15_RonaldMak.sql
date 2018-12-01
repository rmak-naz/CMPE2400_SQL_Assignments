-- ica15
-- This ICA is comprised of 2 parts, but should be tackled as described by your instructor.
-- To ensure end-to-end running, you will have to complete the ica in pairs where possible :
--  q1A + q2A, then q1B + q2B
-- You will need to install a personal version of the ClassTrak database
-- The Full and Refresh scripts are on the Moodle site.
-- Once installed, you can run the refresh script to restore data that may be modified or 
--  deleted in the process of completing this ica.

use  rmak2_ClassTrak
go

-- q1
-- All in one batch, to retain your variable contexts/values

-- A
-- Insert a new Instructor : Donald Trump
--  Check column types, supply necessary values, it may require a column list
--  Save your identity into a variable
declare @last_InstID as int

INSERT INTO	Instructors
VALUES		('Trump', 'Donald')

set @last_InstID = @@IDENTITY
SELECT * FROM Instructors WHERE instructor_id = @last_InstID

-- B
-- Insert a new Course : cmpe2442 "Fast and Furious - SQL Edition"
--  Check column types, supply necessary values, it may require a column list
--  Save your identity into a variable
declare @last_CourseID as int

INSERT INTO Courses
VALUES		('cmpe2442', 'Fast and Furious - SQL Edition')
set @last_CourseID = @@IDENTITY
SELECT * FROM Courses WHERE course_id = @last_CourseID

-- C
-- Insert a record indicating your new instructor is teaching the new course
--  description : "Beware the optimizer"
--  start_date : use 01 Sep 2016
--  Save the identity into a variable
declare @last_classID as int

INSERT INTO Classes
Values		('Beware the optimizer', @last_InstID, @last_CourseID, '01-Sep-2016', null)	
		
set @last_classID = @@IDENTITY
SELECT * FROM Classes WHERE class_id = @last_ClassID

-- D Insert a bunch in one insert
-- Generate the insert statement to Add all the students with a last name that
--  starts with a vowel to the new class
declare @last_classStudID as int

--SELECT last_name FROM Students WHERE last_name LIKE '[aeiou]%'
INSERT INTO	class_to_student
	(class_id, student_id, active)
		SELECT	@last_classID, student_id, null FROM Students WHERE last_name LIKE '[aeiou]%'

set @last_classStudID = @@IDENTITY
SELECT * FROM class_to_student WHERE class_id = @last_ClassID


-- E
--  Prove it all, generate a select to show :
--   All instructors - see your new entry
--   All courses that have SQL in description
--   All classes that have a start_date after 1 Aug 2016
--   All students in the new class - filter by description having "Beware"
--       sort by first name in last name
SELECT * FROM Instructors
SELECT * FROM Courses WHERE course_desc = 'Fast and Furious - SQL Edition'
SELECT * FROM Classes WHERE start_date > '01-Aug-2016'
SELECT * FROM class_to_student INNER JOIN Classes 
	ON class_to_student.class_id = Classes.class_id INNER JOIN Students
		ON class_to_student.student_id = Students.student_id
WHERE class_desc LIKE 'Beware%'
ORDER BY last_name, first_name
go
-- end q1



-- q2 - Undo all your changes to reset the database, you must do this in reverse order to
--      ensure you do not attempt to corrupt Referencial Integrity.
--     As such, work backwards from D to A, deleting what we added, but you must query the DB
--      to find and save the relevant keys.


-- q2 - Undo all your changes to reset the database, you must do this in reverse order to
--      ensure you do not attempt to corrupt Referencial Integrity.
--     As such, work backwards from D to A.

-- D - Delete all students that have been assigned to your new class, do this without a 
--     variable, rather perform a join with proper filtering for this delete
DELETE	class_to_student
FROM	class_to_student INNER JOIN Classes 
	ON	class_to_student.class_id = Classes.class_id INNER JOIN Students
		ON class_to_student.student_id = Students.student_id
WHERE class_desc LIKE 'Beware%'

-- C - declare, query and set class id to your new class based on above filter.
--     declare, query and save the linked course and instructor ( use in B and A )
--     Delete the new class
declare @classID as int
SELECT	@classID = class_id FROM Classes
WHERE	class_desc LIKE 'Beware%'

declare @courseID as int
SELECT	@courseID = course_id FROM Courses
--	ON	Classes.course_id = Courses.course_id
WHERE	course_desc = 'Fast and Furious - SQL Edition'

declare @instructorID as int
SELECT	@instructorID = instructor_id FROM Instructors
--	ON	Classes.instructor_id = Instructors.instructor_id
WHERE	last_name = 'Trump' AND first_name = 'Donald'

select @classID, @courseID, @instructorID

DELETE	Classes
WHERE	class_id = @classID

-- B - Delete the new course as saved in C
DELETE	Courses
WHERE	course_id = @courseID

-- A - Delete the new instructor as saved in C
DELETE	Instructors
WHERE	instructor_id = @instructorID

-- E - Repeat q1 part E to verify the removal of all the data.
SELECT * FROM Instructors
SELECT * FROM Courses WHERE course_desc = 'Fast and Furious - SQL Edition'
SELECT * FROM Classes WHERE start_date > '01-Aug-2016'
SELECT * FROM class_to_student INNER JOIN Classes 
	ON class_to_student.class_id = Classes.class_id INNER JOIN Students
		ON class_to_student.student_id = Students.student_id
WHERE class_desc LIKE 'Beware%'
ORDER BY last_name, first_name
go