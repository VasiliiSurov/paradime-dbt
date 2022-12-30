{% macro case_null_str(field, data_type='string') -%}
    cast(case when {{ field }} = 'NULL' then NULL else {{ field }} end as {{ data_type }}) as {{ field }}
{%- endmacro %}