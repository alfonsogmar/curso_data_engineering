{{
  config(
    materialized='view'
  )
}}

WITH order_snapshot AS (
    SELECT * 
    FROM {{ref('order_snapshot') }}
),

order_fields AS(
    SELECT
        order_id,
        status,
        delivered_at_utc
    FROM order_snapshot
)

SELECT * FROM order_fields