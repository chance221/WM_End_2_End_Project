USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

--CREATE OR REPLACE DATABASE WALLMART_DB;
USE DATABASE WALMART_DB;

USE SCHEMA WALMART_DB.GOLD;


with SalesData AS (
    SELECT 
        store_id as store_ids
        ,sum(store_weekly_sales) AS store_total_sales
    FROM
        walmart_fact_table 
    GROUP BY
        store_id
),

StoreSizes AS (
    SELECT 
        distinct store_id,
        store_size
    FROM
        walmart_store_dim
)

SELECT
    store_ids
    ,store_total_sales
    ,store_size
FROM 
    SalesData
JOIN 
    StoreSizes 
ON
    store_ids = store_id

