CREATE PROCEDURE sp_CompleteServiceOrder
    @ServiceOrderID INT
AS
BEGIN
    UPDATE ServiceOrder
    SET Status = 'Completed'
    WHERE ServiceOrderID = @ServiceOrderID;
END;
GO
