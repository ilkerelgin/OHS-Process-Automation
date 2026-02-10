-- View 3: Fatura Detayları
CREATE VIEW vw_InvoiceDetails AS
SELECT 
    I.InvoiceID,
    SO.ServiceOrderID,
    C.CustomerName,
    I.InvoiceDate,
    I.SubTotal,
    I.TaxAmount,   
    I.GrandTotal   
FROM Invoice I
INNER JOIN ServiceOrder SO ON I.ServiceOrderID = SO.ServiceOrderID
INNER JOIN Customer C ON SO.CustomerID = C.CustomerID;
GO
