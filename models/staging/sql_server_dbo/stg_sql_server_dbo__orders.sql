{{
  config(
    materialized='view'
  )
}}

WITH base_orders AS (
    SELECT * 
    FROM {{ref('base_sql_server_dbo__orders') }}
),

order_fields AS(
    SELECT
        order_id,
        status,
        promo_id,
        tracking_id,
        created_at_utc,
        delivered_at_utc,
        estimated_delivery_at_utc
    FROM base_orders
)

SELECT * FROM order_fields