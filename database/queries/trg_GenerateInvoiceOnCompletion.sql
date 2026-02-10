CREATE TRIGGER trg_GenerateInvoiceOnCompletion
ON ServiceOrder
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Status)
    BEGIN
        INSERT INTO Invoice (ServiceOrderID, SubTotal)
        SELECT 
            i.ServiceOrderID,
            p.TotalValue
        FROM inserted i
        INNER JOIN Proposal p ON i.ProposalID = p.ProposalID
        INNER JOIN deleted d ON i.ServiceOrderID = d.ServiceOrderID
        WHERE i.Status = 'Completed'     
          AND d.Status <> 'Completed'    
          AND NOT EXISTS (SELECT 1 FROM Invoice inv WHERE inv.ServiceOrderID = i.ServiceOrderID); 
    END
END;
GO
