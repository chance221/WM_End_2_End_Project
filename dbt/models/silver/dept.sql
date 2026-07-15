{{
  config(
    materialized='incremental',
    unique_key=['Store_id', 'Dept_id', 'Date_id'],
    incremental_strategy = 'merge',
    merge_exclude_columns = ['Insert_date']
  )
}}

with dept_raw as (
  select
    Store as Store_id,
    Dept as Dept_id,
    cast(Date as date )as Date_id,
    Weekly_Sales as Store_Weekly_Sales,
    Is_Holiday as IsHoliday,
    Loaded_At::timestamp_ntz as Insert_date,
    cast(current_timestamp() as timestamp_ntz) as Update_date
  from {{ source('RAW_SALES_DATA', 'DEPARTMENT') }}


  -- The below statement is important because its looking for the latest record entered into the target/destination 
  -- table for each store based on the Loaded_At timestamp. 
  
  -- If there are multiple records for the same store, it will only keep the one with the latest Loaded_At value.
  -- This prevents it fromreading every single csv record snopipe has ingested, saving time and money
  
  {% if is_incremental() %}
    where Loaded_At > (select max(Insert_date) from {{ this }})
  {% endif %}
  

  -- Deduplicate within the incoming batch itself so if there are two updates to the same store in the same batch, we only keep the latest one.
  qualify row_number() over (
    partition by Store_id, Date_id, Dept_id 
    order by Loaded_At desc
  ) = 1
)

select * from dept_raw