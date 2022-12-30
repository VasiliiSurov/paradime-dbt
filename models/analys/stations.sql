{{
    config(
        materialized='incremental',
        unique_key='station_id'
    )
}}
with cte_start_station as
(
select
    start_station_id as station_id,
    start_station_name as station_name,
    start_station_latitude as station_latitude,
    start_station_longitude as station_longitude
from {{ ref('stg_citibike_trips') }}
where start_station_id is not null
), cte_end_station as
(
select distinct
    end_station_id as station_id,
    end_station_name as station_name,
    end_station_latitude as station_latitude,
    end_station_longitude as station_longitude
from {{ ref('stg_citibike_trips') }}
where end_station_id is not null
), cte_union as
(
select
    station_id,
    max(station_name) as station_name,
    max(station_latitude) as station_latitude,
    min(station_longitude) as station_longitude
from
    (
    select *
    from cte_start_station
    union distinct
    select *
    from cte_end_station
    )
group by 1
)

select * from cte_union
{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where station_id not in (select station_id from {{ this }})
{% endif %}