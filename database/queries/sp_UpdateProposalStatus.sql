CREATE PROCEDURE sp_UpdateProposalStatus
    @ProposalID INT,
    @NewStatus NVARCHAR(20)
AS
BEGIN
    UPDATE Proposal
    SET Status = @NewStatus
    WHERE ProposalID = @ProposalID;
END;
