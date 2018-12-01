-- Ronald Mak
-- CMPE 2400
-- ICA 12

-- Q1
declare @classID as int
set @classID = 88

SELECT	ass_type_desc as 'Type',
		avg(score) as 'Raw Avg',
		avg(score / max_score) * 100 as 'Avg',
		count(score) as 'Num'
FROM	Assignment_type LEFT OUTER JOIN Requirements
		ON Assignment_type.ass_type_id = Requirements.ass_type_id LEFT OUTER JOIN Results
			ON Requirements.req_id = Results.req_id
WHERE	Results.class_id = @classID
GROUP BY ass_type_desc

-- Q2 (Question asks to order by description within type, results pic orders by Avg)
SELECT	CAST(ass_desc + '(' + ass_type_desc + ')' as nvarchar(36)) as 'Desc(Type)',
		Round(avg(score / max_score) * 100,2) as 'Avg',
		count(score) as 'Num Score'
FROM	Assignment_type INNER JOIN Requirements
		ON Assignment_type.ass_type_id = Requirements.ass_type_id INNER JOIN Results
			ON Requirements.req_id = Results.req_id
WHERE	Results.class_id = @classID
GROUP BY ass_type_desc, ass_desc, Assignment_type.ass_type_id
	HAVING avg(score / max_score) * 100 > 57
--ORDER BY ass_type_desc, ass_desc	--This one is according to the picture
ORDER BY [Avg]						--This one is according to the requirement

-- Q3
set @classID = 123

SELECT	last_name as 'Last', 
		ass_type_desc as 'ass_type_desc', 
		Round(min(score / max_score) * 100,1) as 'Low', 
		Round(max(score / max_score) * 100,1) as 'High', 
		Round(avg(score / max_score) * 100,1) as 'Avg'
FROM	Students LEFT OUTER JOIN Results
		ON Students.student_id = Results.student_id LEFT OUTER JOIN Requirements
			ON Results.req_id = Requirements.req_id LEFT OUTER JOIN Assignment_type
				ON Requirements.ass_type_id = Assignment_type.ass_type_id
WHERE	Results.class_id = @classID	
GROUP BY last_name, ass_type_desc
	HAVING avg(score / max_score) * 100 > 70
ORDER BY ass_type_desc, [Avg]

-- Q4
SELECT	last_name as 'Instructor',
		CONVERT(nvarchar(11), start_date, 106) as 'Start',
		Count(student_id) as 'Num Registered',
		Count(CASE WHEN active=1 THEN 1 END) as 'Num Active'
FROM	Instructors LEFT OUTER JOIN Classes
		ON Instructors.instructor_id = Classes.instructor_id LEFT OUTER JOIN class_to_student
			ON Classes.class_id = class_to_student.class_id
GROUP BY last_name, start_date	
	HAVING Count(student_id) - Count(CASE WHEN active=1 THEN 1 END) > 3 
ORDER BY [Instructor], start_date

-- Q5
declare @startyear as int
declare @maxscore as int

set @startyear = 2011
set @maxscore = 40


SELECT	last_name + ', ' + first_name as 'Student',
		class_desc as 'Class',
		ass_type_desc as 'Type',
		count(score) as 'Submitted',
		Round(avg(score / max_score) * 100,1) as 'Avg'
FROM	Students LEFT OUTER JOIN Results
		ON	students.student_id = Results.student_id LEFT OUTER JOIN Classes
			ON	Results.class_id = Classes.class_id LEFT OUTER JOIN Requirements
				ON Results.Req_id = Requirements.Req_id LEFT OUTER JOIN Assignment_type
					ON Requirements.ass_type_id = Assignment_type.ass_type_id
WHERE	Datepart(year,Classes.start_date) = @startyear AND score IS NOT NULL
GROUP BY last_name, first_name, class_desc, ass_type_desc
	HAVING	avg(score / max_score) * 100 < @maxscore
		AND count(score) > 10
ORDER BY [Submitted]