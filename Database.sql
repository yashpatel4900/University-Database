-- Create the CSE581projects database
CREATE DATABASE CSE581projects;
GO

-- Use the CSE581projects database
USE CSE581projects;
GO

-- Create BenefitCoverage table
CREATE TABLE BenefitCoverage (
  BenefitCoverageId INT IDENTITY(1,1) PRIMARY KEY,
  Type VARCHAR(255) NOT NULL
);
GO

-- Create BenefitType table
CREATE TABLE BenefitType (
  BenefitTypeId INT IDENTITY(1,1) PRIMARY KEY,
  Type VARCHAR(255) NOT NULL
);
GO

-- Create State table
CREATE TABLE State (
  StateId INT IDENTITY(1,1) PRIMARY KEY,
  StateName VARCHAR(255) NOT NULL
);
GO

-- Create Country table
CREATE TABLE Country (
  CountryId INT IDENTITY(1,1) PRIMARY KEY,
  CountryName VARCHAR(255) NOT NULL
);
GO

-- Create Address table
CREATE TABLE Address (
  AddressId INT IDENTITY(1,1) PRIMARY KEY,
  Street1 VARCHAR(255) NOT NULL,
  Street2 VARCHAR(255),
  City VARCHAR(255) NOT NULL,
  StateId INT NOT NULL,
  ZIP VARCHAR(10) NOT NULL,
  CountryId INT NOT NULL,
  FOREIGN KEY (StateId) REFERENCES State(StateId),
  FOREIGN KEY (CountryId) REFERENCES Country(CountryId)
);
GO

-- Create Race table
CREATE TABLE Race (
  RaceId INT IDENTITY(1,1) PRIMARY KEY,
  Type VARCHAR(255) NOT NULL
);
GO

-- Create Gender table
CREATE TABLE Gender (
  GenderId INT IDENTITY(1,1) PRIMARY KEY,
  Type VARCHAR(255) NOT NULL
);
GO

-- Create User table
CREATE TABLE User (
  UserId INT IDENTITY(1,1) PRIMARY KEY,
  NTID VARCHAR(255) NOT NULL,
  FirstName VARCHAR(255) NOT NULL,
  MiddleI VARCHAR(255),
  LastName VARCHAR(255) NOT NULL,
  Password VARCHAR(255) NOT NULL,
  GenderId INT NOT NULL,
  RaceId INT NOT NULL,
  DOB DATE,
  SSN VARCHAR(11) NOT NULL,
  MailAddressId INT NOT NULL,
  HomeAddressId INT NOT NULL,
  Cell VARCHAR(20),
  Email VARCHAR(255) NOT NULL,
  FOREIGN KEY (MailAddressId) REFERENCES Address(AddressId),
  FOREIGN KEY (RaceId) REFERENCES Race(RaceId),
  FOREIGN KEY (GenderId) REFERENCES Gender(GenderId),
  FOREIGN KEY (HomeAddressId) REFERENCES Address(AddressId)
);
GO

-- Create EmployeeInfo table
CREATE TABLE EmployeeInfo (
  EmployeeId INT PRIMARY KEY,
  AnnualSalary DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (EmployeeId) REFERENCES [User](UserId)
);

-- CREATE TABLE EmployeeInfo (
--   EmployeeId INT IDENTITY(1,1) PRIMARY KEY,
--   AnnualSalary DECIMAL(10, 2) NOT NULL,
--   FOREIGN KEY (EmployeeId) REFERENCES [User](UserId)
-- );
GO

-- Create EmployeeBenefits table
CREATE TABLE EmployeeBenefits (
  BenefitTypeId INT NOT NULL,
  EmployeeId INT NOT NULL,
  BenefitCoverageId INT NOT NULL,
  EmployeePremium DECIMAL(10, 2) NOT NULL,
  EmployerPremium DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (BenefitTypeId, EmployeeId, BenefitCoverageId),
  FOREIGN KEY (BenefitCoverageId) REFERENCES BenefitCoverage(BenefitCoverageId),
  FOREIGN KEY (BenefitTypeId) REFERENCES BenefitType(BenefitTypeId),
  FOREIGN KEY (EmployeeId) REFERENCES EmployeeInfo(EmployeeId)
);
GO

