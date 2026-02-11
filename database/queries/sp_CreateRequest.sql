CREATE PROCEDURE sp_CreateRequest
    @CustomerID INT,
    @Subject NVARCHAR(200),
    @Source NVARCHAR(50)
AS
BEGIN
    INSERT INTO Request (CustomerID, Subject, RequestSource, Status, RequestDate)
    VALUES (@CustomerID, @Subject, @Source, 'New', GETDATE());
END;
