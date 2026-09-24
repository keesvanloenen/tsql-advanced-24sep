-- Introductie query met 2 joins
SELECT 
	CONCAT_WS(' ', c.FirstName, c.MiddleName, c.LastName)	AS FullName
	, a.City
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT OUTER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE c.FirstName = 'Barbara';

/* 
Join de volgende 2 tabellen en haal uit beide tabellen de Name kolom op
Sales.Product (Name kolom)
Sales.ProductCategory (Name kolom)
*/

SELECT 
	UPPER(a.City)	AS City
	, a.CountryRegion
	, COUNT(*)		AS Aantal
FROM SalesLT.Address AS a
WHERE CountryRegion <> 'United Kingdom'
GROUP BY 
	UPPER(a.City)
	, a.CountryRegion
HAVING COUNT(*) > 10
ORDER BY Aantal DESC;

SELECT 
	P.ProductCategoryID
	, AVG(P.ListPrice) AS [Gemiddelde Prijs]
FROM SalesLT.Product AS p
GROUP BY P.ProductCategoryID;


-- Alle producten waarvan de listprice hoger is dan de gemiddelde listprice over alle producten

-- Dit is een subquery (een query tussen haakjes)
-- Deze kan gebruikt worden in bijv. een WHERE clause
-- of SELECT clause
(SELECT AVG(ListPrice) FROM SalesLT.Product)

-- SubQuery in de WHERE:
SELECT 
	Name
	, ListPrice
FROM SalesLT.Product 
WHERE ListPrice > 
(
	SELECT 
		AVG(ListPrice) 
	FROM SalesLT.Product
);

-- SubQuery in de SELECT:
SELECT 
	Name
	, ListPrice
	, (
		SELECT 
			AVG(ListPrice) 
		FROM SalesLT.Product
	  )	AS gemiddelde_listprijs
	, (
		SELECT 
			AVG(ListPrice) 
		FROM SalesLT.Product
	  ) - ListPrice AS het_verschil
FROM SalesLT.Product;

-- De cross join kun je overwegen bij het maken van testdata
-- In dit statement wordt bovendien een nieuwe tabel gemaakt
-- in de ingebouwde tempdb database

SELECT 
	c1.FirstName
	, c2.LastName 
INTO tempdb.dbo.TestData
FROM SalesLT.Customer AS c1
CROSS JOIN SalesLT.Customer AS c2;

SELECT * FROM tempdb.dbo.TestData

-- --------------------------------------------------------
-- Willen we alle categorieën waar geen producten in zitten,
-- dan voegen we eerst zo'n categorie toe aan de tabel:

SELECT * FROM SalesLT.ProductCategory

INSERT INTO SalesLT.ProductCategory
(ParentProductCategoryID, Name)
VALUES
(2, 'Huishoudelijk');

GO

-- Er zijn 4 TABLE EXPRESSIONS
-- Hiermee kun je een grote complexe query opbreken in kleinere delen
-- 1. View (in de database)
-- 2. Table Valued Function (in de database)
-- 3. Derived Table (in geheugen)
-- 4. Common Table Expression (in geheugen)

-- -----------------------------------------------------
-- 1. VIEW is een opgeslagen query:
--		1. GO moet erboven
--		2. Alle kolommen moeten een naam hebben
--		3. ORDER BY mag niet worden gebruikt (tenzij TOP is gebruikt)
CREATE OR ALTER VIEW SalesLT.CategorieenZonderProducten
AS
SELECT TOP 3
	pc.Name		AS CategorieNaam
	, p.ProductID 
FROM SalesLT.Product AS p
RIGHT OUTER JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
WHERE p.ProductID IS NULL
ORDER BY CategorieNaam;

GO

-- Gebruik de VIEW:
SELECT 
	* 
FROM SalesLT.CategorieenZonderProducten		-- 👈 de view
ORDER BY CategorieNaam DESC;

SELECT TOP 10 * FROM SalesLT.Product;		-- sample data

SELECT TOP 10 PERCENT
	p.Name
	, p.ListPrice 
FROM SalesLT.Product AS p;					-- 10% van de rijen

-- ------------------------------------------------------------------
-- Korte uitleg over TOP, TOP WITH TIES en TOP PERCENT
SELECT TOP 3 
	p.Name
	, p.ListPrice 
FROM SalesLT.Product AS p 
ORDER BY p.ListPrice DESC;		-- signifante data door de ORDER BY

