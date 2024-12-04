{{
  config(
    materialized='table'
  )
}}

WITH stg_products AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__products') }}
),

stg_order_items AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
),

stg_event_types AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__event_types') }}
),

orders_per_product AS (
    SELECT
        prd.product_id,
        prd.name,
        COUNT(DISTINCT ordit.order_id) AS times_purchased
    FROM
        stg_products prd
    JOIN
        stg_order_items ordit
    ON
        prd.product_id = ordit.product_id
    GROUP BY
        prd.product_id,
        prd.name

),

stg_product_events AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__product_events') }}
),



product_views_cart_additions AS (
    SELECT
        prde.product_id,
        SUM(
            CASE
                WHEN et.event_type_desc = 'add_to_cart' THEN 1
                ELSE 0
            END
        ) AS times_added_to_cart,
        SUM(
            CASE
                WHEN et.event_type_desc = 'page_view' THEN 1
                ELSE 0
            END
        ) AS page_views
    FROM stg_product_events prde
    JOIN stg_event_types et
    ON prde.event_type_id = et.event_type_id
    GROUP BY prde.product_id
),

product_views_cart_additions_orders AS (
    SELECT
        opp.product_id,
        opp.name,
        pvca.page_views,
        pvca.times_added_to_cart,
        opp.times_purchased,
        round(opp.times_purchased/pvca.page_views, 2)::NUMERIC(5,2) AS likelihood_to_purchase
    FROM
        product_views_cart_additions pvca
    JOIN
        orders_per_product opp
    ON 
        pvca.product_id = opp.product_id
    ORDER BY 6 DESC
)

SELECT * FROM product_views_cart_additions_orders
