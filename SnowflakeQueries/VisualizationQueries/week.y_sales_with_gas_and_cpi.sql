-- need to get total sales for each store type over for each month. 
USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE WALMART_DB;

USE SCHEMA WALMART_DB.GOLD;


SELECT
    DATE_ID,
    YEAR(DATE_ID) AS SALES_YEAR,
    FUEL_PRICE,
    CPI,
    SUM(store_weekly_sales) as TotalSalesForWeek
FROM
    WALMART_FACT_TABLE
GROUP BY
    1, 2, 3, 4