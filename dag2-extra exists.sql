USE master;
GO

DROP DATABASE IF EXISTS DemoExists;

CREATE DATABASE DemoExists;
GO

USE DemoExists;
GO

-- Create tables
CREATE TABLE dbo.Customers (
    Id 		int PRIMARY KEY,
    Name 	nvarchar(100)
);

CREATE TABLE dbo.Orders (
    Id			int IDENTITY PRIMARY KEY,
    CustomerId	int,
    OrderDate	date
);

-- Insert customers
INSERT INTO dbo.Customers 
VALUES (1, 'Ab'), (2, 'Bo'), (3, 'Cas');

-- Insert many orders for Ab (simulate large child table)
INSERT INTO dbo.Orders (CustomerId, OrderDate)
SELECT TOP 10000 
	1
	, '20250101'
FROM sys.objects a
CROSS JOIN sys.objects b;

-- Insert one order for Bo, insert NO order for Cas
INSERT INTO dbo.Orders 
VALUES (2, '20250301');

SELECT 
	c.Name
	, COUNT(*) AS OrdersCount
FROM Customers c
INNER JOIN Orders o
ON c.Id = o.CustomerID
GROUP BY c.Name;

-- Which customers have at least one order?

-- Regular query
SELECT DISTINCT c.Name
FROM Customers c
INNER JOIN Orders o 
ON c.Id = o.CustomerId;

-- Faster query if performance is critical
SELECT c.Name
FROM Customers c
WHERE EXISTS (
    SELECT 1 
	FROM Orders o 
	WHERE o.CustomerId = c.Id
);

-- For Alice the JOIN produces 10.000 rows, 
-- EXISTS short-circuits after the first match
