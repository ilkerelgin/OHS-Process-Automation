CREATE VIEW vw_ActiveServiceOrders AS
SELECT 
    SO.ServiceOrderID,
    C.CustomerName,
    P.TotalValue,
    E.EmployeeName AS AssignedPersonnel,
    SO.ScheduledDate,
    SO.Status
FROM ServiceOrder SO
INNER JOIN Customer C ON SO.CustomerID = C.CustomerID
INNER JOIN Proposal P ON SO.ProposalID = P.ProposalID
LEFT JOIN Employee E ON SO.EmployeeID = E.EmployeeID
WHERE SO.Status IN ('Scheduled', 'Pending Assignment');
GO