-- Create StudentType table
CREATE TABLE StudentType (
  StudentTypeId INT IDENTITY(1,1) PRIMARY KEY,
  StudentType VARCHAR(255) NOT NULL
);
GO

-- Create StudentStatus table
CREATE TABLE StudentStatus (
  StudentStatusId INT IDENTITY(1,1) PRIMARY KEY,
  StudentStatus VARCHAR(255) NOT NULL
);
GO

-- Create Student table
CREATE TABLE Student (
  StudentId INT PRIMARY KEY,
  StudentTypeId INT NOT NULL,
  StudentStatusId INT NOT NULL,
  IsGraduate BIT NOT NULL,
  FOREIGN KEY (StudentStatusId) REFERENCES StudentStatus(StudentStatusId),
  FOREIGN KEY (StudentId) REFERENCES [User](UserId),
  FOREIGN KEY (StudentTypeId) REFERENCES StudentType(StudentTypeId)
);

GO

-- Create Department table
CREATE TABLE Department (
  DepartmentId INT IDENTITY(1,1) PRIMARY KEY,
  DepartmentName VARCHAR(255) NOT NULL,
  Description VARCHAR(255)
);
GO

-- Create CourseSub table
CREATE TABLE CourseSub (
  CourseCode VARCHAR(10) PRIMARY KEY,
  Description VARCHAR(255)
);
GO

-- Create CourseLevel table
CREATE TABLE CourseLevel (
  CourseLevelId INT IDENTITY(1,1) PRIMARY KEY,
  Number INT NOT NULL
);
GO

-- Create CourseCatalogue table
CREATE TABLE CourseCatalogue (
  CourseCode VARCHAR(10) NOT NULL,
  CourseNumber VARCHAR(10) NOT NULL,
  CourseTitle VARCHAR(255) NOT NULL,
  Description VARCHAR(255),
  DepartmentId INT NOT NULL,
  CourseLevelId INT NOT NULL,
  CreditHours DECIMAL(5, 2) NOT NULL,
  PRIMARY KEY (CourseCode, CourseNumber),
  FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId),
  FOREIGN KEY (CourseCode) REFERENCES CourseSub(CourseCode),
  FOREIGN KEY (CourseLevelId) REFERENCES CourseLevel(CourseLevelId)
);
GO

-- Create Prerequisites table
CREATE TABLE Prerequisites (
  PrereqId INT IDENTITY(1,1) PRIMARY KEY,
  ParentCode VARCHAR(10) NOT NULL,
  ParentNumber VARCHAR(10) NOT NULL,
  ChildCode VARCHAR(10) NOT NULL,
  ChildNumber VARCHAR(10) NOT NULL,
  FOREIGN KEY (ParentCode, ParentNumber) REFERENCES CourseCatalogue(CourseCode, CourseNumber),
  FOREIGN KEY (ChildCode, ChildNumber) REFERENCES CourseCatalogue(CourseCode, CourseNumber)
);
GO

-- Create College table
CREATE TABLE College (
  CollegeId INT IDENTITY(1,1) PRIMARY KEY,
  CollegeName VARCHAR(255) NOT NULL
);
GO

-- Create MajorMinor table
CREATE TABLE MajorMinor (
  FieldId INT IDENTITY(1,1) PRIMARY KEY,
  CollegeId INT NOT NULL,
  FieldName VARCHAR(255) NOT NULL,
  FOREIGN KEY (CollegeId) REFERENCES College(CollegeId)
);
GO

-- Create Buildings table
CREATE TABLE Buildings (
  BuildingId INT IDENTITY(1,1) PRIMARY KEY,
  BuildingName VARCHAR(255) NOT NULL,
  NumberOfClasses INT NOT NULL,
  NumberOfLevels INT NOT NULL
);
GO

