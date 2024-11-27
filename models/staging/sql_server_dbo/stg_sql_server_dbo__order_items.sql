{{
  config(
    materialized='view'
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{source('sql_server_dbo','order_items') }}
),

casted_with_surrogate_key AS(
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id','product_id']) }} AS order_item_id,
        order_id::VARCHAR(40) AS order_id,
        product_id::VARCHAR(40) AS product_id,
        quantity::INT AS quantity
    FROM src_order_items
)

SELECT * FROM casted_with_surrogate_key