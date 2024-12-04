{{
  config(
    materialized='view'
  )
}}

WITH base_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}
),

product_event_fields AS (
    SELECT
        event_id,
        product_id,
        event_type_id
    FROM base_events
    WHERE product_id != ''
)

SELECT * FROM product_event_fields