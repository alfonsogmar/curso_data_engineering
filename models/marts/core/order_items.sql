{{
  config(
    materialized='table'
  )
}}


WITH stg_order_items AS (
    SELECT * FROM {{ ref('stg_sql_server_dbo__order_items') }}
)

stg_products AS (
    SELECT * FROM {{ ref('stg_sql_server_dbo__products') }}
),

order_items_with_total_product_prices AS (
    SELECT
        ordit.order_id,
        ordit.product_id,
        ordit.cuantity,
        quantity*prd.price AS total_price
    FROM
        stg_order_items ordit
    JOIN
        stg_products prd
    ON
        ordit.product_id = prd.product_id
)

SELECT * FROM order_items_with_total_product_prices