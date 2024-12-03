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

stg_orders_evolution AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders_evolution') }}
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
        ord.user_id = usr.user_id AND 
        ord.created_at_utc >= usr.valid_from_utc AND (
            usr.is_current
            OR
            ord.created_at_utc <= usr.valid_to_utc
        )
),

current_orders_status AS (
    SELECT 
        order_id,
        status,
        delivered_at_utc
    FROM
        stg_orders_evolution    
    WHERE
        is_current = TRUE
),

current_orders_users AS (
    SELECT
        orders_users.*,
        current_orders_status.status,
        current_orders_status.delivered_at_utc
    FROM
        orders_users
    JOIN
        current_orders_status
    ON
        orders_users.order_id = current_orders_status.order_id
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