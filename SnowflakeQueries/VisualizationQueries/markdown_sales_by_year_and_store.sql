USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE WALMART_DB;

USE SCHEMA WALMART_DB.GOLD;



SELECT
    YEAR(DATE_ID) AS SalesYear,
    SUM(Markdown1) AS Markdown1,
    SUM(Markdown2) AS Markdown2,
    SUM(Markdown3) AS Markdown3,
    SUM(Markdown4) AS Markdown4,
    SUM(Markdown5) AS Markdown5,
FROM
    WALMART_FACT_TABLE
GROUP BY SalesYear
