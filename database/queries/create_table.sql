

-- =============================================
-- 1. TABLOLARIN OLUŞTURULMASI (TABLES)
-- =============================================

-- Önce temizlik (Varsa eski tabloları sil)
-- Not: Hata almamak için bağımlılık sırasına göre siliyoruz.
IF OBJECT_ID('dbo.Invoice', 'U') IS NOT NULL DROP TABLE dbo.Invoice;
IF OBJECT_ID('dbo.ServiceOrder', 'U') IS NOT NULL DROP TABLE dbo.ServiceOrder;
IF OBJECT_ID('dbo.ProposalServices', 'U') IS NOT NULL DROP TABLE dbo.ProposalServices;
IF OBJECT_ID('dbo.Proposal', 'U') IS NOT NULL DROP TABLE dbo.Proposal;
IF OBJECT_ID('dbo.Request', 'U') IS NOT NULL DROP TABLE dbo.Request;
IF OBJECT_ID('dbo.Service', 'U') IS NOT NULL DROP TABLE dbo.Service;
IF OBJECT_ID('dbo.Customer', 'U') IS NOT NULL DROP TABLE dbo.Customer;
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee;
GO

-- Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) NOT NULL, 
    Certification NVARCHAR(100) NULL,
    Email NVARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1
);
GO

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(150) NOT NULL,
    IndustryType NVARCHAR(50) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    TaxNumber NVARCHAR(50) UNIQUE NOT NULL
);
GO

-- Service Table
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    ServiceType NVARCHAR(50) NOT NULL,
    BasePrice DECIMAL(10, 2) NOT NULL CHECK (BasePrice >= 0)
);
GO

-- Request Table
CREATE TABLE Request (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    Subject NVARCHAR(200) NOT NULL,
    RequestDate DATETIME DEFAULT GETDATE(),
    RequestSource NVARCHAR(50) NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('New', 'Contacted', 'Closed')),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
GO

-- Proposal Table
CREATE TABLE Proposal (
    ProposalID INT PRIMARY KEY IDENTITY(1,1),
    RequestID INT NOT NULL,
    ProposalDate DATETIME DEFAULT GETDATE(),
    ExpiryDate DATETIME NOT NULL,
    TotalValue DECIMAL(10, 2) NOT NULL DEFAULT 0,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Draft', 'Sent', 'Approved', 'Rejected')),
    FOREIGN KEY (RequestID) REFERENCES Request(RequestID)
);
GO

