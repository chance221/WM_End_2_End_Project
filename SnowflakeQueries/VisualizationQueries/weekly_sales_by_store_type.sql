-- need to get total sales for each store type over for each month. 
USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE WALMART_DB;

USE SCHEMA WALMART_DB.GOLD;


--get the store id and the store type
with StoreTypes AS (
    SELECT
        distinct store_id,
        store_type
    FROM 
        WALMART_STORE_DIM
),

--get the store id and total sales of each store
TotalSalesPerStore AS (
    SELECT
        store_id,
        sum(store_weekly_sales) as total_sales
    FROM
        WALMART_FACT_TABLE
    GROUP BY store_id
)

SELECT 
    ts.store_id,
    st.store_type,
    sum(total_sales),
    
FROM
    StoreTypes st
JOIN
    TotalSalesPerStore ts
ON  
    st.store_id = ts.store_id
GROUP BY
    st.store_type, ts.store_id
--join them based on store id 