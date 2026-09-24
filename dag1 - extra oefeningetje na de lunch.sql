/* 1. Use the table Customer. Write a query which retrieves per SalesPerson the number of customers. 
      Use a COUNT(*) and GROUP BY. (result: 9 rows) */

SELECT 
	c.SalesPerson
	, COUNT(*) 
FROM SalesLT.Customer AS c
GROUP BY c.SalesPerson;

/* 2. How often is each Title used? Write a new query to answer that.
      (result: 5 rows) */

SELECT 
	c.Title
	, COUNT(*) 
FROM SalesLT.Customer AS c
GROUP BY c.Title;

/* 3. How often is each Suffix used? Write a new query.
      (result: 6 rows) */

SELECT 
	c.Suffix
	, COUNT(*) 
FROM SalesLT.Customer AS c
GROUP BY c.Suffix;

/* 4. How often is each combination Title, Suffix used? Write a new query.
      (result: 10 rows) */

SELECT
	c.Title
	, c.Suffix
	, COUNT(*) 
FROM SalesLT.Customer AS c
GROUP BY 
	c.Title
	, c.Suffix;
