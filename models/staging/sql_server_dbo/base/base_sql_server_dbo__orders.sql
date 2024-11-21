{{
  config(
    materialized='view'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),

renamed_no_empy_values AS (
    SELECT
        order_id,
        user_id,
        CASE
            WHEN shipping_service = '' THEN md5('Not shipped')
            WHEN shipping_service IS NULL THEN md5('Not shipped')
            ELSE {{ dbt_utils.generate_surrogate_key(['shipping_service']) }}
        END AS shipping_service_id,
        CASE
            WHEN shipping_service = '' THEN 'Not shipped'
            WHEN shipping_service IS NULL THEN 'Not shipped'
            ELSE shipping_service
        END AS shipping_service_name,
        address_id,
        CASE
            WHEN promo_id = '' THEN md5('No promo')
            WHEN promo_id IS NULL THEN'No promo'
            ELSE {{ dbt_utils.generate_surrogate_key(['promo_id']) }}
        END AS promo_id,
        order_cost AS order_cost_usd,
        order_total AS order_total_usd,
        shipping_cost AS shipping_cost_usd,
        status,
        tracking_id,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)  AS load_date_utc
    FROM src_orders
)

SELECT * FROM renamed_no_empy_values