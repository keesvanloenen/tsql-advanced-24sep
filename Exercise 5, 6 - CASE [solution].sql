/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 5 - CASE */

/* 1. Write a query to retrieve all unique colors from the table Product.
      We'll need a couple of these values in the next exercise.
      (result: 10 rows) */

SELECT DISTINCT 
  color
FROM SalesLT.Product;

/* 2. Write a query to retrieve a couple of fields including Color from the table Product.
      Add a new column 'ColorCode' in the result set:
      When Color is 'black' then show 'AAA' for ColorCode.
      Define 3 such color codes, for the remainder of the colors ColorCode will be 'TBD' (To Be Determined).
      Use a SIMPLE CASE.
      (result: 295 rows) */

SELECT 
    [Name]
    , ProductNumber
    , Color
    , CASE Color 
        WHEN 'Black'    THEN 'AAA'
        WHEN 'Blue'     THEN 'BBB'
        WHEN 'Grey'     THEN 'CCC'
        ELSE                 'TBD'
      END           AS ColorCode
FROM SalesLT.Product

/* 🌶🌶 Exercise 6 - CASE */

/* 1. Write a query using a SEARCHED CASE.
      Retrieve from the table Product 3 columns: Name, ListPrice en PriceIndex. 
      The latter will contain one of 3 values:
      'cheap', 'medium' or 'expensive'. (intermediate boundary ListPrice values are 500 and 1000). 
      (result: 295 rows) */

SELECT 
    [Name]
    , ListPrice
    , CASE
        WHEN ListPrice < 500 THEN   'goedkoop'
        WHEN ListPrice < 1000 THEN  'medium' 
        ELSE                        'duur'
      END AS PriceIndex
FROM SalesLT.Product;