-- Create EnrollmentStatus table
CREATE TABLE EnrollmentStatus (
  EnrollmentStatusId INT IDENTITY(1,1) PRIMARY KEY,
  EnrollmentStatus VARCHAR(255) NOT NULL
);
GO

-- Create Classroom table
CREATE TABLE Classroom (
  ClassRoomId INT IDENTITY(1,1) PRIMARY KEY,
  BuildingId INT NOT NULL,
  Level INT NOT NULL,
  RoomNumber VARCHAR(10) NOT NULL,
  ProjectorId INT,
  Capacity INT NOT NULL,
  FOREIGN KEY (BuildingId) REFERENCES Buildings(BuildingId)
);
GO

-- Create SemesterType table
CREATE TABLE SemesterType (
  SemesterTypeId INT IDENTITY(1,1) PRIMARY KEY,
  SemesterType VARCHAR(255) NOT NULL
);
GO

-- Create SemesterInfo table
CREATE TABLE SemesterInfo (
  SemesterId INT IDENTITY(1,1) PRIMARY KEY,
  SemesterTypeId INT NOT NULL,
  Year INT NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  FOREIGN KEY (SemesterTypeId) REFERENCES SemesterType(SemesterTypeId)
);
GO

-- Create CourseSchedule table
CREATE TABLE CourseSchedule (
  CRN INT IDENTITY(1,1) PRIMARY KEY,
  CourseCode VARCHAR(10) NOT NULL,
  CourseNumber VARCHAR(10) NOT NULL,
  Section VARCHAR(255) NOT NULL,
  SemesterId INT NOT NULL,
  ClassRoomId INT NOT NULL,
  FOREIGN KEY (CourseCode, CourseNumber) REFERENCES CourseCatalogue(CourseCode, CourseNumber),
  FOREIGN KEY (ClassRoomId) REFERENCES Classroom(ClassRoomId),
  FOREIGN KEY (SemesterId) REFERENCES SemesterInfo(SemesterId)
);
GO

-- Create CourseEnrollment table
CREATE TABLE CourseEnrollment (
  StudentId INT NOT NULL,
  CRN INT NOT NULL,
  EnrollmentStatusId INT NOT NULL,
  MidTermGrade DECIMAL(5, 2) NOT NULL,
  FinalGrade DECIMAL(5, 2) NOT NULL,
  PRIMARY KEY (StudentId, CRN),
  FOREIGN KEY (EnrollmentStatusId) REFERENCES EnrollmentStatus(EnrollmentStatusId),
  FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN),
  FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);
GO

-- Create CourseDailySchedule table
CREATE TABLE CourseDailySchedule (
  DailyId INT IDENTITY(1,1) PRIMARY KEY,
  CRN INT NOT NULL,
  DayOfWeek VARCHAR(20) NOT NULL,
  StartHour INT NOT NULL,
  StartMinute INT NOT NULL,
  EndHour INT NOT NULL,
  EndMinute INT NOT NULL,
  FOREIGN KEY (CRN) REFERENCES CourseSchedule(CRN)
);
GO

-- Create JobInfo table
CREATE TABLE JobInfo (
  JobId INT IDENTITY(1,1) PRIMARY KEY,
  JobTitle VARCHAR(255) NOT NULL,
  JobDescription TEXT,
  MinPay DECIMAL(10, 2) NOT NULL,
  MaxPay DECIMAL(10, 2) NOT NULL,
  IsFaculty BIT NOT NULL,
  JobTypeDetailId INT NOT NULL,
  FOREIGN KEY (JobTypeDetailId) REFERENCES JobTypeDetail(JobTypeDetailId)
);


-- Create EmployeeCourse table
CREATE TABLE EmployeeCourse (
  CRN INT NOT NULL,
  EmployeeId INT NOT NULL,
  PRIMARY KEY (CRN, EmployeeId)
);


