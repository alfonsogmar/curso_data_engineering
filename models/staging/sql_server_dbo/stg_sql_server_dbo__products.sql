{{
  config(
    materialized='view'
  )
}}

WITH src_products AS (
    SELECT * 
    FROM {{source('sql_server_dbo','products') }}
),

casted_renamed AS(
    SELECT
        product_id::VARCHAR(40) AS product_id,
        price::NUMERIC(5,2) AS price,
        name::VARCHAR(50) AS name,
	    inventory::INT AS inventory
    FROM src_order_items
)

SELECT * FROM casted_renamed