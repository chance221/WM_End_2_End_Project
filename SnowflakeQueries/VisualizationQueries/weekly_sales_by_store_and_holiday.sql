USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE WALMART_DB;

USE SCHEMA WALMART_DB.GOLD;


SELECT * FROM WALMART_DB.GOLD.WALMART_DATE_DIM;


-- Need to gather the weekly sales for the store in fact table. need to join isholiday in date

SELECT
    f.store_id as store_id
    ,SUM(f.store_weekly_sales) as total_weekly_sales_for_store
    ,d.isholiday
    
FROM
    WALMART_DB.GOLD.WALMART_FACT_TABLE f 
JOIN
    WALMART_DB.GOLD.WALMART_DATE_DIM d
ON f.date_id = d.date_id
GROUP BY f.store_id, d.isholiday