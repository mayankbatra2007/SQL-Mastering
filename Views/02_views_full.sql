-- VIEWS
-- 02_views_notes.sql

-- INTRO TO VIEWS

/*
WHAT IS VIEW?
a view virtual table created using a SELECT query.
a normal view does not store a seperate copy of the underlying table rows.
it stores the SELECT statement defination.            
whenever we query the view, the database retrieves the relevant data
from the underlying tables

WHY USE VIEWS?

1. Security:
   Hide sensitive columns from users.
2. Simplicity:
   Avoid writing complicated queries repeatedly.
3. Reusability:
   Reuse previously defined SQL queries.
4. Data Abstraction:
   Users can work with a simplified representation
   of database data.
5. Logical Organization:
   Present selected information in a meaningful way.
*/

/* 
CREATE VIEW

SYNTAX:
CREATE VIEW view_name AS
SELECT col1, col2
FROM table_name
WHERE condition

EXPLANATION:

CREATE VIEW:
    Creates a new view.
view_name:
    Name given to the view.
AS:
    Introduces the SELECT query.
SELECT:
    Defines the data displayed by the view.
*/

-- EXAMPLE 1:
-- Create a view containing all CSE students.
CREATE VIEW CSE_Students AS
SELECT student_id, student_name, city, marks
FROM Students
WHERE department_id = 101;

/*
EXPECTED RESULT:
student_id | student_name | city       | marks
------------------------------------------------
1          | Rahul        | Delhi      | 85
3          | Priya        | Chandigarh | 92
5          | Simran       | Ambala     | 78
8          | Arjun        | Ambala     | 55
Only students belonging to department 101 appear.
*/

-- SELECT OP ON VIEWS
-- a view can be queried like a normal table
-- We can use:
-- SELECT, WHERE, ORDER BY, GROUP BY, aggregate FUNCTION
-- display all records
SELECT * FROM CSE_students;

-- DISPLAY ONLY NAMES
SELECT student_name
FROM CSE_Students;

-- Apply WHERE condition
SELECT * FROM CSE_Students
WHERE marks > 80;

-- SORT Students BY marks
SELECT * FROM CSE_Students
ORDER BY marks DESC;

-- find Highest marks
SELECT MAX(marks)
FROM CSE_Students;

-- Count CSE Students
SELECT COUNT(*)
FROM CSE_Students;

-- SIMPLE VIEW

/*
A Simple view is generally created using one TABLE

it does not use:
GROUP BY, Aggregate Functions, DISTINCT, JOINS

Simple views are generally updatable,
subject to DBMS-specific restrictions.
*/

CREATE VIEW Student_Basic AS
SELECT student_id, student_name, city
FROM Students;

SELECT * FROM Student_Basic;

-- COMPLEX VIEW
-- A Complex table use more complex queries
-- it may contain:
-- JOIN, GROUP BY, Aggregate Functions, Subqueries
-- Such views are generally directly updateable

-- department wise avg marks
CREATE VIEW Department_Average AS
SELECT d.department_name, AVG(s.marks) AS average_marks
FROM Departments d     
JOIN Students s
ON d.department_id = s.department_id
GROUP BY d.department_name;

SELECT * FROM Department_Average;

-- ALTER TABLE
-- Alter VIEW MODIFIES
/*
ALTER VIEW modifies an existing view definition.
It does not directly modify the underlying table records.
SYNTAX:

ALTER VIEW view_name AS
SELECT ...
*/
ALTER VIEW CSE_Students AS
SELECT student_id, student_name, city, marks
FROM Students
WHERE department_id = 101
AND marks > 80;
-- Now only CSE students scoring above 80 appear.

SELECT * FROM CSE_Students;

-- RENAME VIEW
/*
In MySQL, RENAME TABLE can be used to rename a view.
SYNTAX:
RENAME TABLE old_view_name TO new_view_name;
*/
RENAME TABLE Student_Basic TO Student_Information;
SELECT * FROM Student_Information;

-- DROP VIEW
/*
DROP VIEW permanently removes the view definition.
IMPORTANT:
It does NOT delete the original table.
SYNTAX:
DROP VIEW view_name;
*/
DROP VIEW IF EXISTS Department_Average;

-- UPDATE THROUGH VIEW
/* 
some views allow UPDATE operation
If View is updateable , changes made thrugh it are reflected in the orignal TABLE
This is generally possible with simple views
that map directly to underlying table rows.
*/
-- create a simple updateable VIEW
CREATE VIEW CSE_Marks AS
SELECT student_id, student_name, marks
FROM Students
WHERE department_id = 101;

-- UPDATE RAHUL MARKS THROUGH VIEW
UPDATE CSE_Marks
SET marks = 90;
WHERE student_id = 1;

-- VERIFY ORIGNAL TABLE
SELECT * FROM Students WHERE student_id = 1;

