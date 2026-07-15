
with walmart_date_dim as (
  select
    distinct cast(Date_id as varchar) as Date_id,
    Date_id as Store_Date,
    IsHoliday as Isholiday,
    Insert_Date,
    Update_date
  from {{ref ("dept")}}
)

select * from walmart_date_dim