/* 1. Write a query which retrieves information from the OrderHeader and OrderDetail tables in one result set:

      SalesOrderID  OrderDate                 SalesOrderDetailID  OrderQty    UnitPrice   ProductID
      71774         2008-06-01 00:00:00.000   110562              1           356,8980    836
      71774         2008-06-01 00:00:00.000   110563              1           356,8980    822
      ...           ...                       ...                 ...         ...         ...

      (result: 542 rows) */

/* 2. Extend the query from the previous exercies. Instead of ProductID show the name of the product. 
      Use a clear field alias.
      (result: 542 rows) */


/* 3. Extend the query again. Add a column where the ProductDescription is shown. 
      Use the ER diagram to find out how this value can be retrieved.
      (result: 3246 rows) */

/* 4. Write a query to show Category names which haven't got any Product assigned to it. (result: a couple of rows) */

/* 5. (Bonus) Which customers have got AT LEAST one order? */

-- 5. Een oplossing:
SELECT c.LastName 
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID;

SELECT c.LastName 
FROM SalesLT.Customer AS c
WHERE c.CustomerID IN
(
	SELECT CustomerID 
	FROM SalesLT.SalesOrderHeader
	WHERE CustomerID = c.CustomerID
);

SELECT c.LastName 
FROM SalesLT.Customer AS c
WHERE EXISTS
(
	SELECT 1 
	FROM SalesLT.SalesOrderHeader
	WHERE CustomerID = c.CustomerID
);

-- Oplossing 4: Categorieën zonder producten
-- Normale query
SELECT 
	pc.Name AS categorienaam
FROM SalesLT.Product AS p
RIGHT OUTER JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
WHERE p.ProductID IS null;

-- Snellere query als performance een must is
SELECT
	pc.Name AS categorienaam
FROM SalesLT.ProductCategory AS pc
WHERE NOT EXISTS
(
	SELECT 1
	FROM SalesLT.Product AS p
	WHERE p.ProductCategoryID = pc.ProductCategoryID
);

-- GROUPING SETS

SELECT NULL AS color, NULL AS productcategoryid, COUNT(*) AS aantal FROM SalesLT.Product WHERE Color IS NOT NULL
UNION
SELECT NULL AS color, productcategoryid, COUNT(*) FROM SalesLT.Product WHERE Color IS NULL GROUP BY ProductCategoryID
UNION
SELECT color, productcategoryid, COUNT(*) FROM SalesLT.Product WHERE Color IS NOT NULL GROUP BY Color, productcategoryid 


-- COALESCE() retourneert de eerste niet-null waarde uit de argumentenlijst



SELECT COALESCE(City, StateProvince, CountryRegion, 'n/a') FROM SalesLT.Address

SELECT 
	OrderDate 
	, CAST(OrderDate AS date)
FROM SalesLT.SalesOrderHeader

SELECT CAST('19830230 04:50' AS date)

SELECT COALESCE(TRY_CAST('19830205 04:50' AS date), SYSDATETIME())