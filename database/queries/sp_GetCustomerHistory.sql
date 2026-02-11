
CREATE PROCEDURE sp_GetCustomerHistory
    @CustomerID INT
AS
BEGIN
    SELECT 
        SO.ServiceOrderID,
        P.ProposalID,
        SO.OrderDate,
        SO.Status,
        I.GrandTotal
    FROM ServiceOrder SO
    LEFT JOIN Proposal P ON SO.ProposalID = P.ProposalID
    LEFT JOIN Invoice I ON SO.ServiceOrderID = I.ServiceOrderID
    WHERE SO.CustomerID = @CustomerID
    ORDER BY SO.OrderDate DESC;
END;
