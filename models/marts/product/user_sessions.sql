{{
  config(
    materialized='table'
  )
}}

WITH stg_events AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__events') }}
),

stg_event_types AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__event_types') }}
),

stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__users') }}
),

grouped_by_user_sessions AS (
    SELECT
        stg_events.session_id,
        stg_users.user_id,
        stg_users.first_name,
        stg_users.email,
        MIN(stg_events.created_at_utc) AS first_event_time_utc,
        MAX(stg_events.created_at_utc) AS last_event_time_utc,
        TIMEDIFF(
            minute,
            MIN(stg_events.created_at_utc),
            MAX(stg_events.created_at_utc)
        ) AS session_length_minutes,
        SUM(
            CASE
                WHEN stg_event_types.event_type_desc = 'page_view' THEN 1
                ELSE 0
            END
        ) AS page_view,
        SUM(
            CASE
                WHEN stg_event_types.event_type_desc = 'add_to_cart' THEN 1
                ELSE 0
            END
        ) AS add_to_cart,
        SUM(
            CASE
                WHEN stg_event_types.event_type_desc = 'checkout' THEN 1
                ELSE 0
            END
        ) AS checkout,
        SUM(
            CASE
                WHEN stg_event_types.event_type_desc = 'package_shipped' THEN 1
                ELSE 0
            END
        ) AS package_shipped
    FROM
        stg_events
    JOIN
        stg_event_types
    ON
        stg_events.event_type_id = stg_event_types.event_type_id
    JOIN
        stg_users
    ON
        stg_events.user_id = stg_users.user_id
    GROUP BY
        stg_events.session_id,
        stg_users.user_id,
        stg_users.first_name,
        stg_users.last_name,
        stg_users.email,
        stg_users.phone_number,
        stg_users.created_at_utc,
        stg_users.updated_at_utc
)

SELECT * FROM grouped_by_user_sessions