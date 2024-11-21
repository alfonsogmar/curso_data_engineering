{{
  config(
    materialized='view'
  )
}}

WITH base_orders AS (
    SELECT * 
    FROM {{ref('base_sql_server_dbo__orders') }}
),

shipping_fields AS(
    SELECT
        shipping_service_id,
        order_id,
        shipping_cost_usd
    FROM base_orders
)

SELECT * FROM shipping_fields