select
    {{ dbt_utils.star(from=ref('chain_counts')) }}
from {{ ref('chain_counts') }}
where true