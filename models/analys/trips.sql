{{
    config(
        materialized='incremental',
        unique_key='trip_key',
        partition_by={
              "field": "starttime",
              "data_type": "timestamp",
              "granularity": "day"
            }
    )
}}
with cte_trips as
(
select
  {{ dbt_utils.surrogate_key(["bikeid", 'tripduration', 'starttime']) }} as trip_key,
  {{ dbt_utils.star(from=ref('stg_citibike_trips')) }}
from {{ ref('stg_citibike_trips') }}
)
select
    *
from cte_trips t
{% if is_incremental() -%}
  -- this filter will only be applied on an incremental run
  where not exists (select 1 from {{ this }} s where t.trip_key = s.trip_key)
{% endif %}
