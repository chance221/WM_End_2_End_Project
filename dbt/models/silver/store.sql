{{
  config(
    materialized='incremental',
    unique_key='Store_id',
    incremental_strategy = 'merge',
    merge_exclude_columns = ['Loaded_At']
  )
}}

with store_raw as (
  select
    Store as Store_id,
    Type as Store_type,
    Size as Store_Size,
    Loaded_At::timestamp_ntz as Insert_date,
    cast(current_timestamp() as timestamp_ntz) as Update_date
  from {{ source('RAW_SALES_DATA', 'STORES') }}

  {% if is_incremental() %}
    where Loaded_At > (select max(Insert_date) from {{ this }})
  {% endif %}
  -- The above statement is important because its looking for the latest record entered into the target/destination 
  -- table for each store based on the Loaded_At timestamp. 
  -- If there are multiple records for the same store, it will only keep the one with the latest Loaded_At value.
  -- This prevents it fromreading every single csv record snopipe has ingested, saving time and money

  -- Deduplicate within the incoming batch itself so if there are two updates to the same store 
  qualify row_number() over (partition by Store order by Loaded_At desc) = 1
)

select * from store_raw