-- INSERT THROUGH VIEW
/*
INSERT through a view inserts data into
the underlying table if the view is updatable.
All required underlying table columns must
receive valid values, either through the view,
defaults or other database mechanisms.
*/
-- create a simple VIEW 
CREATE VIEW Student_Insert_View AS
SELECT student_id, student_name, city, age, department_id, marks
FROM Students;

-- iNSERT THROUGH VIEW
INSERT INTO Student_Insert_View
VALUES (11, 'Vikas', 'Ambala', 20, 101, 87);

-- verify
SELECT * FROM Students_Insert_View WHERE student_id = 11;

-- DELETE THROUGH VIEW
/*
DELETE through an updatable view deletes
the corresponding record from the original table.
BE CAREFUL:
This is an actual deletion of underlying data.
*/
DELETE FROM CSE_Marks
WHERE student_id = 8;

-- WITH CHECK OPTION
/*
WITH CHECK OPTION ensures that INSERT and UPDATE
operations through a view satisfy its WHERE condition.
WITHOUT CHECK OPTION:
A row might be updated so that it no longer
satisfies the view's filtering condition.
WITH CHECK OPTION:
Such modifications are rejected.
*/
CREATE OR REPLACE VIEW CSE_Check_View AS
SELECT student_id, student_name, department_id, marks
FROM Students 
WHERE department_id = 101
WITH CHECK OPTION;

-- UPDATE IS VALID IF THE STUDENT REAMINS IN DEPARTMENT ID = 101
UPDATE CSE_Check_View
SET marks = 99
WHERE Student_id = 1;

-- THIS UPDATE SHOULD FAIL BCZ DEPARTMENT ID CHNAGES FROM 101 TO 102
UPDATE CSE_Check_View
SET department_id = 102
WHERE student_id = 1;

-- LOCAL CHECK OPTION
/*
LOCAL CHECK OPTION:
Checks the condition of the current view.
It does not necessarily enforce conditions
of underlying views in a nested view chain.
Syntax:
WITH LOCAL CHECK OPTION
*/

/*
CASCADED CHECK OPTION:
Checks the current view and the conditions
of underlying views in the nested view chain.
In MySQL, CHECK OPTION defaults to CASCADED
if neither LOCAL nor CASCADED is specified.
*/

-- VIEW USING JOIN
/*
Views can combine information from multiple tables.
JOIN combines matching records from tables.
Here we combine:
    Students
    Departments
*/
CREATE VIEW Student_Department_Details AS
SELECT
    s.student_id,
    s.student_name,
    d.department_name,
    s.marks
FROM Students s
INNER JOIN Departments d
ON s.department_id = d.department_id;

SELECT * FROM Student_Department_Details;


-- VIEW USING SUBQUERY
/*
A subquery is a query inside another query.
Here we find students whose marks are
greater than the overall average marks.
*/
CREATE VIEW Above_Average_Students AS
SELECT
    student_id,
    student_name,
    marks
FROM Students
WHERE marks > (
    SELECT AVG(marks)
    FROM Students
);

SELECT * FROM Above_Average_Students;

-- NESTED VIEWS
/*
A nested view is a view created using another view.
Example:
Students -> CSE_Students -> High_Scoring_CSE
This allows us to build reusable query layers.
*/
CREATE OR REPLACE VIEW High_Scoring_CSE AS
SELECT *
FROM CSE_Students
WHERE marks > 85;

SELECT * FROM High_Scoring_CSE;

-- VIEW WITH GROUP BY
/*
GROUP BY creates groups of records.
Aggregate functions calculate values
for each group.
Examples:
    AVG()
    COUNT()
    MAX()
    MIN()
    SUM()
*/
CREATE VIEW Department_Statistics AS
SELECT
    department_id,
    COUNT(*) AS total_students,
    AVG(marks) AS average_marks,
    MAX(marks) AS highest_marks,
    MIN(marks) AS lowest_marks
FROM Students
GROUP BY department_id;


--VIEW METADATA

/*
SHOW FULL TABLES:

Displays tables and views.
SHOW CREATE VIEW:
Displays the SQL statement used to create a view.
INFORMATION_SCHEMA.VIEWS:
Provides metadata about database views.
*/

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SHOW CREATE VIEW CSE_Students;

SELECT
    TABLE_NAME,
    VIEW_DEFINITION,
    CHECK_OPTION,
    IS_UPDATABLE
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = DATABASE();



--CREATE OR REPLACE VIEW


/*
CREATE OR REPLACE VIEW:
Creates a view if it does not exist.
If it already exists, replaces its definition.
This is useful when modifying view definitions.
*/

CREATE OR REPLACE VIEW Top_Students AS
SELECT
    student_id,
    student_name,
    marks
FROM Students
WHERE marks >= 85;

SELECT * FROM Top_Students;


-- ============================================================
-- END OF VIEWS NOTES