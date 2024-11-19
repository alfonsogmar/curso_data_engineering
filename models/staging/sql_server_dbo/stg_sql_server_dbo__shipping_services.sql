{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),
src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
),
src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
)

