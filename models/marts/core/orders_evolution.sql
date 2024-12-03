{{
  config(
    materialized='table'
  )
}}

WITH stg_orders_evolution AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__orders_evolution') }}
),

selected_fields AS (
    SELECT
        order_id,
        status,
        delivered_at_utc
    FROM
        stg_orders_evolution
)

SELECT * FROM selected_fields