{% snapshot fact_snapshot %}

{{
  config(
    target_database = 'WALMART_DB',
    target_schema = 'silver',
    unique_key = ['Store_id', 'Date_id'],
    strategy='timestamp',
    updated_at= 'Loaded_At'
  )
}}


SELECT
  Store as Store_Id,
  cast(Date as date) as Date_id,
  Temperature,
  Fuel_price,
  Markdown1,
  Markdown2,
  Markdown3,
  Markdown4,
  Markdown5,
  CPI,
  Unemployment,
  IsHoliday,
  Loaded_At::timestamp_ntz as Loaded_At

from {{source('RAW_FACT_DATA', 'FACT')}}

{% endsnapshot %}