-- Create StudentFieldOfStudy table
CREATE TABLE StudentFieldOfStudy (
  StudentId INT NOT NULL,
  FieldId INT NOT NULL,
  Major VARCHAR(255) NOT NULL,
  PRIMARY KEY (StudentId, FieldId),
  FOREIGN KEY (FieldId) REFERENCES MajorMinor(FieldId),
  FOREIGN KEY (StudentId) REFERENCES Student(StudentId)
);


-- Create EmployeeJobs table
CREATE TABLE EmployeeJobs (
  JobId INT NOT NULL,
  EmployeeId INT NOT NULL,
  FOREIGN KEY (JobId) REFERENCES JobInfo(JobId),
  FOREIGN KEY (EmployeeId) REFERENCES EmployeeInfo(EmployeeId)
);


-- Create JobTypeDetail table
CREATE TABLE JobTypeDetail (
  JobTypeDetailId INT IDENTITY(1,1) PRIMARY KEY,
  JobType VARCHAR(255) NOT NULL,
  Description TEXT,
);



-- Insert dummy data into BenefitCoverage table
INSERT INTO BenefitCoverage (Type) VALUES
  ('Medical'),
  ('Dental'),
  ('Vision'),
  ('Life'),
  ('Disability'),
  ('Retirement'),
  ('Paid Time Off'),
  ('Flexible Spending Account'),
  ('Health Savings Account'),
  ('Education Assistance');

-- Insert dummy data into BenefitType table
INSERT INTO BenefitType (Type) VALUES
  ('Health Insurance'),
  ('Wellness Programs'),
  ('Retirement Plans'),
  ('Flexible Benefits'),
  ('Paid Time Off');

-- Insert dummy data into State table
INSERT INTO State (StateName) VALUES
  ('New York'),
  ('California'),
  ('Texas'),
  ('Florida'),
  ('Illinois'),
  ('Pennsylvania'),
  ('Ohio'),
  ('Michigan'),
  ('Georgia'),
  ('North Carolina'),
  ('Quebec'),
  ('Manchester'),
  ('Melbourne'),
  ('Hamburg'),
  ('Lyon'),
  ('Barcelona'),
  ('Mumbai'),
  ('Shanghai'),
  ('Rio de Janeiro');

-- Insert dummy data into Country table
INSERT INTO Country (CountryName) VALUES
  ('United States'),
  ('Canada'),
  ('United Kingdom'),
  ('Australia'),
  ('Germany'),
  ('France'),
  ('Spain'),
  ('India'),
  ('China'),
  ('Brazil');

-- Insert dummy data into Address table
INSERT INTO Address (Street1, City, StateId, ZIP, CountryId)
VALUES
  ('123 Maryland St', 'Syracuse', 1, '13210', 1),
  ('456 Euclid St', 'Syracuse', 1, '13210', 1),
  ('789 Walnut St', 'Syracuse', 1, '13210', 1),
  ('101 Westcott St', 'Syracuse', 1, '13210', 1),
  ('202 Ackerman St', 'Syracuse', 1, '13210', 1),
  ('303 Lanchester St', 'Syracuse', 1, '13210', 1),
  ('404 Southbeach St', 'Syracuse', 1, '13210', 1),
  ('505 Maple St', 'Syracuse', 1, '13210', 1),
  ('606 Spruce St', 'Syracuse', 1, '13210', 1),
  ('707 Oak St', 'Syracuse', 1, '13210', 1);


-- Insert dummy data into Race table
INSERT INTO Race (Type) VALUES
  ('Caucasian'),
  ('African American'),
  ('Asian'),
  ('Hispanic'),
  ('Native American'),
  ('Other');

-- Insert dummy data into Gender table
INSERT INTO Gender (Type) VALUES
  ('Male'),
  ('Female'),
  ('Other');

