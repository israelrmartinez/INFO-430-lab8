# INFO-430-lab8
 
## Canvas Assignment Instructions

Be prepared to diagram, code and populate a database 4 entities (STUDENT, UNIT, BUILDING and LEASE).

After creating all the tables and populating the look-up tables with three rows each, be prepared to write the following:

1) Write the SQL code to create a stored procedure to get StudentID when provided a StudentFname, StudentLname and BirthDate.

2) Write the SQL code to create a stored procedure that gets UnitID when provided UnitName.

3) Write the SQL code to create a stored procedure that conducts an explicit transaction INSERT INTO the LEASE table (and leverages nested stored procedures created above) when provided Fname, Lname, BirthDate, UnitName, BeginDate, MonthlyPayment and EndDate

4) Include error-handling that terminates the processing immediately if the student is younger than 21 at the time of the Lease and the duration of the lease is greater than 1 year.