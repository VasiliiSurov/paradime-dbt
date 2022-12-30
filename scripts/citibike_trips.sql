CREATE TABLE `boxwood-academy-373200.raw.stg_citibike_trips`
(
  tripduration INT64 OPTIONS(description="Trip Duration (in seconds)"),
  starttime DATETIME OPTIONS(description="Start Time, in NYC local time."),
  stoptime DATETIME OPTIONS(description="Stop Time, in NYC local time."),
  start_station_id INT64 OPTIONS(description="Start Station ID"),
  start_station_name STRING OPTIONS(description="Start Station Name"),
  start_station_latitude FLOAT64 OPTIONS(description="Start Station Latitude"),
  start_station_longitude FLOAT64 OPTIONS(description="Start Station Longitude"),
  end_station_id INT64 OPTIONS(description="End Station ID"),
  end_station_name STRING OPTIONS(description="End Station Name"),
  end_station_latitude FLOAT64 OPTIONS(description="End Station Latitude"),
  end_station_longitude FLOAT64 OPTIONS(description="End Station Longitude"),
  bikeid INT64 OPTIONS(description="Bike ID"),
  usertype STRING OPTIONS(description="User Type (Customer = 24-hour pass or 7-day pass user, Subscriber = Annual Member)"),
  birth_year INT64 OPTIONS(description="Year of Birth"),
  gender STRING OPTIONS(description="Gender (unknown, male, female)")
--   customer_plan STRING OPTIONS(description="The name of the plan that determines the rate charged for the trip")
);