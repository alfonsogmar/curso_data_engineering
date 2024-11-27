{{
  config(
    materialized='view'
  )
}}

WITH base_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}
),

selected_event_fields AS (
    SELECT
        event_id,
        event_type_id,
        order_id,
        page_url,
        product_id,
        session_id,
        user_id,
        created_at_utc,
        load_date_utc
    FROM base_events
)

SELECT * FROM selected_event_fields