-- Insert dummy data into User table
INSERT INTO User (NTID, FirstName, MiddleI, LastName, Password, GenderId, RaceId, DOB, SSN, MailAddressId, HomeAddressId, Cell, Email) VALUES
('ypatel', 'Yash', 'A', 'Patel', 'password1', 1, 2, '1995-06-15', '123-45-6789', 1, 1, '123-456-7890', 'yash@syr.edu'),
('araj', 'Anant', 'R', 'Rajpurohit', 'password2', 1, 1, '1996-08-20', '987-65-4321', 2, 2, '987-654-3210', 'anant@syr.edu'),
('swade', 'Shilpa', 'W', 'Wade', 'password3', 2, 3, '1997-02-10', '234-56-7890', 3, 3, '234-567-8901', 'shilpa@syr.edu'),
('kshah', 'Kanya', 'S', 'Shah', 'password4', 2, 2, '1998-11-30', '543-21-6789', 4, 4, '543-216-7890', 'kanya@syr.edu'),
('pshah', 'Preet', 'K', 'Shah', 'password5', 1, 1, '1999-07-25', '456-78-9012', 5, 5, '456-789-0123', 'preet@syr.edu'),
('sthakkur', 'Sohan', 'T', 'Thakkur', 'password6', 1, 4, '2000-04-14', '654-32-1098', 6, 6, '654-321-0987', 'sohan@syr.edu'),
('sdesai', 'Shubham', 'D', 'Desai', 'password7', 1, 5, '2001-01-03', '987-65-4321', 7, 7, '987-654-3210', 'shubham@syr.edu'),
('rshah', 'Rutvi', 'S', 'Shah', 'password8', 2, 1, '1997-09-12', '234-56-7890', 8, 8, '234-567-8901', 'rutvi@syr.edu'),
('jganatra', 'Jay', 'G', 'Ganatra', 'password9', 1, 2, '1998-06-05', '543-21-6789', 9, 9, '543-216-7890', 'jay@syr.edu'),
('msharma', 'Mihir', 'S', 'Sharma', 'password10', 1, 3, '1999-03-18', '456-78-9012', 10, 10, '456-789-0123', 'mihir@syr.edu'),
('hsharma', 'Humpty', 'S', 'Sharma', 'password11', 1, 2, '1996-07-22', '234-56-1111', 1, 1, '234-567-1111', 'humpty@syr.edu'),
('rshah', 'Rushali', 'R', 'Shah', 'password12', 2, 4, '1997-10-15', '543-21-2222', 2, 2, '543-216-2222', 'rushali@syr.edu');


-- Insert dummy data into EmployeeInfo table
INSERT INTO EmployeeInfo (EmployeeId, AnnualSalary)
VALUES
  (24, 8000.00),
  (25, 8100.00),
  (26, 8200.00),
  (27, 8300.00),
  (28, 8400.00),
  (29, 8500.00),
  (30, 8600.00),
  (31, 8700.00),
  (32, 8800.00),
  (33, 8900.00);



-- Insert dummy data into EmployeeBenefits table
INSERT INTO EmployeeBenefits (BenefitTypeId, EmployeeId, BenefitCoverageId, EmployeePremium, EmployerPremium)
VALUES
  (1, 24, 1, 100.00, 400.00),
  (1, 25, 2, 120.00, 410.00),
  (2, 26, 3, 80.00, 350.00),
  (2, 27, 4, 90.00, 380.00),
  (3, 28, 5, 110.00, 420.00),
  (3, 29, 6, 95.00, 400.00),
  (4, 30, 7, 75.00, 320.00),
  (4, 31, 8, 85.00, 340.00),
  (5, 32, 9, 65.00, 280.00),
  (5, 33, 10, 70.00, 290.00);


-- Insert dummy data into StudentType table
INSERT INTO StudentType (StudentType) VALUES
  ('Undergraduate'),
  ('Graduate');

-- Insert dummy data into StudentStatus table
INSERT INTO StudentStatus (StudentStatus) VALUES
  ('Enrolled'),
  ('On Leave'),
  ('Graduated'),
  ('Suspended'),
  ('Withdrawn');

