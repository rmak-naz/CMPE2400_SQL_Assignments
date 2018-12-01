-- ica16
-- You will need to install a personal version of the ClassTrak database
-- The Full and Refresh scripts are on the Moodle site.
-- Once installed, you can run the refresh script to restore data that may be modified or 
--  deleted in the process of completing this ica.

use  rmak2_ClassTrak
go

-- q1
-- Complete an update to change all classes to have their descriptions be lower case
-- select all classes to verify your update
UPDATE	Classes
set		class_desc = LOWER(class_desc)
go
SELECT class_desc FROM Classes

-- q2
-- Complete an update to change all classes that are "cmpe" courses to be upper case
-- select all classes to verify your selective update
UPDATE	Classes
SET		class_desc = UPPER(class_desc)
WHERE	class_desc LIKE '%cmpe%'
SELECT class_desc FROM Classes
go

-- q3
-- For class_id = 123
-- Update the score of all results which have a real percentage of less than 50
-- The score should be increased by 10% of the max score value, maybe more pass ?
-- Use ica13_06 select statement to verify pre and post update values,
--  put one select before and after your update call.
--SELECT	score FROM Results
SELECT	ass_type_desc as 'Type',
		Round(avg(score),2) as 'Raw Avg',
		Round(avg(score / max_score) * 100,2) as 'Avg',
		count(score) as 'Num'
FROM	Assignment_type LEFT OUTER JOIN Requirements
		ON Assignment_type.ass_type_id = Requirements.ass_type_id LEFT OUTER JOIN Results
			ON Requirements.req_id = Results.req_id
WHERE	Results.class_id = 123
GROUP BY ass_type_desc

UPDATE	Results
SET		score += (max_score * 0.1)
FROM	Results INNER JOIN Requirements
	ON	Results.req_id = Requirements.req_id
WHERE	Results.class_id = 123 AND ((score / max_score) * 100) < 50

SELECT	ass_type_desc as 'Type',
		Round(avg(score),2) as 'Raw Avg',
		Round(avg(score / max_score) * 100,2) as 'Avg',
		count(score) as 'Num'
FROM	Assignment_type LEFT OUTER JOIN Requirements
		ON Assignment_type.ass_type_id = Requirements.ass_type_id LEFT OUTER JOIN Results
			ON Requirements.req_id = Results.req_id
WHERE	Results.class_id = 123
GROUP BY ass_type_desc
GO