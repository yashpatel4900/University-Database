-- Granting Access to GRADERS
GRANT EXECUTE ON SCHEMA::ypatel02 TO Graders;
GRANT SELECT ON SCHEMA::ypatel02 TO Graders;

-- VIEW
-- Create the Benefits view
CREATE VIEW ypatel02.Benefits AS
SELECT
    U.UserId AS EmployeeId,
    U.FirstName + ' ' + U.LastName AS EmployeeName,
    BC.Type AS BenefitType,
    BCov.Type AS BenefitCoverage,
    EB.EmployeePremium,
    EB.EmployerPremium
FROM
    ypatel02.[User] U
JOIN
    ypatel02.EmployeeBenefits EB ON U.UserId = EB.EmployeeId
JOIN
    ypatel02.BenefitType BT ON EB.BenefitTypeId = BT.BenefitTypeId
JOIN
    ypatel02.BenefitCoverage BCov ON EB.BenefitCoverageId = BCov.BenefitCoverageId
JOIN
    ypatel02.BenefitCoverage BC ON BCov.BenefitCoverageId = BC.BenefitCoverageId;
GO

-- Select Statement for Benefits
SELECT * FROM ypatel02.Benefits;



-- 1st STORED PROCEDURES
-- Description - The UpdateSalaryWithJobLogic stored procedure is designed to intelligently adjust the annual 
--               salary of employees based on a set of business rules. This stored procedure utilizes a cursor 
--               to iterate through a result set obtained by joining three tables: EmployeeInfo, User, and 
--               EmployeeJobs. The primary focus is to identify employees aged 25 or older and, for a specific 
--               set of job roles (JobIds 5, 7, 9, 11, 13), grant a 7% increase in their annual salary. For 
--               other job roles, a 5% increase is applied.

CREATE PROCEDURE UpdateSalaryWithJobLogic
AS
BEGIN
    SET NOCOUNT ON;

    -- Cursor's Variables
    DECLARE @EmployeeId INT, @Birthdate DATE, @AnnualSalary DECIMAL(10, 2), @JobId INT;

    -- Declare cursor 
    DECLARE EmployeeCursor CURSOR FOR
    SELECT ei.EmployeeId, u.DOB, ei.AnnualSalary, ej.JobId
    FROM ypatel02.EmployeeInfo ei
    INNER JOIN ypatel02.[User] u ON ei.EmployeeId = u.UserId
    INNER JOIN ypatel02.EmployeeJobs ej ON ei.EmployeeId = ej.EmployeeId;

    -- Open cursor
    OPEN EmployeeCursor;

    -- Fetch first row
    FETCH NEXT FROM EmployeeCursor INTO @EmployeeId, @Birthdate, @AnnualSalary, @JobId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        DECLARE @Age INT;
        SET @Age = DATEDIFF(YEAR, @Birthdate, GETDATE());

        -- Determine the percentage increase based on JobId
        DECLARE @PercentageIncrease DECIMAL(5, 2);
        IF @JobId IN (5, 7, 9, 11, 13)
            SET @PercentageIncrease = 0.07; -- 7% increase for specific JobIds
        ELSE
            SET @PercentageIncrease = 0.05; -- 5% increase for other JobIds

        -- Check if employee is 25 years or older
        IF @Age >= 25
        BEGIN
            -- Update annual salary based on percentage increase
            UPDATE ypatel02.EmployeeInfo
            SET AnnualSalary = AnnualSalary * (1 + @PercentageIncrease)
            WHERE EmployeeId = @EmployeeId;
        END;

        -- Fetch the next row
        FETCH NEXT FROM EmployeeCursor INTO @EmployeeId, @Birthdate, @AnnualSalary, @JobId;
    END;

    CLOSE EmployeeCursor;
    DEALLOCATE EmployeeCursor;

    PRINT 'Salary update with job logic completed.';
END;


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





-- 2nd STORED PROCEDURE
-- Description - This stored procedure is designed to update employee data with robust validation checks. 
--               It takes input parameters such as @EmployeeId (for identifying the employee), 
--               @NewSalary (the updated annual salary), and @NewJobTitle (the updated job title). 
CREATE PROCEDURE UpdateEmployeeDataWithValidation
    @EmployeeId INT,
    @NewSalary DECIMAL(10, 2),
    @NewJobTitle NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if employee exists
    IF NOT EXISTS (SELECT 1 FROM ypatel02.EmployeeInfo WHERE EmployeeId = @EmployeeId)
    BEGIN
        RAISERROR('Employee does not exist.', 16, 1);
        RETURN;
    END;

    -- Validate new salary
    IF @NewSalary < 0
    BEGIN
        RAISERROR('Invalid salary. Salary cannot be negative.', 16, 2);
        RETURN;
    END;

    -- Validate new job title
    IF NOT EXISTS (SELECT 1 FROM ypatel02.JobInfo WHERE JobTitle = @NewJobTitle)
    BEGIN
        RAISERROR('Invalid job title.', 16, 3);
        RETURN;
    END;

    -- Start a transaction
    BEGIN TRANSACTION;

    -- Update EmployeeInfo data
    UPDATE ypatel02.EmployeeInfo
    SET 
        AnnualSalary = @NewSalary
    WHERE EmployeeId = @EmployeeId;

	-- Update EmployeeJobs data
    UPDATE ypatel02.EmployeeJobs
    SET 
        JobId = (SELECT JobId FROM ypatel02.JobInfo WHERE JobTitle = @NewJobTitle)
    WHERE EmployeeId = @EmployeeId;

    -- Check for errors during update
    IF @@ERROR <> 0
    BEGIN
        -- Rollback the transaction if an error occurs
        ROLLBACK TRANSACTION;
        RAISERROR('Error updating employee data.', 16, 4);
    END
    ELSE
    BEGIN
        -- Commit the transaction if update is successful
        COMMIT TRANSACTION;
        PRINT 'Employee data updated successfully.';
    END;
