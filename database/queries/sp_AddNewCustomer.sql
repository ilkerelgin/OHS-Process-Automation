CREATE PROCEDURE sp_AddNewCustomer
    @Name NVARCHAR(150),
    @Industry NVARCHAR(50),
    @Address NVARCHAR(255),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @TaxNo NVARCHAR(50)
AS
BEGIN
    INSERT INTO Customer (CustomerName, IndustryType, Address, Email, PhoneNumber, TaxNumber)
    VALUES (@Name, @Industry, @Address, @Email, @Phone, @TaxNo);
END;
