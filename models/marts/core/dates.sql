{{
    config(
        materialized = "table"
    )
}}

WITH all_dates AS (
    {{ dbt_date.get_date_dimension("2020-01-01", "2030-12-31") }}
)

SELECT 
    all_dates.date_day AS date_id,
    all_dates.*
FROM all_dates