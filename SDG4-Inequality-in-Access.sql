-- Create the schema
CREATE SCHEMA IF NOT EXISTS SDG4_Access_Inequality;
USE SDG4_Access_Inequality;

-- Create Regions table
CREATE TABLE IF NOT EXISTS Regions (
    region_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Create Schools table
CREATE TABLE IF NOT EXISTS Schools (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES Regions(region_id) ON DELETE SET NULL
);

-- Create Students table
CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    region_id INT,
    school_id INT,
    FOREIGN KEY (region_id) REFERENCES Regions(region_id) ON DELETE SET NULL,
    FOREIGN KEY (school_id) REFERENCES Schools(school_id) ON DELETE SET NULL
);

-- Create Resources table
CREATE TABLE IF NOT EXISTS Resources (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    school_id INT,
    resource_type VARCHAR(100) NOT NULL,
    quantity INT,
    FOREIGN KEY (school_id) REFERENCES Schools(school_id) ON DELETE CASCADE
);

-- Create Performance table
CREATE TABLE IF NOT EXISTS Performance (
    performance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject VARCHAR(100) NOT NULL,
    score DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);


-- ADDING SAMPLE DATA
-- Insert Regions
INSERT INTO Regions (name) VALUES ('North'), ('South'), ('East'), ('West');

-- Insert Schools
INSERT INTO Schools (name, region_id) VALUES ('School A', 1), ('School B', 2), ('School C', 3);

-- Insert Students
INSERT INTO Students (name, age, region_id, school_id) VALUES 
('Alice', 10, 1, 1), 
('Bob', 11, 2, 2), 
('Charlie', 12, 3, 3);

-- Insert Resources
INSERT INTO Resources (school_id, resource_type, quantity) VALUES 
(1, 'Books', 100), 
(2, 'Computers', 50), 
(3, 'Laboratories', 5);

-- Insert Performance
INSERT INTO Performance (student_id, subject, score) VALUES 
(1, 'Math', 85.00), 
(2, 'Science', 90.00), 
(3, 'English', 75.00);


-- DATA RETRIEVAL
-- Retrieve student data with their school and region
SELECT s.name AS student_name, sch.name AS school_name, r.name AS region_name
FROM Students s
JOIN Schools sch ON s.school_id = sch.school_id
JOIN Regions r ON s.region_id = r.region_id;

-- Retrieve resource availability by region
SELECT r.name AS region_name, res.resource_type, SUM(res.quantity) AS total_quantity
FROM Resources res
JOIN Schools sch ON res.school_id = sch.school_id
JOIN Regions r ON sch.region_id = r.region_id
GROUP BY r.name, res.resource_type;

-- Analyze performance by region
SELECT r.name AS region_name, AVG(p.score) AS average_score
FROM Performance p
JOIN Students s ON p.student_id = s.student_id
JOIN Schools sch ON s.school_id = sch.school_id
JOIN Regions r ON sch.region_id = r.region_id
GROUP BY r.name;


-- DATA ANALYSIS
-- Analyze the average score per region
SELECT r.name AS region_name, AVG(p.score) AS average_score
FROM Performance p
JOIN Students s ON p.student_id = s.student_id
JOIN Schools sch ON s.school_id = sch.school_id
JOIN Regions r ON sch.region_id = r.region_id
GROUP BY r.name;

-- Resource distribution across regions
SELECT r.name AS region_name, res.resource_type, SUM(res.quantity) AS total_resources
FROM Resources res
JOIN Schools sch ON res.school_id = sch.school_id
JOIN Regions r ON sch.region_id = r.region_id
GROUP BY r.name, res.resource_type;

-- ADDING NEW DATA, ANALYSIS AND RETRIEVAL
-- ADDING THE COLUMN FOR GENDER
ALTER TABLE Students
ADD gender VARCHAR(10);
UPDATE Students
SET gender = 'Female'
WHERE student_id = 1; -- Alice

UPDATE Students
SET gender = 'Male'
WHERE student_id = 2; -- Bob

UPDATE Students
SET gender = 'Male'
WHERE student_id = 3; -- Charlie

-- ADDING A NEW SCHOOL TO THE REGIONS TABLE
INSERT INTO Schools (name, region_id) VALUES
('School D', 4); 

-- Add Students to Schools A, B, C, and D with their performance
INSERT INTO Students (name, age, region_id, school_id, gender) VALUES 
('Jack', 12, 1, 1, 'Male'), 
('Morris', 12, 1, 1, 'Male'),
('Carol', 11, 1, 1, 'Female'),
('Kingori', 12, 2, 2, 'Male'),
('Ofweneke', 12, 2, 2, 'Male'),
('Jane', 11, 2, 2, 'Female'),
('Kwach', 12, 3, 3, 'Male'),
('Butita', 12, 3, 3, 'Male'),
('Jackie', 11, 3, 3, 'Female'),
('Raila', 12, 4, 4, 'Male'),
('Uhuru', 12, 4, 4, 'Male'),
('Ann', 11, 4, 4, 'Female');

