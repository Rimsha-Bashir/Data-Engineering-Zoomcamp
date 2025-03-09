{{ config(materialized="table") }}

with
    fhv_tripdata as (
        select
            *,
            timestamp_diff(dropoff_datetime, pickup_datetime, second) as trip_duration
        from {{ ref("dim_fhv_trips") }}
    )

select
    *,
    percentile_cont(trip_duration, 0.90) over (
        partition by pickup_year, pickup_month, pickup_locationid, dropoff_locationid
    ) as p90
from fhv_tripdata
