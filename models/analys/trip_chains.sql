{{
    config(
        partition_by={
              "field": "chain_starttime",
              "data_type": "timestamp",
              "granularity": "day"
            }
    )
}}
with cte_chains as
(
select
    bike_chain_id
  , bikeid
  , max(chain_breaktime) over (partition by bikeid, bike_chain_id) as chain_breaktime
  , min(starttime) over (partition by bikeid, bike_chain_id) as chain_starttime
  , max(stoptime) over (partition by bikeid, bike_chain_id) as chain_stoptime
  , sum(tripduration) over (partition by bikeid, bike_chain_id) as chain_tripduration
  , first_value(start_station_id) over (partition by bikeid, bike_chain_id order by starttime) as chain_start_station_id
  , first_value(end_station_id) over (partition by bikeid, bike_chain_id order by starttime desc) as  chain_end_station_id
  , struct(start_station_id, end_station_id) as station
from {{ ref('chains') }}
), cte_trip_chains as
(
select
{%- set select_columns = "
    bike_chain_id
  , bikeid
  , max(chain_breaktime) as chain_breaktime
  , max(chain_starttime) as chain_starttime
  , max(chain_stoptime) as chain_stoptime
  , max(chain_tripduration) as chain_tripduration
  , max(chain_start_station_id) as chain_start_station_id
  , max(chain_end_station_id) as chain_end_station_id
  , count(station) as chain_length
  , array_agg(station) as stations
"-%}{{select_columns}}
from cte_chains
{{ dbt_utils.group_by(n=2) }}
)

select
{{ star_cte(select_columns, '') }}
from cte_trip_chains