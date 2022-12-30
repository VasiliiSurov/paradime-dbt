{{config(materialized='view')}}
select
    trip_key
  , bikeid
  , start_station_id
  , end_station_id
  , starttime
  , stoptime
  , tripduration
  , sum(case when ifnull(prev_end_station_id, -1) != start_station_id then 1 else 0 end) over (partition by bikeid order by starttime) as bike_chain_id
  , case when ifnull(prev_end_station_id, -1) != start_station_id then TIMESTAMP_DIFF(starttime, prev_stoptime, HOUR) else null end as chain_breaktime
from
(
 select
    trip_key,
    bikeid,
    lag(end_station_id) over (partition by bikeid order by starttime) as prev_end_station_id,
    start_station_id,
    end_station_id ,
    lag(stoptime) over (partition by bikeid order by starttime) as prev_stoptime,
    starttime,
    stoptime,
    tripduration
  from {{ ref('trips') }}
) t