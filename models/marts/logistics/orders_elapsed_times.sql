{{
    config(
        materialized='table'
    )
}}

WITH stg_orders_evolution AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders_evolution') }}
),

elapsed_times AS (
    SELECT
        order_id,
        CASE
            WHEN status = 'preparing' AND NOT is_current THEN TIMEDIFF(second, valid_from_utc, valid_to_utc)
            ELSE Null
        END AS elapsed_preparation_time,
        CASE
            WHEN status = 'shipped' AND NOT is_current THEN TIMEDIFF(second, valid_from_utc, valid_to_utc)
            ELSE Null
        END AS elapsed_delivery_time,
    FROM stg_orders_evolution
),

grouped_by_order AS (
    SELECT
        order_id,
        MAX(elapsed_preparation_time) AS elapsed_preparation_time,
        MAX(elapsed_delivery_time) AS elapsed_delivery_time 
    FROM elapsed_times
    GROUP BY order_id
    ORDER BY 3, 2
)

SELECT * FROM grouped_by_order