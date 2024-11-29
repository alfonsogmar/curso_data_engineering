WITH stg_order_costs AS (
    SELECT * FROM {{ ref('stg_sql_server_dbo__order_costs') }}
),

stg_orders AS (
    SELECT * FROM {{ ref('stg_sql_server_dbo__orders') }}
),

stg_promos AS (
    SELECT * FROM {{ ref('stg_sql_server_dbo__promos') }}
),

stg_shipping_costs AS (
    SELECT * FROM {{ ref('stg_sql_server_dbo__shipping_costs') }}
)


SELECT
    stg_orders.order_id
FROM
    stg_orders
JOIN
    stg_order_costs
ON
    stg_orders.order_id = stg_order_costs.order_id
JOIN
    stg_promos
ON
    stg_orders.promo_id = stg_promos.promo_id
JOIN
     stg_shipping_costs
ON
    stg_order_costs.order_id = stg_shipping_costs.order_id
WHERE
    stg_order_costs.order_cost_usd + stg_shipping_costs.shipping_cost_usd - stg_promos.discount_usd != stg_order_costs.order_total_usd
