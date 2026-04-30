CREATE DATABASE RetailSSRS;
GO
USE RetailSSRS;

-- Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50)
);

-- Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

-- Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Order Details
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers
SELECT TOP 50
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
'Customer_' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR),
CASE WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 2 = 0 THEN 'Mumbai' ELSE 'Pune' END,
'India'
FROM sys.objects;

INSERT INTO Products
SELECT TOP 30
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
'Product_' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR),
CASE 
    WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 3 = 0 THEN 'Electronics'
    WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 3 = 1 THEN 'Clothing'
    ELSE 'Groceries'
END,
CAST((RAND(CHECKSUM(NEWID())) * 5000) AS DECIMAL(10,2))
FROM sys.objects;

INSERT INTO Orders
SELECT TOP 500
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
ABS(CHECKSUM(NEWID())) % 50 + 1,
DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE())
FROM sys.objects a CROSS JOIN sys.objects b;

INSERT INTO OrderDetails
SELECT TOP 2000
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
ABS(CHECKSUM(NEWID())) % 500 + 1,
ABS(CHECKSUM(NEWID())) % 30 + 1,
ABS(CHECKSUM(NEWID())) % 10 + 1,
CAST((RAND(CHECKSUM(NEWID())) * 10000) AS DECIMAL(10,2))
FROM sys.objects a CROSS JOIN sys.objects b;

select * from OrderDetails;
select * from Orders;
select * from Products;
select * from Customers;