-- Corrected Insert into Performance with updated student_id values
INSERT INTO Performance (student_id, subject, score) VALUES
(16, 'Science', 70.00), (16, 'Math', 80.00), (16, 'English', 75.00), -- Jack
(17, 'Science', 90.00), (17, 'Math', 90.00), (17, 'English', 80.00), -- Morris
(18, 'Science', 85.00), (18, 'Math', 90.00), (18, 'English', 80.00), -- Carol
(19, 'Science', 60.00), (19, 'Math', 70.00), (19, 'English', 65.00), -- Kingori
(20, 'Science', 80.00), (20, 'Math', 80.00), (20, 'English', 70.00), -- Ofweneke
(21, 'Science', 75.00), (21, 'Math', 80.00), (21, 'English', 70.00), -- Jane
(22, 'Science', 50.00), (22, 'Math', 60.00), (22, 'English', 55.00), -- Kwach
(23, 'Science', 70.00), (23, 'Math', 70.00), (23, 'English', 60.00), -- Butita
(24, 'Science', 65.00), (24, 'Math', 70.00), (24, 'English', 60.00), -- Jackie
(25, 'Science', 40.00), (25, 'Math', 50.00), (25, 'English', 45.00), -- Raila
(26, 'Science', 60.00), (26, 'Math', 60.00), (26, 'English', 50.00), -- Uhuru
(27, 'Science', 55.00), (27, 'Math', 60.00), (27, 'English', 50.00); -- Ann

-- ADDING THE COST COLUMN
ALTER TABLE Resources
ADD cost DECIMAL(10, 2);

-- UPDATING THE COST OF PREVIOUS RESOURCES
UPDATE Resources
SET cost = 7000
WHERE school_id = 1 AND resource_type = 'Books' AND quantity = 100;

UPDATE Resources
SET cost = 3000
WHERE school_id = 2 AND resource_type = 'Computers' AND quantity = 50;

UPDATE Resources
SET cost = 100000
WHERE school_id = 3 AND resource_type = 'Laboratories' AND quantity = 5;

-- Insert resources for each school
INSERT INTO Resources (school_id, resource_type, quantity, cost) VALUES 
(1, 'Books', 200, 10000), (1, 'Computers', 150, 150000), (1, 'Laboratories', 5, 1000000), -- School A
(2, 'Books', 150, 7500), (2, 'Computers', 100, 100000), (2, 'Laboratories', 3, 600000),  -- School B
(3, 'Books', 100, 5000), (3, 'Computers', 50, 50000), (3, 'Laboratories', 1, 200000),  -- School C
(4, 'Books', 50, 2500), (4, 'Computers', 25, 25000), (4, 'Laboratories', 0, 0); -- School D


-- DATA ANALYSIS AND RETRIEVAL
-- Retrieve Student Data with Their School and Region
SELECT DISTINCT s.name AS student_name, sch.name AS school_name, r.name AS region_name
FROM Students s
JOIN Schools sch ON s.school_id = sch.school_id
JOIN Regions r ON s.region_id = r.region_id;

-- Retrieve Resource Availability by Region
SELECT r.name AS region_name, res.resource_type, SUM(res.quantity) AS total_quantity
FROM Resources res
JOIN Schools sch ON res.school_id = sch.school_id
JOIN Regions r ON sch.region_id = r.region_id
GROUP BY r.name, res.resource_type;

-- Analyze Performance by Region
SELECT r.name AS region_name, AVG(p.score) AS average_score
FROM Performance p
JOIN Students s ON p.student_id = s.student_id
JOIN Schools sch ON s.school_id = sch.school_id
JOIN Regions r ON sch.region_id = r.region_id
GROUP BY r.name;

-- Analyze Average Score per Gender
SELECT s.gender AS gender, AVG(p.score) AS average_score
FROM Performance p
JOIN Students s ON p.student_id = s.student_id
GROUP BY s.gender;

-- Resource Distribution Across Regions
SELECT r.name AS region_name, res.resource_type, SUM(res.quantity) AS total_resources
FROM Resources res
JOIN Schools sch ON res.school_id = sch.school_id
JOIN Regions r ON sch.region_id = r.region_id
GROUP BY r.name, res.resource_type;


-- Analyze Performance Across Age
SELECT 
    s.gender AS gender,
    COUNT(*) AS total_students,
    SUM(p.score) AS total_score,
    AVG(p.score) AS average_score
FROM Performance p
JOIN Students s ON p.student_id = s.student_id
GROUP BY s.gender;


-- Analyze Total Cost of Resource Allocation Across Schools
SELECT sch.name AS school_name, SUM(res.cost) AS total_cost
FROM Resources res
JOIN Schools sch ON res.school_id = sch.school_id
GROUP BY sch.name;


-- Average score per student
SELECT 
    s.name AS student_name,
    AVG(p.score) AS average_score
FROM Performance p
JOIN Students s ON p.student_id = s.student_id
GROUP BY s.name;



-- Calculate total resources and total cost for each resource type across all regions
SELECT 
    reg.name AS region_name,
    res.resource_type,
    SUM(res.total_quantity) AS total_resources,
    SUM(res.total_cost) AS total_cost
FROM (
    -- Subquery to sum up resources and costs per school
    SELECT 
        sch.region_id,
        res.resource_type,
        SUM(res.quantity) AS total_quantity,
        SUM(res.cost) AS total_cost
    FROM Resources res
    JOIN Schools sch ON res.school_id = sch.school_id
    GROUP BY sch.region_id, res.resource_type
) AS res
JOIN Regions reg ON res.region_id = reg.region_id
GROUP BY reg.name, res.resource_type
ORDER BY reg.name, res.resource_type;