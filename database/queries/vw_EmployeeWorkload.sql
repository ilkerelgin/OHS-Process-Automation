CREATE VIEW vw_EmployeeWorkload AS
SELECT 
    E.EmployeeID,
    E.EmployeeName,
    E.Role,
    COUNT(SO.ServiceOrderID) AS TotalAssignments,
    SUM(CASE WHEN SO.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedJobs,
    SUM(CASE WHEN SO.Status = 'Scheduled' THEN 1 ELSE 0 END) AS PendingJobs
FROM Employee E
LEFT JOIN ServiceOrder SO ON E.EmployeeID = SO.EmployeeID
WHERE E.IsActive = 1
GROUP BY E.EmployeeID, E.EmployeeName, E.Role;
GO