-- ProposalServices Table
CREATE TABLE ProposalServices (
    ProposalID INT NOT NULL,
    ServiceID INT NOT NULL,
    PRIMARY KEY (ProposalID, ServiceID),
    FOREIGN KEY (ProposalID) REFERENCES Proposal(ProposalID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
);
GO

-- ServiceOrder Table
CREATE TABLE ServiceOrder (
    ServiceOrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    ProposalID INT NOT NULL,
    EmployeeID INT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    ScheduledDate DATETIME NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending Assignment' CHECK (Status IN ('Pending Assignment', 'Scheduled', 'Completed', 'Canceled')),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProposalID) REFERENCES Proposal(ProposalID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- Invoice Table (Computed Column Example)
CREATE TABLE Invoice (
    InvoiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceOrderID INT NOT NULL UNIQUE,
    InvoiceDate DATETIME DEFAULT GETDATE(),
    SubTotal DECIMAL(10, 2) NOT NULL,
    TaxRate DECIMAL(4, 2) DEFAULT 0.20,
    TaxAmount AS (SubTotal * TaxRate) PERSISTED, 
    GrandTotal AS (SubTotal * (1 + TaxRate)) PERSISTED,
    FOREIGN KEY (ServiceOrderID) REFERENCES ServiceOrder(ServiceOrderID)
);
GO

-- Indexes
CREATE NONCLUSTERED INDEX IX_Customer_Name ON Customer(CustomerName);
CREATE NONCLUSTERED INDEX IX_ServiceOrder_Status ON ServiceOrder(Status);
GO

-- =============================================
-- 2. VERİ GİRİŞİ (DATA POPULATION)
-- =============================================

-- Employee Data
SET IDENTITY_INSERT Employee ON;
INSERT INTO Employee (EmployeeID, EmployeeName, Role, Certification, Email, IsActive) VALUES
(1, 'Ahmet Yılmaz', 'Safety Expert', 'A Class', 'ahmet@megatrak.com', 1),
(2, 'Ayşe Demir', 'Physician', 'Occ. Physician', 'ayse@megatrak.com', 1),
(3, 'Mehmet Öz', 'Sales', NULL, 'mehmet@megatrak.com', 1),
(4, 'Fatma Kaya', 'Safety Expert', 'B Class', 'fatma@megatrak.com', 1),
(5, 'Ali Vural', 'Safety Expert', 'C Class', 'ali@megatrak.com', 1),
(6, 'Zeynep Çelik', 'Physician', 'Occ. Physician', 'zeynep@megatrak.com', 1),
(7, 'Caner Erkin', 'Sales', NULL, 'caner@megatrak.com', 1),
(8, 'Burak Yılmaz', 'Safety Expert', 'A Class', 'burak@megatrak.com', 1),
(9, 'Selin Şekerci', 'Safety Expert', 'B Class', 'selin@megatrak.com', 0),
(10, 'Onur Saylak', 'Physician', 'Occ. Physician', 'onur@megatrak.com', 1),
(11, 'Elif Doğan', 'Safety Expert', 'C Class', 'elif@megatrak.com', 1),
(12, 'Murat Boz', 'Sales', NULL, 'murat@megatrak.com', 1),
(13, 'Hadise Açıkgöz', 'Safety Expert', 'A Class', 'hadise@megatrak.com', 1),
(14, 'Beyazıt Öztürk', 'Physician', 'Occ. Physician', 'beyazit@megatrak.com', 1),
(15, 'Acun Ilıcalı', 'Sales', NULL, 'acun@megatrak.com', 1),
(16, 'Seda Sayan', 'Safety Expert', 'B Class', 'seda@megatrak.com', 1),
(17, 'Cem Yılmaz', 'Safety Expert', 'C Class', 'cem@megatrak.com', 1),
(18, 'Şahan Gökbakar', 'Physician', 'Occ. Physician', 'sahan@megatrak.com', 1),
(19, 'Demet Akalın', 'Sales', NULL, 'demet@megatrak.com', 1),
(20, 'Tarkan Tevetoğlu', 'Safety Expert', 'A Class', 'tarkan@megatrak.com', 1),
(21, 'Sezen Aksu', 'Safety Expert', 'B Class', 'sezen@megatrak.com', 1),
(22, 'Müslüm Gürses', 'Physician', 'Occ. Physician', 'muslum@megatrak.com', 0),
(23, 'Ferdi Tayfur', 'Sales', NULL, 'ferdi@megatrak.com', 1),
(24, 'Orhan Gencebay', 'Safety Expert', 'A Class', 'orhan@megatrak.com', 1),
(25, 'Bülent Ersoy', 'Safety Expert', 'B Class', 'bulent@megatrak.com', 1);
SET IDENTITY_INSERT Employee OFF;
GO

-- Customer Data
SET IDENTITY_INSERT Customer ON;
INSERT INTO Customer (CustomerID, CustomerName, IndustryType, Address, Email, PhoneNumber, TaxNumber) VALUES
(1, 'Trakya Cam Sanayi', 'Manufacturing', 'Lüleburgaz OSB', 'info@trakyacam.com', '02884170001', '1000000001'),
(2, 'Kırklareli İplik', 'Textile', 'Babaeski Yolu', 'info@kiplik.com', '02884170002', '1000000002'),
(3, 'Burgaz Gıda', 'Food', 'Yeni Mah. Lüleburgaz', 'info@burgazgida.com', '02884170003', '1000000003'),
(4, 'Ergene İnşaat', 'Construction', 'Atatürk Cad.', 'info@ergene.com', '02884170004', '1000000004'),
(5, 'Vize Madencilik', 'Mining', 'Vize Çıkışı', 'info@vizemaden.com', '02884170005', '1000000005'),
(6, 'Meriç Lojistik', 'Logistics', 'E-5 Karayolu', 'info@mericloj.com', '02884170006', '1000000006'),
(7, 'Babaeski Tarım', 'Agriculture', 'Babaeski Mrk', 'info@babaeski.com', '02884170007', '1000000007'),
(8, 'Pınarhisar Çimento', 'Manufacturing', 'Pınarhisar Yolu', 'info@pinarhisar.com', '02884170008', '1000000008'),
(9, 'Lüleburgaz Hastanesi', 'Health', 'İstasyon Cad.', 'info@lhastane.com', '02884170009', '1000000009'),
(10, 'Trakya Un', 'Food', 'Muratlı Yolu', 'info@trakyaun.com', '02884170010', '1000000010'),
(11, 'Edirne Yağ', 'Food', 'Edirne OSB', 'info@edirneyag.com', '02884170011', '1000000011'),
(12, 'Keşan Plastik', 'Manufacturing', 'Keşan Sanayi', 'info@kesanplast.com', '02884170012', '1000000012'),
(13, 'Çorlu Deri', 'Textile', 'Çorlu Deri OSB', 'info@corluderi.com', '02884170013', '1000000013'),
(14, 'Tekirdağ Liman', 'Logistics', 'Barbaros Mah.', 'info@tliman.com', '02884170014', '1000000014'),
(15, 'Saray Bisküvi', 'Food', 'Saray Yolu', 'info@saraybis.com', '02884170015', '1000000015'),
(16, 'Çerkezköy Metal', 'Manufacturing', 'Çerkezköy OSB', 'info@cmetal.com', '02884170016', '1000000016'),
(17, 'Kapaklı Kimya', 'Chemical', 'Kapaklı OSB', 'info@kkimya.com', '02884170017', '1000000017'),
(18, 'Silivri Yapı', 'Construction', 'Silivri Sahil', 'info@syapi.com', '02884170018', '1000000018'),
(19, 'Malkara Kömür', 'Mining', 'Malkara Yolu', 'info@mkomur.com', '02884170019', '1000000019'),
(20, 'Hayrabolu Makine', 'Manufacturing', 'Hayrabolu Sanayi', 'info@hmakine.com', '02884170020', '1000000020'),
(21, 'Uzunköprü Çeltik', 'Agriculture', 'Uzunköprü', 'info@uceltik.com', '02884170021', '1000000021'),
(22, 'Havsa Tekstil', 'Textile', 'Havsa Yolu', 'info@havsatek.com', '02884170022', '1000000022'),
(23, 'İpsala Gümrük', 'Logistics', 'Sınır Kapısı', 'info@ipsala.com', '02884170023', '1000000023'),
(24, 'Enez Turizm', 'Tourism', 'Enez Sahil', 'info@eneztur.com', '02884170024', '1000000024'),
(25, 'Demirköy Orman', 'Agriculture', 'Demirköy', 'info@dorman.com', '02884170025', '1000000025');
SET IDENTITY_INSERT Customer OFF;
GO

-- Service Data
SET IDENTITY_INSERT Service ON;
INSERT INTO Service (ServiceID, ServiceName, Category, ServiceType, BasePrice) VALUES
(1, 'Risk Analysis Report', 'Consultancy', 'One-Time', 5000.00),
(2, 'Basic Fire Safety Training', 'Training', 'One-Time', 2000.00),
(3, 'Advanced First Aid Training', 'Training', 'One-Time', 3000.00),
(4, 'Monthly OHS Consultancy (A)', 'Consultancy', 'Recurring', 12000.00),
(5, 'Monthly OHS Consultancy (B)', 'Consultancy', 'Recurring', 9000.00),
(6, 'Monthly OHS Consultancy (C)', 'Consultancy', 'Recurring', 6000.00),
(7, 'Emergency Action Plan', 'Consultancy', 'One-Time', 4000.00),
(8, 'Workplace Physician Service', 'Consultancy', 'Recurring', 8000.00),
(9, 'Hygiene Training', 'Training', 'One-Time', 1500.00),
(10, 'Working at Height Training', 'Training', 'One-Time', 2500.00),
(11, 'Chemical Safety Audit', 'Audit', 'One-Time', 3500.00),
(12, 'Electrical Safety Audit', 'Audit', 'One-Time', 3000.00),
(13, 'Noise Measurement', 'Audit', 'One-Time', 1000.00),
(14, 'Dust Measurement', 'Audit', 'One-Time', 1000.00),
(15, 'Thermal Comfort Measurement', 'Audit', 'One-Time', 1000.00),
(16, 'Lighting Measurement', 'Audit', 'One-Time', 1000.00),
(17, 'Vibration Measurement', 'Audit', 'One-Time', 1200.00),
(18, 'Gas Measurement', 'Audit', 'One-Time', 1500.00),
(19, 'Lifting Equipment Control', 'Audit', 'Recurring', 2000.00),
(20, 'Pressure Vessel Control', 'Audit', 'Recurring', 2000.00),
(21, 'Forklift Inspection', 'Audit', 'Recurring', 1500.00),
(22, 'Crane Inspection', 'Audit', 'Recurring', 2500.00),
(23, 'Boiler Inspection', 'Audit', 'Recurring', 2000.00),
(24, 'Elevator Inspection', 'Audit', 'Recurring', 1800.00),
(25, 'Fire Drill Supervision', 'Consultancy', 'One-Time', 3000.00);
SET IDENTITY_INSERT Service OFF;
GO

-- Request Data
SET IDENTITY_INSERT Request ON;
INSERT INTO Request (RequestID, CustomerID, Subject, RequestDate, RequestSource, Status) VALUES
(1, 1, 'Need Risk Analysis', '2025-10-01', 'Email', 'Closed'),
(2, 2, 'Fire Training Request', '2025-10-02', 'Phone', 'Closed'),
(3, 3, 'Monthly Consultancy', '2025-10-03', 'Web', 'Closed'),
(4, 4, 'Construction Audit', '2025-10-04', 'Email', 'Closed'),
(5, 5, 'Mining Safety Plan', '2025-10-05', 'Phone', 'Closed'),
(6, 6, 'Driver Safety Training', '2025-10-06', 'Web', 'Closed'),
(7, 7, 'Pesticide Safety', '2025-10-07', 'Email', 'Closed'),
(8, 8, 'Dust Measurement', '2025-10-08', 'Phone', 'Closed'),
(9, 9, 'Hospital Hygiene', '2025-10-09', 'Web', 'Closed'),
(10, 10, 'Explosion Protection', '2025-10-10', 'Email', 'Closed'),
(11, 11, 'Chemical Audit', '2025-10-11', 'Phone', 'Contacted'),
(12, 12, 'Machine Guarding', '2025-10-12', 'Web', 'Contacted'),
(13, 13, 'Noise Control', '2025-10-13', 'Email', 'New'),
(14, 14, 'Port Safety', '2025-10-14', 'Phone', 'New'),
(15, 15, 'Food Safety OHS', '2025-10-15', 'Web', 'Closed'),
(16, 16, 'Metal Cutting Safety', '2025-10-16', 'Email', 'Closed'),
(17, 17, 'Chemical Storage', '2025-10-17', 'Phone', 'Closed'),
(18, 18, 'Scaffolding Safety', '2025-10-18', 'Web', 'Closed'),
(19, 19, 'Underground Safety', '2025-10-19', 'Email', 'Closed'),
(20, 20, 'Welding Safety', '2025-10-20', 'Phone', 'Closed'),
(21, 21, 'Harvester Safety', '2025-10-21', 'Web', 'Closed'),
(22, 22, 'Textile Dust', '2025-10-22', 'Email', 'Closed'),
(23, 23, 'Traffic Safety', '2025-10-23', 'Phone', 'Closed'),
(24, 24, 'Hotel Safety', '2025-10-24', 'Web', 'Closed'),
(25, 25, 'Forestry Safety', '2025-10-25', 'Email', 'New');
SET IDENTITY_INSERT Request OFF;
GO

-- Proposal Data
SET IDENTITY_INSERT Proposal ON;
INSERT INTO Proposal (ProposalID, RequestID, ExpiryDate, TotalValue, Status) VALUES
(1, 1, '2025-11-01', 5000.00, 'Approved'),
(2, 2, '2025-11-02', 2000.00, 'Approved'),
(3, 3, '2025-11-03', 12000.00, 'Approved'),
(4, 4, '2025-11-04', 8000.00, 'Approved'),
(5, 5, '2025-11-05', 10000.00, 'Approved'),
(6, 6, '2025-11-06', 3000.00, 'Approved'),
(7, 7, '2025-11-07', 4000.00, 'Sent'),
(8, 8, '2025-11-08', 1000.00, 'Approved'),
(9, 9, '2025-11-09', 1500.00, 'Approved'),
(10, 10, '2025-11-10', 5000.00, 'Rejected'),
(11, 11, '2025-11-11', 3500.00, 'Draft'),
(12, 12, '2025-11-12', 2500.00, 'Sent'),
(13, 15, '2025-11-15', 6000.00, 'Approved'),
(14, 16, '2025-11-16', 7000.00, 'Approved'),
(15, 17, '2025-11-17', 3500.00, 'Approved'),
(16, 18, '2025-11-18', 2500.00, 'Approved'),
(17, 19, '2025-11-19', 15000.00, 'Approved'),
(18, 20, '2025-11-20', 2000.00, 'Approved'),
(19, 21, '2025-11-21', 4000.00, 'Approved'),
(20, 22, '2025-11-22', 1000.00, 'Approved'),
(21, 23, '2025-11-23', 5000.00, 'Approved'),
(22, 24, '2025-11-24', 8000.00, 'Approved'),
(23, 25, '2025-11-25', 3000.00, 'Draft'),
(24, 1, '2025-12-01', 5500.00, 'Draft'),
(25, 2, '2025-12-02', 2200.00, 'Draft');
SET IDENTITY_INSERT Proposal OFF;
GO

-- ProposalServices Data
INSERT INTO ProposalServices (ProposalID, ServiceID) VALUES
(1, 1), (2, 2), (3, 4), (4, 4), (5, 7),
(6, 3), (7, 7), (8, 14), (9, 9), (10, 1),
(11, 11), (12, 12), (13, 6), (14, 4), (15, 11),
(16, 10), (17, 1), (18, 20), (19, 21), (20, 14),
(21, 1), (22, 5), (23, 7), (24, 1), (25, 2);
GO

-- ServiceOrder Data
SET IDENTITY_INSERT ServiceOrder ON;
INSERT INTO ServiceOrder (ServiceOrderID, CustomerID, ProposalID, EmployeeID, ScheduledDate, Status) VALUES
(1, 1, 1, 1, '2025-12-01', 'Completed'),
(2, 2, 2, 4, '2025-12-02', 'Completed'),
(3, 3, 3, 8, '2025-12-03', 'Scheduled'),
(4, 4, 4, 13, '2025-12-04', 'Scheduled'),
(5, 5, 5, 20, '2025-12-05', 'Pending Assignment'),
(6, 6, 6, 24, '2025-12-06', 'Completed'),
(7, 8, 8, 5, '2025-12-08', 'Completed'),
(8, 9, 9, 2, '2025-12-09', 'Completed'),
(9, 15, 13, 16, '2025-12-15', 'Scheduled'),
(10, 16, 14, 21, '2025-12-16', 'Scheduled'),
(11, 17, 15, 11, '2025-12-17', 'Pending Assignment'),
(12, 18, 16, 25, '2025-12-18', 'Scheduled'),
(13, 19, 17, 1, '2025-12-19', 'Completed'),
(14, 20, 18, 4, '2025-12-20', 'Canceled'),
(15, 21, 19, 8, '2025-12-21', 'Scheduled'),
(16, 22, 20, 13, '2025-12-22', 'Completed'),
(17, 23, 21, 20, '2025-12-23', 'Scheduled'),
(18, 24, 22, 24, '2025-12-24', 'Scheduled'),
(19, 1, 1, 5, '2026-01-01', 'Pending Assignment'),
(20, 2, 2, 2, '2026-01-02', 'Pending Assignment'),
(21, 3, 3, 16, '2026-01-03', 'Pending Assignment'),
(22, 4, 4, 21, '2026-01-04', 'Pending Assignment'),
(23, 5, 5, 11, '2026-01-05', 'Pending Assignment'),
(24, 6, 6, 25, '2026-01-06', 'Pending Assignment'),
(25, 8, 8, 1, '2026-01-08', 'Pending Assignment');
SET IDENTITY_INSERT ServiceOrder OFF;
GO

-- Invoice Data
INSERT INTO Invoice (ServiceOrderID, SubTotal) VALUES
(1, 5000.00),
(2, 2000.00),
(6, 3000.00),
(7, 1000.00),
(8, 1500.00),
(13, 15000.00),
(16, 1000.00);
GO
