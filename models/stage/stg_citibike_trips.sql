with cte_citibike_trips as
(
select
    {{ case_null_str('tripduration', 'int64') }},
    {{ case_null_str('starttime', 'timestamp') }},
    {{ case_null_str('stoptime', 'timestamp') }},
    {{ case_null_str('start_station_id', 'int64') }},
    {{ case_null_str('start_station_name') }},
    {{ case_null_str('start_station_latitude', 'float64') }},
    {{ case_null_str('start_station_longitude', 'float64') }},
    {{ case_null_str('end_station_id', 'int64') }},
    {{ case_null_str('end_station_name') }},
    {{ case_null_str('end_station_latitude', 'float64') }},
    {{ case_null_str('end_station_longitude', 'float64') }},
    {{ case_null_str('bikeid', 'int64') }},
    {{ case_null_str('usertype') }},
    {{ case_null_str('birth_year', 'int64') }},
    {{ case_null_str('gender') }}
from {{ source('stage', 'citibike_trips') }}
)
select *
from cte_citibike_trips
