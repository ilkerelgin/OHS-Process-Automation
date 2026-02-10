CREATE PROCEDURE sp_ApproveProposalAndCreateOrder
    @ProposalID INT
AS
BEGIN
    UPDATE Proposal 
    SET Status = 'Approved' 
    WHERE ProposalID = @ProposalID;

    DECLARE @CustID INT;
    SELECT @CustID = R.CustomerID 
    FROM Proposal P 
    JOIN Request R ON P.RequestID = R.RequestID 
    WHERE P.ProposalID = @ProposalID;

    INSERT INTO ServiceOrder (CustomerID, ProposalID, Status, OrderDate)
    VALUES (@CustID, @ProposalID, 'Pending Assignment', GETDATE());
END;
GO
