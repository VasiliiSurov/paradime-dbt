CREATE OR REPLACE TABLE `boxwood-academy-373200.raw.stg_citibike_trips`
(
  tripduration STRING OPTIONS(description="Trip Duration (in seconds)"),
  starttime STRING OPTIONS(description="Start Time, in NYC local time."),
  stoptime STRING OPTIONS(description="Stop Time, in NYC local time."),
  start_station_id STRING OPTIONS(description="Start Station ID"),
  start_station_name STRING OPTIONS(description="Start Station Name"),
  start_station_latitude STRING OPTIONS(description="Start Station Latitude"),
  start_station_longitude STRING OPTIONS(description="Start Station Longitude"),
  end_station_id STRING OPTIONS(description="End Station ID"),
  end_station_name STRING OPTIONS(description="End Station Name"),
  end_station_latitude STRING OPTIONS(description="End Station Latitude"),
  end_station_longitude STRING OPTIONS(description="End Station Longitude"),
  bikeid STRING OPTIONS(description="Bike ID"),
  usertype STRING OPTIONS(description="User Type (Customer = 24-hour pass or 7-day pass user, Subscriber = Annual Member)"),
  birth_year STRING OPTIONS(description="Year of Birth"),
  gender STRING OPTIONS(description="Gender (unknown, male, female)")
--   customer_plan STRING OPTIONS(description="The name of the plan that determines the rate charged for the trip")
);