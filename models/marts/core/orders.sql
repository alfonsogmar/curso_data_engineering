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

stg_order_costs AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__order_costs') }}
),

stg_shipping_costs AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__shipping_costs') }}
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


current_orders_with_costs AS (
    SELECT
        current_orders_users.*,
        stg_order_costs.order_cost_usd,
        stg_order_costs.order_total_usd,
        stg_shipping_costs.shipping_cost_usd
    FROM
        current_orders_users
    JOIN
        stg_order_costs
    ON
        current_orders_users.order_id = stg_order_costs.order_id
    JOIN
        stg_shipping_costs
    ON
        current_orders_users.order_id = stg_shipping_costs.order_id

),

selected_fields AS (
    SELECT
        order_id,
        address_id AS delivery_address_id,
        user_id,
        user_address_id,
        created_at_utc,
        promo_id,
        status,
        delivered_at_utc,
        estimated_delivery_at_utc,
        order_cost_usd,
        order_total_usd,
        shipping_cost_usd
    FROM current_orders_with_costs
)

SELECT * FROM selected_fields