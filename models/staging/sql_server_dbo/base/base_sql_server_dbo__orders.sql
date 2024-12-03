{{
  config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
  )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
),

renamed_casted_no_empty_values AS (
    SELECT
        order_id::VARCHAR(40) AS order_id,
        user_id::VARCHAR(40) AS user_id,
        CASE
            WHEN shipping_service = '' THEN md5('Not shipped')
            WHEN shipping_service IS NULL THEN md5('Not shipped')
            ELSE {{ dbt_utils.generate_surrogate_key(['shipping_service']) }}
        END AS shipping_service_id,
        CASE
            WHEN shipping_service = '' THEN 'Not shipped'
            WHEN shipping_service IS NULL THEN 'Not shipped'
            ELSE shipping_service
        END::VARCHAR(20) AS shipping_service_name,
        address_id::VARCHAR AS address_id,
        CASE
            WHEN promo_id = '' THEN md5('No promo')
            WHEN promo_id IS NULL THEN'No promo'
            ELSE {{ dbt_utils.generate_surrogate_key(['promo_id']) }}
        END AS promo_id,
        order_cost::NUMBER(5,2) AS order_cost_usd,
        order_total::NUMBER(5,2) AS order_total_usd,
        shipping_cost::NUMBER(5,2) AS shipping_cost_usd,
        status::VARCHAR(20) AS status,
        tracking_id::VARCHAR(40) AS tracking_id,
        CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc,
        CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at_utc,
        CONVERT_TIMEZONE('UTC', estimated_delivery_at) AS estimated_delivery_at_utc,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS load_date_utc
    FROM src_orders

    {% if is_incremental() %}

    where _fivetran_synced >= (select coalesce(max(load_date_utc),'1900-01-01') from {{ this }} )

    {% endif %}
)

SELECT * FROM renamed_casted_no_empty_values