#!/bin/bash
bq load \
  --source_format=CSV \
  --skip_leading_rows 1 \
  --quote  '"' \
  boxwood-academy-373200:raw.stg_citibike_trips \
  gs://pivotal-spark-inbound/citibike/2018*.csv.gz \
  ./stg_citibike_trips.json