-- Insert dummy data into Student table
INSERT INTO Student (StudentId, StudentTypeId, StudentStatusId, IsGraduate)
VALUES
  (24, 1, 1, 0),
  (25, 1, 1, 0),
  (26, 1, 3, 1),
  (27, 1, 2, 0),
  (28, 1, 1, 0),
  (29, 2, 1, 0),
  (30, 2, 2, 0),
  (31, 2, 1, 0),
  (32, 2, 4, 0),
  (33, 2, 1, 0);


-- Insert dummy data into Department table
INSERT INTO Department (DepartmentName, Description) VALUES
  ('Computer Science', 'Department of Computer Science'),
  ('Engineering', 'Department of Engineering'),
  ('Business Administration', 'Department of Business Administration'),
  ('Biology', 'Department of Biology'),
  ('History', 'Department of History');

-- Insert dummy data into CourseSub table
INSERT INTO CourseSub (CourseCode, Description) VALUES
  ('CSCI', 'Computer Science'),
  ('MATH', 'Mathematics'),
  ('CHEM', 'Chemistry'),
  ('PHYS', 'Physics'),
  ('HIST', 'History');

-- Insert dummy data into CourseLevel table
INSERT INTO CourseLevel (Number) VALUES
  (100),
  (200),
  (300),
  (400),
  (500);

-- Insert dummy data into CourseCatalogue table
INSERT INTO CourseCatalogue (CourseCode, CourseNumber, CourseTitle, Description, DepartmentId, CourseLevelId, CreditHours) VALUES
  ('CSCI', '101', 'Introduction to Programming', 'Basic programming concepts', 1, 1, 3.0),
  ('CSCI', '201', 'Data Structures', 'Data structure fundamentals', 1, 2, 3.0),
  ('MATH', '101', 'Calculus I', 'Introduction to calculus', 2, 3, 4.0),
  ('CHEM', '101', 'General Chemistry', 'Fundamental principles of chemistry', 3, 4, 4.0),
  ('PHYS', '101', 'Physics for Scientists', 'Introductory physics course', 4, 5, 4.0),
  ('HIST', '101', 'World History', 'Survey of world history', 5, 1, 3.0),
  ('CSCI', '301', 'Database Management', 'Database systems and design', 1, 2, 3.0),
  ('MATH', '201', 'Linear Algebra', 'Linear algebra concepts', 2, 3, 3.0),
  ('CHEM', '201', 'Organic Chemistry', 'Organic chemistry principles', 3, 4, 4.0),
  ('PHYS', '201', 'Electromagnetism', 'Electromagnetic principles', 4, 5, 4.0);


-- Insert dummy data into Prerequisites table
INSERT INTO Prerequisites (ParentCode, ParentNumber, ChildCode, ChildNumber) VALUES
  ('CSCI', '201', 'CSCI', '101'),
  ('MATH', '201', 'MATH', '101'),
  ('CHEM', '201', 'CHEM', '101'),
  ('PHYS', '201', 'PHYS', '101');

-- Insert dummy data into College table
INSERT INTO College (CollegeName) VALUES
  ('College of Science'),
  ('College of Engineering'),
  ('School of Business'),
  ('College of Arts and Sciences'),
  ('School of History');

-- Insert dummy data into MajorMinor table
INSERT INTO MajorMinor (CollegeId, FieldName) VALUES
  (1, 'Computer Science'),
  (2, 'Mechanical Engineering'),
  (3, 'Business Administration'),
  (4, 'Biology'),
  (5, 'History');

-- Insert dummy data into Buildings table
INSERT INTO Buildings (BuildingName, NumberOfClasses, NumberOfLevels) VALUES
  ('Engineering Building', 15, 5),
  ('Science Hall', 10, 4),
  ('Business Center', 12, 3),
  ('Liberal Arts Building', 8, 4),
  ('History Tower', 6, 2);

-- Insert dummy data into EnrollmentStatus table
INSERT INTO EnrollmentStatus (EnrollmentStatus) VALUES
  ('Registered'),
  ('Waitlisted'),
  ('Dropped'),
  ('Completed'),
  ('Failed');

