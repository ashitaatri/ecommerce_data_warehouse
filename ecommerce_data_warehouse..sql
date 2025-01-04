
-- Create the database
CREATE DATABASE EcommerceDW;
GO

USE EcommerceDW;
GO

-- Create schema
CREATE SCHEMA Dimension;
CREATE SCHEMA Fact;
CREATE SCHEMA Staging;
GO

-- Create Dimension Tables
-- DimCustomer Table
CREATE TABLE Dimension.DimCustomer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(255),
    Email NVARCHAR(255),
    PhoneNumber NVARCHAR(15),
    Address NVARCHAR(500),
    City NVARCHAR(100),
    State NVARCHAR(100),
    Country NVARCHAR(100),
    PostalCode NVARCHAR(20),
    IsActive BIT
);

-- DimProduct Table
CREATE TABLE Dimension.DimProduct (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(255),
    Category NVARCHAR(100),
    SubCategory NVARCHAR(100),
    Brand NVARCHAR(100),
    Price DECIMAL(10, 2),
    StockQuantity INT,
    IsActive BIT
);

-- DimDate Table
CREATE TABLE Dimension.DimDate (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT,
    Quarter INT,
    Weekday NVARCHAR(50)
);

-- Create Fact Table
-- FactSales Table
CREATE TABLE Fact.FactSales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Dimension.DimCustomer(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Dimension.DimProduct(ProductID),
    DateID INT FOREIGN KEY REFERENCES Dimension.DimDate(DateID),
    QuantitySold INT,
    TotalAmount DECIMAL(15, 2),
    Discount DECIMAL(10, 2),
    Profit DECIMAL(10, 2)
);

-- Create staging tables for ETL
-- StagingCustomer Table
CREATE TABLE Staging.StagingCustomer (
    CustomerName NVARCHAR(255),
    Email NVARCHAR(255),
    PhoneNumber NVARCHAR(15),
    Address NVARCHAR(500),
    City NVARCHAR(100),
    State NVARCHAR(100),
    Country NVARCHAR(100),
    PostalCode NVARCHAR(20),
    IsActive BIT
);

-- StagingProduct Table
CREATE TABLE Staging.StagingProduct (
    ProductName NVARCHAR(255),
    Category NVARCHAR(100),
    SubCategory NVARCHAR(100),
    Brand NVARCHAR(100),
    Price DECIMAL(10, 2),
    StockQuantity INT,
    IsActive BIT
);

-- StagingSales Table
CREATE TABLE Staging.StagingSales (
    CustomerID INT,
    ProductID INT,
    DateID INT,
    QuantitySold INT,
    TotalAmount DECIMAL(15, 2),
    Discount DECIMAL(10, 2),
    Profit DECIMAL(10, 2)
);

-- Populate DimDate with sample data
DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2030-12-31';
DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO Dimension.DimDate (DateID, FullDate, Day, Month, Year, Quarter, Weekday)
    VALUES (
        CAST(CONVERT(VARCHAR(8), @CurrentDate, 112) AS INT), -- Replace FORMAT
        @CurrentDate,
        DATEPART(DAY, @CurrentDate),
        DATEPART(MONTH, @CurrentDate),
        DATEPART(YEAR, @CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate)
    );
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;

-- Add indexes for performance
CREATE INDEX IX_FactSales_CustomerID ON Fact.FactSales (CustomerID);
CREATE INDEX IX_FactSales_ProductID ON Fact.FactSales (ProductID);
CREATE INDEX IX_FactSales_DateID ON Fact.FactSales (DateID);

-- Sample queries for analysis

-- Insert sample data for analysis
INSERT INTO Dimension.DimCustomer (CustomerName, Email, PhoneNumber, Address, City, State, Country, PostalCode, IsActive)
VALUES ('John Doe', 'john.doe@example.com', '1234567890', '123 Elm St', 'New York', 'NY', 'USA', '10001', 1),
       ('Jane Smith', 'jane.smith@example.com', '0987654321', '456 Oak St', 'Los Angeles', 'CA', 'USA', '90001', 1);

INSERT INTO Dimension.DimProduct (ProductName, Category, SubCategory, Brand, Price, StockQuantity, IsActive)
VALUES ('Laptop', 'Electronics', 'Computers', 'TechBrand', 1200.00, 50, 1),
       ('Headphones', 'Electronics', 'Accessories', 'SoundBrand', 150.00, 200, 1);

INSERT INTO Fact.FactSales (CustomerID, ProductID, DateID, QuantitySold, TotalAmount, Discount, Profit)
VALUES (1, 1, 20220101, 2, 2400.00, 200.00, 500.00),
       (2, 2, 20220102, 1, 150.00, 0.00, 50.00);

-- 1. Total Sales by Year
SELECT Year, SUM(TotalAmount) AS TotalSales
FROM Fact.FactSales FS
JOIN Dimension.DimDate DD ON FS.DateID = DD.DateID
GROUP BY Year;

-- 2. Best-Selling Products
SELECT TOP 10 P.ProductName, SUM(FS.QuantitySold) AS TotalQuantity
FROM Fact.FactSales FS
JOIN Dimension.DimProduct P ON FS.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalQuantity DESC;