SELECT TOP 3 WITH TIES
	p.Name
	, p.ListPrice 
FROM SalesLT.Product AS p 
ORDER BY p.ListPrice DESC;		-- signifante data door de ORDER BY

SELECT TOP 10 PERCENT
	p.Name
	, p.ListPrice 
FROM SalesLT.Product AS p 
ORDER BY p.ListPrice DESC;		-- signifante data door de ORDER BY

GO

-- Een view is ook update-baar als er 1 tabel gebruikt is:
CREATE OR ALTER VIEW SalesLT.DaanVindtHemLelijk
AS
SELECT * FROM SalesLT.ProductCategory

GO

-- Dit mag dus omdat er 1 tabel (SalesLT.ProductCategory) is gebruikt ...
INSERT INTO SalesLT.DaanVindtHemLelijk
(ParentProductCategoryID, Name)
VALUES
(2, 'Muziekinstrumenten');

-- ----------------------------------------------
-- 2. Table Valued Function (TVF)
-- Een functie die een tabel teruggeeft
-- Soms ook wel een 'parameterized view' genoemd

GO

CREATE OR ALTER FUNCTION SalesLT.AddressenInLondon
(@top AS int)
RETURNS table
AS
RETURN
SELECT TOP(@top)
	* 
FROM SalesLT.Address 
WHERE City = 'London';

GO

SELECT * FROM SalesLT.AddressenInLondon(3);

---

GO

CREATE OR ALTER FUNCTION SalesLT.ProductsInCategory(@CategoryId AS int)
RETURNS table
AS
RETURN
SELECT
	* 
FROM SalesLT.Product
WHERE ProductCategoryID = @CategoryId;

GO

SELECT * FROM SalesLT.ProductsInCategory(6);

-- Een table kun je niet JOINen met een Table Valued Function
-- Gebruik hiervoor CROSS APPLY
-- Dit is vrij geavanceerde code die je als developer zelden tot nooit nodig zult hebben
SELECT 
	pc.Name AS category_naam
	, pic.Name AS product_naam
	, pic.Color AS product_kleur
FROM SalesLT.ProductCategory AS pc
CROSS APPLY SalesLT.ProductsInCategory(pc.ProductCategoryID) AS pic;

-- CROSS APPLY ~ INNER JOIN
-- OUTER APPLY ~ LEFT OUTER JOIN

-- --------------------------------

-- 3. Derived Table
SELECT AVG(ListPrice) 
FROM
(
	SELECT TOP 3 WITH TIES
		p.Name
		, p.ListPrice 
	FROM SalesLT.Product AS p 
	ORDER BY p.ListPrice DESC
) AS top3;

-- 4. Common Table Expression (CTE)
-- Ook wel een WITH-statement genoemd
WITH Top3 AS
(
	SELECT TOP 3 WITH TIES
		p.Name
		, p.ListPrice 
	FROM SalesLT.Product AS p 
	ORDER BY p.ListPrice DESC
)
SELECT AVG(t3.ListPrice) FROM Top3 AS t3;

-- -------------------------------------

SELECT 
	sod.SalesOrderID
	, sod.OrderQty * sod.UnitPrice * (1 - sod.UnitPriceDiscount) AS RegelTotaal
FROM SalesLT.SalesOrderDetail AS sod;


SELECT 
	sod.SalesOrderID
	, SUM(sod.OrderQty * sod.UnitPrice * (1 - sod.UnitPriceDiscount)) AS Totaal
FROM SalesLT.SalesOrderDetail AS sod
GROUP BY sod.SalesOrderID;

WITH RegelTotalen AS
(
	SELECT 
		sod.SalesOrderID
		, sod.OrderQty * sod.UnitPrice * (1 - sod.UnitPriceDiscount) AS RegelTotaal
	FROM SalesLT.SalesOrderDetail AS sod
)
SELECT 
	SUM(rt.RegelTotaal) 
FROM RegelTotalen AS rt
GROUP BY rt.SalesOrderID;

-- ----------------------------------------------------------------------------------

GO

-- mini intro stored procedure

CREATE OR ALTER PROCEDURE SalesLT.OrderDetailsVoorKlant
AS
BEGIN

SELECT 
	COUNT(*) 
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID

SELECT 
	soh.OrderDate
	, soh.CustomerID
	, sod.OrderQty
	, sod.ProductID
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID

PRINT 'Hallo daar!';

END;

EXEC SalesLT.OrderDetailsVoorKlant