

SELECT
    CASE
        WHEN store_temperature < 32 Then 'Freezing (<32)'
        WHEN store_temperature >= 32 AND store_temperature < 50 Then 'Cold (32 - 49)'
        WHEN store_temperature >= 50 AND store_temperature < 70 Then 'Mild (50 - 69)'
        WHEN store_temperature >= 70 AND store_temperature < 85 Then 'warm (70 - 84)'
        WHEN store_temperature >= 85 Then 'Hot (<85)'
    END AS Temp_Range
    ,YEAR(date_id) as Sales_Year
    ,sum(store_weekly_sales) as Total_Sales
FROM walmart_db.gold.walmart_fact_table
GROUP BY 1, 2;
