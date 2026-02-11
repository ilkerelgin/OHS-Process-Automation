CREATE TRIGGER trg_CloseRequestOnProposalApproval
ON Proposal
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Status)
    BEGIN
        UPDATE Request
        SET Status = 'Closed'
        FROM Request r
        INNER JOIN inserted i ON r.RequestID = i.RequestID
        WHERE i.Status = 'Approved';
    END
END;
