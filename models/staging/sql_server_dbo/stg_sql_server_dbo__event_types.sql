{{
  config(
    materialized='view'
  )
}}

WITH base_events AS (
    SELECT * 
    FROM {{ ref('base_sql_server_dbo__events') }}
),

event_types AS (
    SELECT DISTINCT
        event_type_id,
        event_type AS event_type_desc,
    FROM base_events
)

SELECT * FROM event_types