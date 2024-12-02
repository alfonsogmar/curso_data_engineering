{{
  config(
    materialized='view'
  )
}}

WITH order_snapshot AS (
    SELECT * 
    FROM {{ref('order_snapshot') }}
),

order_evolution_fields AS(
    SELECT
        order_id,
        status,
        delivered_at_utc,
        load_date_utc,
        dbt_valid_from AS valid_from,
        dbt_valid_to AS valid_to,
        (dbt_valid_to IS NULL) AS is_current
    FROM order_snapshot
)

SELECT * FROM order_evolution_fields