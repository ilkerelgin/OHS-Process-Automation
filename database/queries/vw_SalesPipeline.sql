CREATE VIEW vw_SalesPipeline AS
SELECT 
    R.RequestID,
    C.CustomerName,
    R.Subject AS RequestSubject,
    R.RequestDate,
    P.ProposalID,
    P.TotalValue,
    P.Status AS ProposalStatus
FROM Request R
INNER JOIN Customer C ON R.CustomerID = C.CustomerID
LEFT JOIN Proposal P ON R.RequestID = P.RequestID;
GO
