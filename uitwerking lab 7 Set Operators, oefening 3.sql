/* 3. Data from the adventureworks database needs to be migrated to a new system!
      After 6 months of comparing tables and data fields, all findings are stored in Excel.
      One of the Excel sheets contains:

      adventureworks.SalesLT.Customer:          tempdb.dbo.Customers:
      ====================================      ==================================
      FirstName (nvarchar, not nullable)        FullName (nvarchar(120), not nullable)
      MiddleName (nvarchar, not nullable)    
      LastName (nvarchar), not nullable)
      EmailAddress (nvarchar(50), nullable)     Email (nvarchar(50), not nullable)
      Phone (nvarchar, nullable)                Phone (nvarchar(10), not nullable)
      CompanyName(nvarchar(128), nullable)      Company (nvarchar(100), not nullable)
      (no other columns needed)                 Active (bit = 1, not nullable), important:
                                                • Two companies will be inactive:
                                                • 'Retreat Inn' and 'World of Bikes'

      The DBA has built a script for creation and an initial upload of 5 customers, run it.
      Then write a script to migrate only the remainder of customers. 
      Truncate values and/or fill in 'N/A' where applicable.
*/

-- BRON
INSERT INTO tempdb.dbo.Customers
SELECT
	CONCAT_WS(' ', FirstName, MiddleName, LastName)
	, EmailAddress 
	, LEFT(Phone, 10)
	, LEFT(CompanyName, 100)
	, IIF(CompanyName IN ('Retreat Inn', 'World of Bikes'), 0, 1)
	--, CASE WHEN CompanyName IN ('Retreat Inn', 'World of Bikes') THEN 0 ELSE 1 END
FROM adventureworks.SalesLT.Customer
EXCEPT
-- DOEL
SELECT 
	FullName
	, Email
	, Phone
	, Company
	, Active
FROM tempdb.dbo.Customers

-- DELTA (wat heb ik nog niet gemigreerd): BRON - DOEL
