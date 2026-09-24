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

-- -----------------------------------------------------
-- Een VIEW is een opgeslagen query:
-- 1. GO moet erboven
-- 2. Alle kolommen moeten een naam hebben
-- 3. ORDER BY mag niet worden gebruikt (tenzij...)
CREATE VIEW SalesLT.CategorieenZonderProducten
AS
SELECT 
	pc.Name		AS CategorieNaam
	, p.ProductID 
FROM SalesLT.Product AS p
RIGHT OUTER JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
WHERE p.ProductID IS NULL;

GO

-- Gebruik de VIEW:
SELECT 
	* 
FROM SalesLT.CategorieenZonderProducten		-- 👈 de view
ORDER BY CategorieNaam DESC;