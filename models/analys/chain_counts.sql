with cte_starts as
(
SELECT
  chain_start_station_id as station_id
, date( chain_starttime ) as trip_date
, count(*) as cnt
FROM {{ ref('trip_chains') }}
group by 1,2
), cte_stops as
(
SELECT
  chain_end_station_id as station_id
, date( chain_stoptime  ) as trip_date
, count(*) as cnt
FROM {{ ref('trip_chains') }}
group by 1,2
), cte_station as
(
select
  {{ dbt_utils.star(from=ref('geo_station')) }}
from {{ ref('geo_station') }}
)
select
  s.station_id
, st.station_name
, s.trip_date
, extract(day   from s.trip_date) as day
, extract(month from s.trip_date) as month
, extract(year  from s.trip_date) as year
, st.station_point
, s.cnt as cnt_starts
, e.cnt as cnt_ends
from cte_starts s, cte_stops e, cte_station st
where
    s.trip_date = e.trip_date
and st.station_id = s.station_id
and st.station_id = e.station_id

