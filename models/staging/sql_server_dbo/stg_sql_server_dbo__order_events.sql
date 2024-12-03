{{
  config(
    materialized='view'
  )
}}

WITH base_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}
),

order_event_fields AS (
    SELECT
        event_id,
        order_id,
    FROM base_events
    WHERE order_id != ''
)

SELECT * FROM order_event_fields