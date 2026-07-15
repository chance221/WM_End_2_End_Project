
with fact_snap as (
  select
    Store_id,
    Date_id,
    Fuel_price,
    Temperature,
    Unemployment,
    CPI,
    Markdown1,
    Markdown2,
    Markdown3,
    Markdown4,
    Markdown5
  from {{ref ("fact_snapshot")}}
  where 
    dbt_valid_to is null
),

dpt as (
  select
    Store_id,
    Date_id,
    sum(Store_Weekly_Sales) as Weekly_sales   
  from {{ref("dept")}}
  group by 1, 2
)


select
  d.Store_id, 
  d.Date_id,
  d.Weekly_sales as Store_Weekly_Sales,
  f.Fuel_price,
  f.Temperature as Store_Temperature,
  f.Unemployment,
  f.CPI,
  f.Markdown1,
  f.Markdown2,
  f.Markdown3,
  f.Markdown4,
  f.Markdown5,
  current_timestamp() as Gold_loaded_at
from
  dpt d
join fact_snap f
  on d.Store_id = f.Store_id 
  and d.Date_id = f.Date_id