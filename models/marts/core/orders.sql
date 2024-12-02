{{
  config(
    materialized='table'
  )
}}

WITH stg_orders AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders') }}
),

stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__users') }}
),

orders_users AS (
    SELECT
        ord.*,
        usr.address_id AS user_address_id
    FROM
        stg_orders ord
    JOIN
        stg_users usr
    ON
        ord.user_id = usr.user_id
),

selected_fields AS (
    SELECT
        order_id,
        address_id AS delivery_address_id,
        user_id,
        user_address_id,
        created_at_utc,
        tracking_id,
        promo_id,
        estimated_delivery_at_utc
    FROM orders_users
)

SELECT * FROM selected_fields