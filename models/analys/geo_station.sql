{{config(materialized='view')}}
select
  station_id
, station_name
, ST_GEOGPOINT(station_longitude, station_latitude) as station_point
from {{ ref('stations') }}
where station_latitude between 40 and 41