END;

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







-- 3rd STORED PROCEDURE
-- Description - The stored procedure DeleteClassroom is designed to facilitate the secure deletion of a 
--               classroom record from the ypatel02.Classroom table in our project database.
--               Ensure number of classrooms available in a building gets updated accordingly and 
--               sets classroom of claases to be null if that classroom was removed.
CREATE PROCEDURE DeleteClassroom
  @ClassRoomIdToDelete INT
AS
BEGIN
  -- Check ClassRoomId exists 
  IF EXISTS (SELECT 1 FROM ypatel02.Classroom WHERE ClassRoomId = @ClassRoomIdToDelete)
  BEGIN
    BEGIN TRANSACTION;

    -- Update NumberOfClasses in Buildings table
    UPDATE ypatel02.Buildings
    SET NumberOfClasses = NumberOfClasses - 1
    WHERE BuildingId = (SELECT BuildingId FROM ypatel02.Classroom WHERE ClassRoomId = @ClassRoomIdToDelete);

    -- Update CourseSchedule records to set ClassroomId to NULL
    UPDATE ypatel02.CourseSchedule
    SET ClassRoomId = NULL
    WHERE ClassRoomId = @ClassRoomIdToDelete;

    -- Delete the classroom record
    DELETE FROM ypatel02.Classroom
    WHERE ClassRoomId = @ClassRoomIdToDelete;

    COMMIT;
  END
  ELSE
  BEGIN
    RAISERROR('Classroom with specified ClassRoomId does not exist.', 16, 1);
  END
END;

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







-- 4th STORED PROCEDURE
-- Description - The stored procedure UpdateStudentStatusToGrad automates the process of updating a student's 
--               graduation status within the educational system. This checks Grades obtained in  courses enrolled
--               during his study and will not allow to graduate if he has failed one or more subjects.

CREATE PROCEDURE UpdateStudentStatusToGrad
    @StudentId INT
AS
BEGIN
    -- Check if the student exists
    IF NOT EXISTS (SELECT 1 FROM ypatel02.Student WHERE StudentId = @StudentId)
    BEGIN
        PRINT 'Student does not exist.';
        RETURN;
    END

    -- Check if the student has any course enrollments
    IF NOT EXISTS (SELECT 1 FROM ypatel02.CourseEnrollment WHERE StudentId = @StudentId)
    BEGIN
        PRINT 'Student has no course enrollments.';
        RETURN;
    END

    -- Check if all course enrollments have EnrollmentStatusId = 5 (FAILED)
    IF NOT EXISTS (
        SELECT 1
        FROM ypatel02.CourseEnrollment
        WHERE StudentId = @StudentId AND EnrollmentStatusId = 5
    )
    BEGIN
        -- Check if the student is not already in StudentStatusId = 3 (GRADUATED)
        IF (SELECT StudentStatusId FROM ypatel02.Student WHERE StudentId = @StudentId) <> 3
        BEGIN
            -- Update StudentStatusId to 3 in Students table
            UPDATE ypatel02.Student
            SET StudentStatusId = 3,
				IsGraduate = 1
            WHERE StudentId = @StudentId;

            PRINT 'StudentStatus updated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Student is already in StudentStatusId = 3.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Cannot update StudentStatus. Some enrollments have EnrollmentStatusId <> 5.';
    END
END;


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








-- FUNCTION
-- Description - This function, ypatel02.FindAvailableClassrooms, is designed to find available classrooms for 
--               a specified day of the week and time range. It utilizes information from the 
--               ypatel02.Classroom, ypatel02.CourseDailySchedule, and ypatel02.CourseSchedule tables. 
--               The function identifies classrooms that are not scheduled for courses during the specified 
--               period, considering both the end and start times of the courses. Additionally, it handles 
--               cases where ClassRoomId is NULL in the CourseSchedule table. The result is a list of distinct 
--               available ClassRoomIds meeting the given criteria.

CREATE FUNCTION ypatel02.FindAvailableClassrooms (
    @dayofweek NVARCHAR(50),
    @reqStartHour INT,
    @reqStartMin INT,
    @reqEndHour INT,
    @reqEndMin INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT c.ClassRoomId
    FROM ypatel02.Classroom c
    WHERE c.ClassRoomId NOT IN
    (
        SELECT cs.ClassRoomId
        FROM ypatel02.CourseDailySchedule cds
        INNER JOIN ypatel02.CourseSchedule cs ON cds.CRN = cs.CRN
        WHERE cds.DayOfWeek = @dayofweek
            AND cs.ClassRoomId IS NOT NULL 
            AND (
                -- Check if requested time starts before the course schedule ends
                (@reqStartHour * 60 + @reqStartMin) <= (cds.EndHour * 60 + cds.EndMinute)
                -- Check if requested time ends after the course schedule starts
                AND (@reqEndHour * 60 + @reqEndMin) >= (cds.StartHour * 60 + cds.StartMinute)
                -- Check if the requested start time falls within the course schedule
                OR (@reqStartHour * 60 + @reqStartMin) BETWEEN (cds.StartHour * 60 + cds.StartMinute) AND (cds.EndHour * 60 + cds.EndMinute)
            )
    )
);
GO;

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