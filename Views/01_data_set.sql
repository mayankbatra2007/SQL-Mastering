-- SQL : Views
-- 01_dataset.sql

-- create table departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    hod_name VARCHAR(50)
);
-- CREATE TABLE STUDENTS
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    city VARCHAR(50),
    age INT,
    department_id INT,
    marks INT,

    FOREIGN KEY (department_id)
    REFERENCES Departments(department_id)
);

-- CREATE TABLE COURSES
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT
);

-- CREATE TABLE ENROLLMENTS
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(5),

    FOREIGN KEY (student_id)
    REFERENCES Students(student_id),

    FOREIGN KEY (course_id)
    REFERENCES Courses(course_id)
);

-- Departments DATA
INSERT INTO Departments VALUES
(101, 'CSE', 'Dr. Sharma'),
(102, 'IT', 'Dr. Verma'),
(103, 'ECE', 'Dr. Gupta'),
(104, 'Mechanical', 'Dr. Singh');

-- Students DATA
INSERT INTO Students VALUES
(1, 'Rahul', 'rahul@gmail.com', 'Delhi', 20, 101, 85),
(2, 'Aman', 'aman@gmail.com', 'Ambala', 21, 102, 72),
(3, 'Priya', 'priya@gmail.com', 'Chandigarh', 20, 101, 92),
(4, 'Rohan', 'rohan@gmail.com', 'Delhi', 22, 103, 65),
(5, 'Simran', 'simran@gmail.com', 'Ambala', 20, 101, 78),
(6, 'Karan', 'karan@gmail.com', 'Patiala', 21, 102, 88),
(7, 'Neha', 'neha@gmail.com', 'Delhi', 19, 103, 95),
(8, 'Arjun', 'arjun@gmail.com', 'Ambala', 22, 101, 55),
(9, 'Ishita', 'ishita@gmail.com', 'Chandigarh', 20, 102, 81),
(10, 'Mohit', 'mohit@gmail.com', 'Patiala', 21, 104, 69);

-- COURSE DATA
INSERT INTO Courses VALUES
(201, 'DBMS', 4),
(202, 'Java', 3),
(203, 'Python', 4),
(204, 'Web Development', 3);

-- ENROLLMENT DATA
INSERT INTO Enrollments VALUES
(1, 1, 201, 'A'),
(2, 1, 202, 'A'),
(3, 2, 201, 'B'),
(4, 3, 201, 'A'),
(5, 3, 203, 'A'),
(6, 4, 202, 'C'),
(7, 5, 204, 'B'),
(8, 6, 203, 'A'),
(9, 7, 201, 'A'),
(10, 8, 202, 'C'),
(11, 9, 204, 'B'),
(12, 10, 203, 'B');

-- VERIFY
SELECT * FROM Departments;

SELECT * FROM Students;

SELECT * FROM Courses;

SELECT * FROM Enrollments;

