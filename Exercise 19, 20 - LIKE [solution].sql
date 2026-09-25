/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 19 - LIKE */

/* 1. Retrieve Customers in the  format 'FirstName space lastName' where
      - the 2nd character of the FirstName is NOT an 'a' or 'i' 
      - and the 3rd character is an 'e', 'm' or 'u'
      (result: 54 rows) */

SELECT 
    CONCAT_WS(' ', FirstName, LastName) AS FullName
FROM SalesLT.Customer 
WHERE FirstName LIKE '_[^ai]%'
AND LastName LIKE '__[emu]%';

/* 🌶🌶 Exercise 20 - LIKE */

/* 1. From the table Address retrieve AddressLine1, City and PostCode where
      - the city is 'London' 
      - the PostalCode starts with 'SW' followed by 1 digit, 1 space, 1 digit and 2 characters
      (result: 2 rows) */

SELECT AddressLine1, City, PostalCode
FROM SalesLT.Address
WHERE City = 'London'
    AND PostalCode LIKE 'SW[0-9] [0-9]__'
ORDER BY PostalCode;