#!/bin/bash
bq load \
  --source_format=CSV \
  --skip_leading_rows 1 \
  --quote  '"' \
  boxwood-academy-373200:raw.citibike_trips \
  gs://boxwood-academy-inbound/citibike/2018*.csv.gz \
  ./stg_citibike_trips.json