-- Insert dummy data into Classroom table
INSERT INTO Classroom (BuildingId, Level, RoomNumber, ProjectorId, Capacity) VALUES
  (1, 1, '101', 1, 50),
  (1, 2, '201', 2, 40),
  (2, 1, '101', 3, 60),
  (2, 2, '201', 4, 30),
  (3, 1, '101', 5, 70),
  (3, 2, '201', 6, 35),
  (4, 1, '101', 7, 55),
  (4, 2, '201', 8, 45),
  (5, 1, '101', 9, 25),
  (5, 2, '201', 10, 20);

-- Insert dummy data into SemesterType table
INSERT INTO SemesterType (SemesterType) VALUES
  ('Fall'),
  ('Spring'),
  ('Summer');

-- Insert dummy data into SemesterInfo table
INSERT INTO SemesterInfo (SemesterTypeId, Year, StartDate, EndDate) VALUES
  (1, 2023, '2023-08-28', '2023-12-15'),
  (2, 2023, '2024-01-15', '2024-05-05'),
  (3, 2023, '2023-06-05', '2023-08-10');

-- Insert dummy data into CourseSchedule table
INSERT INTO CourseSchedule (CourseCode, CourseNumber, Section, SemesterId, ClassRoomId) VALUES
  ('CSCI', '101', '001', 1, 1),
  ('CSCI', '201', '001', 2, 2),
  ('MATH', '101', '001', 1, 3),
  ('CHEM', '101', '001', 2, 4),
  ('PHYS', '101', '001', 1, 5),
  ('HIST', '101', '001', 2, 6),
  ('CSCI', '301', '001', 1, 7),
  ('MATH', '201', '001', 2, 8),
  ('CHEM', '201', '001', 1, 9),
  ('PHYS', '201', '001', 2, 10);

-- Insert dummy data into CourseEnrollment table
INSERT INTO CourseEnrollment (StudentId, CRN, EnrollmentStatusId, MidTermGrade, FinalGrade) VALUES
  (24, 1, 1, 90.0, 92.5),   -- Registered
  (25, 2, 2, NULL, NULL),   -- Waitlisted
  (26, 3, 3, NULL, NULL),   -- Dropped
  (27, 4, 4, 85.5, 88.0),  -- Completed
  (28, 5, 5, 45.0, 40.0),  -- Failed (grades less than 50)
  (29, 6, 1, 89.5, 92.0),  -- Registered
  (30, 7, 2, NULL, NULL),   -- Waitlisted
  (31, 8, 3, NULL, NULL),   -- Dropped
  (32, 9, 4, 90.5, 93.0),  -- Completed
  (33, 10, 5, 46.0, 49.0); -- Failed (grades less than 50)


-- Insert dummy data into CourseDailySchedule table
INSERT INTO CourseDailySchedule (CRN, DayOfWeek, StartHour, StartMinute, EndHour, EndMinute) VALUES
  (1, 'Monday', 9, 0, 10, 30),
  (1, 'Wednesday', 9, 0, 10, 30),
  (2, 'Tuesday', 13, 30, 15, 0),
  (2, 'Thursday', 13, 30, 15, 0),
  (3, 'Monday', 10, 30, 12, 0),
  (3, 'Wednesday', 10, 30, 12, 0),
  (4, 'Tuesday', 15, 0, 16, 30),
  (4, 'Thursday', 15, 0, 16, 30),
  (5, 'Monday', 8, 0, 9, 30),
  (5, 'Wednesday', 8, 0, 9, 30);

