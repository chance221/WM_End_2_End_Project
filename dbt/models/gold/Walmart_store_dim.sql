

with walmart_dpt_data as (
  select distinct
    Store_id,
    Dept_id
  from {{ref ("dept")}}
),

walmart_store_data as (
  select
    Store_id,
    Store_type,
    Store_size
  from {{ref ("store")}}
)

select 
  d.Store_id,
  d.Dept_id,
  s.Store_type,
  s.Store_Size,
  current_timestamp() as Gold_loaded_at
from walmart_dpt_data d
join walmart_store_data s
  on s.Store_id = d.Store_id