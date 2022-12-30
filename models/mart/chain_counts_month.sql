with cte_counts as
(
select
  station_id
, month
, year
, sum(cnt_starts) as cnt_starts
, sum(cnt_ends) as cnt_ends
from {{ ref('chain_counts') }}
{{ dbt_utils.group_by(3) }}
), cte_station as
(
select
 {{ dbt_utils.star(from=ref('geo_station')) }}
from {{ ref('geo_station') }}
)
select
  c.station_id
, st.station_name
, c.month
, c.year
, st.station_point
, c.cnt_starts
, c.cnt_ends
from cte_counts c, cte_station st
where c.station_id = st.station_id