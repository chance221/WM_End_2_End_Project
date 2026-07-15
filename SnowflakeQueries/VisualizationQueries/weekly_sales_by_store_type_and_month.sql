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
        TO_CHAR(TO_DATE(date_id), 'MMMM') AS sales_month,
        sum(store_weekly_sales) as total_sales
    FROM
        WALMART_FACT_TABLE
    GROUP BY store_id, sales_month
)

SELECT 
    st.store_type,
    sales_month,
    sum(total_sales),
    
FROM
    StoreTypes st
JOIN
    TotalSalesPerStore ts
ON  
    st.store_id = ts.store_id
GROUP BY
    st.store_type, ts.sales_month
--join them based on store id 