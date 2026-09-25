/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 17 - Datetime functions */

/* 1. Write a SELECT statement returning the columns:
    • Current date and time
    • Current date
    • Current time
    • Current year
    • Current month (number)
    • Current day of month
    • Current week
    • Current month (string)
    
    (result: 1 row)
*/


/* 🌶🌶 Exercise 18 - Datetime functions */

/* Preparation: Create a new table bij selecting and running the code between the fingers:

    👇
    USE tempdb;
    GO

    DROP TABLE IF EXISTS Orders;

    CREATE TABLE Orders 
    (
        id          int IDENTITY,
        orderdate   date,
        custid      int,
        amount      decimal(5, 2)
    );
    GO

    INSERT INTO Orders
    (orderdate, custid, amount)
    VALUES
    (DATEADD(day, 1 , EOMONTH(SYSDATETIME(), -2)), 1, 27),
    (DATEADD(day, 1 , EOMONTH(SYSDATETIME(), -2)), 1, 44.75),
    (DATEADD(day, 3 , EOMONTH(SYSDATETIME(), -2)), 2, 131),
    (DATEADD(day, 3 , EOMONTH(SYSDATETIME(), -2)), 3, 15.5),
    (DATEADD(day, 7 , EOMONTH(SYSDATETIME(), -2)), 3, 123.45),
    (DATEADD(day, 7 , EOMONTH(SYSDATETIME(), -2)), 2, 22),
    (DATEADD(day, 7 , EOMONTH(SYSDATETIME(), -2)), 2, 79),
    (DATEADD(day, 11 , EOMONTH(SYSDATETIME(), -2)), 1, 83),
    (DATEADD(day, 14 , EOMONTH(SYSDATETIME(), -2)), 3, 65.5),
    (DATEADD(day, 14 , EOMONTH(SYSDATETIME(), -2)), 3, 99.99),
    (DATEADD(day, 1, SYSDATETIME()), 2, 11),
    (DATEADD(day, 1, SYSDATETIME()), 1, 149.5),
    (DATEADD(day, 2, SYSDATETIME()), 3, 149.5);
    ☝
*/
 
/* 1. Use the table Orders in the tempdb database.
      Retrieve all orderdata from the first 3 days of the previous month.
      Don't use any datetime function. 
      In the WHERE clause simply use two hard-coded days in the format 'yyyymmdd'.

      (result: 4 rows) */

/* 2. Retrieve this resultset:

      custid  nrOfOrders  totalOfOrders   firstOrderdate  lastOrderdate
      1       4           304.25          2022-01-01      2022-02-26
      2       4           243.00          2022-01-03      2022-02-26
      3       5           453.94          2022-01-03      2022-02-27
*/

/* 3. Retrieve this resultset:

      year    month       quarter   total
      2022    February    1         310.00
      2022    January     1         691.19
*/

/* 4. Write a query that returns the number of days between the first and last order. 
      Don't hard-code any days.
*/

/* 5. Write a query similar to the previous one, but this time 
      the number of days between the first and last order PER CUSTOMER.
      (result: 3 rows)
*/

/* 6. Retrieve all order data of the previous month only.
      (result: 10 rows) */
