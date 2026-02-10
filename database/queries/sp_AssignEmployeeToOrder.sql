CREATE PROCEDURE sp_AssignEmployeeToOrder
    @ServiceOrderID INT,
    @EmployeeID INT,
    @ScheduleDate DATETIME
AS
BEGIN
    UPDATE ServiceOrder
    SET EmployeeID = @EmployeeID,
        ScheduledDate = @ScheduleDate,
        Status = 'Scheduled'
    WHERE ServiceOrderID = @ServiceOrderID;
END;
GO
