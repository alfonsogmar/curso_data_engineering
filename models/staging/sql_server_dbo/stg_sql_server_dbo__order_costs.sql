{{
  config(
    materialized='view'
  )
}}

WITH base_orders AS (
    SELECT * 
    FROM {{ref('base_sql_server_dbo__orders') }}
),

order_cost_fields AS(
    SELECT
        order_id,
        order_cost_usd,
        order_total_usd
    FROM base_orders
)

SELECT * FROM order_cost_fields