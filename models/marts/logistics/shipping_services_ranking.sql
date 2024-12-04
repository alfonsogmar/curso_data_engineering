{{
    config(
        materialized='table'
    )
}}

WITH stg_shipping_services AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__shipping_services') }}
),

stg_shipping_costs AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__shipping_costs') }}
),

grouped_by_shipping_serv AS (
    SELECT
        sser.shipping_service_id,
        sser.name,
        COUNT(scost.order_id) AS number_of_orders,
        SUM(scost.shipping_cost_usd) AS total_shipping_cost_usd,
        ROUND(SUM(scost.shipping_cost_usd)/COUNT(scost.order_id), 2)::NUMERIC(5,2) AS shipping_cost_per_order_usd
    FROM
        stg_shipping_services sser
    JOIN
        stg_shipping_costs scost
    ON
        sser.shipping_service_id = scost.shipping_service_id
    GROUP BY
        sser.shipping_service_id,
        sser.name
),

shipping_services_ranking AS(
    SELECT
        shipping_service_id,
        name,
        number_of_orders,
        total_shipping_cost_usd,
        shipping_cost_per_order_usd,
        RANK() OVER(ORDER BY shipping_cost_per_order_usd) AS ranking
    FROM
        grouped_by_shipping_serv
    ORDER BY
        shipping_cost_per_order_usd
)

SELECT * FROM shipping_services_ranking