-- Insert dummy data into JobInfo table
INSERT INTO JobInfo (JobTitle, JobDescription, MinPay, MaxPay, IsFaculty, JobTypeDetailId) VALUES
  ('Software Engineer', 'Develop software applications', 80000.00, 95000.00, 0, 1),
  ('Mechanical Engineer', 'Design mechanical systems', 80000.00, 100000.00, 0, 2),
  ('Business Analyst', 'Analyze business processes', 80000.00, 90000.00, 0, 3),
  ('Biologist', 'Study living organisms', 80000.00, 100000.00, 1, 3),
  ('Historian', 'Research and teach history', 80000.00, 95000.00, 1, 3),
  ('Data Scientist', 'Analyze and interpret complex data', 80000.00, 100000.00, 0, 1),
  ('Electrical Engineer', 'Design electrical systems', 80000.00, 98000.00, 0, 2),
  ('Marketing Manager', 'Plan and execute marketing strategies', 85000.00, 95000.00, 0, 3),
  ('Chemist', 'Research and analyze chemicals', 80000.00, 95000.00, 0, 3),
  ('Archivist', 'Manage and preserve historical documents', 80000.00, 92000.00, 1, 3);

-- Insert dummy data into EmployeeCourse table
INSERT INTO EmployeeCourse (CRN, EmployeeId) VALUES
  (1, 24),
  (2, 25),
  (3, 26),
  (4, 27),
  (5, 28),
  (6, 29),
  (7, 30),
  (8, 31),
  (9, 32),
  (10, 33);


-- Insert dummy data into StudentFieldOfStudy table
INSERT INTO StudentFieldOfStudy (StudentId, FieldId, Major) VALUES
  (24, 1, 'Computer Science'),
  (25, 2, 'Mechanical Engineering'),
  (26, 3, 'Business Administration'),
  (27, 4, 'Biology'),
  (28, 5, 'History'),
  (29, 1, 'Computer Science'),
  (30, 2, 'Mechanical Engineering'),
  (31, 3, 'Business Administration'),
  (32, 4, 'Biology'),
  (33, 5, 'History');


-- Insert dummy data into EmployeeJobs table
INSERT INTO EmployeeJobs (JobId, EmployeeId) VALUES
  (5, 24),
  (6, 25),
  (7, 26),
  (8, 27),
  (9, 28),
  (10, 29),
  (11, 30),
  (12, 31),
  (13, 32),
  (14, 33);


-- Insert dummy data into JobTypeDetail table
INSERT INTO JobTypeDetail (JobType, Description) VALUES
  ('Full-Time', 'Full-time employment'),
  ('Part-Time', 'Part-time employment'),
  ('Contract', 'Contract-based employment');

COMMIT;




SELECT * FROM ypatel02.BenefitCoverage;
SELECT * FROM ypatel02.BenefitType;
SELECT * FROM ypatel02.State;
SELECT * FROM ypatel02.Country;
SELECT * FROM ypatel02.Address;
SELECT * FROM ypatel02.Race;
SELECT * FROM ypatel02.Gender;
SELECT * FROM ypatel02.User;
SELECT * FROM ypatel02.EmployeeInfo;
SELECT * FROM ypatel02.EmployeeBenefits;
SELECT * FROM ypatel02.StudentType;
SELECT * FROM ypatel02.StudentStatus;
SELECT * FROM ypatel02.Student;
SELECT * FROM ypatel02.Department;
SELECT * FROM ypatel02.CourseSub;
SELECT * FROM ypatel02.CourseLevel;
SELECT * FROM ypatel02.CourseCatalogue;
SELECT * FROM ypatel02.Prerequisites;
SELECT * FROM ypatel02.College;
SELECT * FROM ypatel02.MajorMinor;
SELECT * FROM ypatel02.Buildings;
SELECT * FROM ypatel02.EnrollmentStatus;
SELECT * FROM ypatel02.Classroom;
SELECT * FROM ypatel02.SemesterType;
SELECT * FROM ypatel02.SemesterInfo;
SELECT * FROM ypatel02.CourseSchedule;
SELECT * FROM ypatel02.CourseEnrollment;
SELECT * FROM ypatel02.CourseDailySchedule;
SELECT * FROM ypatel02.JobInfo;
SELECT * FROM ypatel02.EmployeeCourse;
SELECT * FROM ypatel02.StudentFieldOfStudy;
SELECT * FROM ypatel02.EmployeeJobs;
SELECT * FROM ypatel02.JobTypeDetail;
