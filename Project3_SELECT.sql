-- Granting Access to GRADERS
GRANT EXECUTE ON SCHEMA::ypatel02 TO Graders;
GRANT SELECT ON SCHEMA::ypatel02 TO Graders;

-- VIEW      ypatel02.Benefits
SELECT * FROM ypatel02.Benefits;



-- 1st STORED PROCEDURES   UpdateSalaryWithJobLogic

-- Before Updating
SELECT ei.EmployeeId, u.DOB, ei.AnnualSalary, ej.JobId
FROM ypatel02.EmployeeInfo ei
INNER JOIN ypatel02.[User] u ON ei.EmployeeId = u.UserId
INNER JOIN ypatel02.EmployeeJobs ej ON ei.EmployeeId = ej.EmployeeId;

-- Executing Stored Procedure
EXEC ypatel02.UpdateSalaryWithJobLogic;

-- After 
SELECT ei.EmployeeId, u.DOB, ei.AnnualSalary, ej.JobId
FROM ypatel02.EmployeeInfo ei
INNER JOIN ypatel02.[User] u ON ei.EmployeeId = u.UserId
INNER JOIN ypatel02.EmployeeJobs ej ON ei.EmployeeId = ej.EmployeeId;





-- 2nd STORED PROCEDURE       UpdateEmployeeDataWithValidation @EmployeeId INT, @NewSalary DECIMAL(10, 2), @NewJobTitle NVARCHAR(50)

-- Before
SELECT
    EI.EmployeeId,
    EJ.JobId,
    JI.JobTitle,
    EI.AnnualSalary
FROM
    ypatel02.EmployeeInfo EI
JOIN
    ypatel02.EmployeeJobs EJ ON EI.EmployeeId = EJ.EmployeeId
JOIN
    ypatel02.JobInfo JI ON EJ.JobId = JI.JobId;


-- Valid Update: Employee exists, positive salary, and valid job title
EXEC UpdateEmployeeDataWithValidation
    @EmployeeId = 27,
    @NewSalary = 87000.00,
    @NewJobTitle = 'Archivist';

-- After
SELECT
    EI.EmployeeId,
    EJ.JobId,
    JI.JobTitle,
    EI.AnnualSalary
FROM
    ypatel02.EmployeeInfo EI
JOIN
    ypatel02.EmployeeJobs EJ ON EI.EmployeeId = EJ.EmployeeId
JOIN
    ypatel02.JobInfo JI ON EJ.JobId = JI.JobId;


-- Invalid Update: Employee does not exist
EXEC UpdateEmployeeDataWithValidation
    @EmployeeId = 999,
    @NewSalary = 87000.00,
    @NewJobTitle = 'Archivist';

-- Invalid Update: Negative Salary
EXEC UpdateEmployeeDataWithValidation
    @EmployeeId = 27,
    @NewSalary = -5000.00,
    @NewJobTitle = 'Archivist';

-- Invalid Update: Invalid Job Title
EXEC UpdateEmployeeDataWithValidation
    @EmployeeId = 27,
    @NewSalary = 87000.00,
    @NewJobTitle = 'InvalidJobTitle';







-- 3rd STORED PROCEDURE        DeleteClassroom @ClassRoomIdToDelete INT

-- Before
SELECT
    C.ClassRoomID,
    B.BuildingID,
    B.BuildingName,
    B.NumberOfClasses AS NumberOfClassesInBuilding
FROM
    Classroom C
JOIN
    Buildings B ON C.BuildingId = B.BuildingID
ORDER BY
    C.ClassRoomId

-- Execute 
EXEC ypatel02.DeleteClassroom @ClassRoomIdToDelete = 2;

-- After
SELECT BuildingId, NumberOfClasses
FROM ypatel02.Buildings







-- 4th STORED PROCEDURE      UpdateStudentStatusToGrad @StudentId INT

--Before
SELECT C.StudentId, C.CRN, C.EnrollmentStatusId, S.StudentStatusId, S.IsGraduate
FROM CourseEnrollment C
LEFT JOIN Student S ON C.StudentId = S.StudentId;

-- Valid Execution
EXEC UpdateStudentStatusToGrad 24;

-- After
SELECT C.StudentId, C.CRN, C.EnrollmentStatusId, S.StudentStatusId, S.IsGraduate
FROM CourseEnrollment C
LEFT JOIN Student S ON C.StudentId = S.StudentId;

-- Invalid Execution (Student does not exist)
EXEC UpdateStudentStatusToGrad 100;

-- Invalid Execution (Some enrollments have EnrollmentStatusId <> 5) i.e. Student has Failed one or more subjects
EXEC UpdateStudentStatusToGrad 28;

-- Invalid Execution (Student is already in StudentStatusId = 3) i.e. Alread a Graduated Student
EXEC UpdateStudentStatusToGrad 26;

UPDATE Student
SET StudentStatusId = 1, IsGraduate=0
WHERE StudentId = 28;








-- FUNCTION        ypatel02.FindAvailableClassrooms (@dayofweek NVARCHAR(50), @reqStartHour INT, @reqStartMin INT, @reqEndHour INT, @reqEndMin INT)

-- Tables we should know 
SELECT * FROM ypatel02.CourseSchedule;
SELECT * FROM ypatel02.CourseDailySchedule;
-- Disctict Classrooms are 3,4,5,6,7,8,9,10 as classroom 1 and 2 are deleted
SELECT DISTINCT ClassRoomId FROM Classroom;
SELECT * FROM Classroom;

-- Executing Function
-- Checking when occupied by classroom 1 (9-10:30), 5(8-9:30)
SELECT * FROM ypatel02.FindAvailableClassrooms(N'Monday', 9, 10, 10, 10);
-- Checking when all clssrooms are free
SELECT * FROM ypatel02.FindAvailableClassrooms(N'Monday', 14, 10, 15, 30);
-- Checking when occupied by classroom 4 (15-16:30)
SELECT * FROM ypatel02.FindAvailableClassrooms(N'Tuesday', 14, 10, 15, 15);
-- Checking when all clssrooms are free
SELECT * FROM ypatel02.FindAvailableClassrooms(N'Tuesday', 9, 10, 10, 10);