CREATE PROCEDURE sp_GetTotalRevenueByDate
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT 
        COUNT(InvoiceID) AS TotalInvoices,
        SUM(SubTotal) AS TotalRevenueBeforeTax,
        SUM(GrandTotal) AS TotalRevenueWithTax
    FROM Invoice
    WHERE InvoiceDate BETWEEN @StartDate AND @EndDate;
END;
GO
