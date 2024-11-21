{{
  config(
    materialized='view'
  )
}}

WITH base_orders AS (
    SELECT * 
    FROM {{ref('base_sql_server_dbo__orders') }}
),

unique_shipping_services AS(
    SELECT DISTINCT
        shipping_service_id,
        shipping_service_name AS name
    FROM base_orders
)

SELECT * FROM unique_shipping_services