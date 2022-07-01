Use master
go

If Exists(Select Name from SysDatabases Where Name = 'israelma_Lab8')
 Begin 
  Alter Database [israelma_Lab8] set Single_user With Rollback Immediate;
  Drop Database israelma_Lab8;
 End
go

CREATE DATABASE israelma_Lab8
go

Use israelma_Lab8;
go

--Be prepared to diagram, code and populate a database 4 entities 
-- (STUDENT, UNIT, BUILDING and LEASE).
CREATE TABLE tblSTUDENT
(StudentID int IDENTITY(1,1) PRIMARY KEY
,StudentFName varchar(20) not null
,StudentLName varchar(20) not null
,StudentDOB date not null
)
go

CREATE TABLE tblBUILDING
(BuildingID int IDENTITY(1,1) PRIMARY KEY
,BuildingName varchar(20)
,BuildingDesc varchar(500)
)
GO

CREATE TABLE tblUNIT
(UnitID int IDENTITY(1,1) PRIMARY KEY
,UnitName varchar(20) not null
,BuildingID int FOREIGN KEY REFERENCES tblBUILDING (BuildingID) not null
)
go

CREATE TABLE tblLEASE
(LeaseID int IDENTITY(1,1) PRIMARY KEY
,StudentID int FOREIGN KEY REFERENCES tblSTUDENT (StudentID) 
,UnitID int FOREIGN KEY REFERENCES tblUNIT (UnitID) not null
,BeginDate date not null
,EndDate date not null
,Payment money not null
)
go

INSERT INTO tblBUILDING VALUES
('Building1', 'Description 1'), ('Building2', 'Description 2'), ('Building3', 'Description 3')
go

INSERT INTO tblUNIT VALUES
('Unit1', '1'), ('Unit2', '1'), ('Unit3', '1')
go

INSERT INTO tblSTUDENT VALUES
('John', 'Smith', '1999-02-02'), ('Jane', 'Doe', '1998-10-02'), ('Sally', 'Roth', '1999-06-12') 
go

--After creating all the tables and populating the look-up tables with three rows each,
-- be prepared to write the following:

--1) Write the SQL code to create a stored procedure to get StudentID when provided a 
-- StudentFname, StudentLname and BirthDate.
CREATE PROCEDURE uspGetStudentID
@FName varchar(20),
@LName varchar(20),
@DOB date,
@Student_ID INT OUTPUT
AS
SET @Student_ID = (SELECT StudentID FROM tblSTUDENT WHERE StudentFName = @FName
AND StudentLName = @LName AND StudentDOB = @DOB)
GO

--2) Write the SQL code to create a stored procedure that gets UnitID when provided 
-- UnitName.
CREATE PROCEDURE uspGetUnitID
@UName varchar(20),
@Unit_ID INT OUTPUT
AS
SET @Unit_ID = (SELECT UnitID FROM tblUNIT WHERE UnitName = @UName)
GO


--3) Write the SQL code to create a stored procedure that conducts an explicit 
-- transaction INSERT INTO the LEASE table (and leverages nested stored procedures 
-- created above) when provided Fname, Lname, BirthDate, UnitName, BeginDate, MonthlyPayment and EndDate
CREATE PROCEDURE israelmaINSERT_LEASE
@Firsty varchar(20),
@Lasty varchar(20),
@Birthy date,
@Unit varchar(20),
@StartDate date,
@LastDate date,
@Rent money
AS DECLARE @S_ID INT, @U_ID INT

EXEC uspGetStudentID
@FName = @Firsty,
@LName = @Lasty,
@DOB = @Birthy,
@Student_ID = @S_ID OUTPUT
IF @S_ID IS NULL
	BEGIN
		PRINT 'Hi... there is an error with @S_ID being NULL'
		RAISERROR ('@S_ID cannot be null', 11,1)
		RETURN
	END

EXEC uspGetUnitID
@UName = @Unit,
@Unit_ID = @U_ID OUTPUT
IF @U_ID IS NULL
	BEGIN
		PRINT 'Hi... there is an error with @U_ID being NULL'
		RAISERROR ('@U_ID cannot be null', 11,1)
		RETURN
	END

--4) Include error-handling that terminates the processing immediately if the student 
-- is younger than 21 at the time of the Lease and the duration of the lease is greater
-- than 1 year.
BEGIN TRY
	BEGIN TRAN G1
	INSERT INTO tblLEASE (StudentID, UnitID, BeginDate, EndDate, Payment)
	VALUES (@S_ID, @U_ID, @StartDate, @LastDate, @Rent)
	END TRY
BEGIN CATCH
	DECLARE @age21 date = '2000-02-28'
	IF @Birthy < @age21 AND DATEDIFF(month, @StartDate, @LastDate) > 12
		PRINT 'Hey... Student younger than 21 and duration of lease is greater than a year'
		RETURN @@ERROR
END CATCH
IF @@ERROR <> 0
	BEGIN
		PRINT 'Hey... there is an error up ahead and I am pulling over'
		ROLLBACK TRAN G1
	END
ELSE
	COMMIT TRAN G1
