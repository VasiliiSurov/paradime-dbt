{{config(materialized='view')}}
select
    trip_key,
    bikeid,
    start_station_id,
    end_station_id,
    starttime,
    stoptime,
    tripduration,
    sum(case when coalesce(prev_end_station_id, -1) != start_station_id then 1 else 0 end) over (partition by bikeid order by starttime) as bike_chain_id,
    case when coalesce(prev_end_station_id, -1) != start_station_id then timestamp_diff(starttime, prev_stoptime, hour) end as chain_breaktime
from
    (
        select
            trip_key,
            bikeid,
            lag(end_station_id) over (partition by bikeid order by starttime) as prev_end_station_id,
            start_station_id,
            end_station_id,
            lag(stoptime) over (partition by bikeid order by starttime) as prev_stoptime,
            starttime,
            stoptime,
            tripduration
        from {{ ref('trips') }}
    ) as t
