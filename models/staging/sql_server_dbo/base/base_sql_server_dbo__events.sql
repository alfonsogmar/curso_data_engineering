{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='event_id'
  )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
),

renamed_casted AS (
    SELECT
        event_id::VARCHAR(40) AS event_id,
        {{dbt_utils.generate_surrogate_key(['event_type'])}} AS event_type_id,
        event_type::VARCHAR(20) AS event_type,
        order_id::VARCHAR(40) AS order_id,
        page_url::VARCHAR(150) AS page_url,
        product_id::VARCHAR(40) AS product_id,
        session_id::VARCHAR(40) AS session_id,
        user_id::VARCHAR(40) AS user_id,
        CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS load_date_utc
    FROM src_events

    {% if is_incremental() %}

    where _fivetran_synced >= (select coalesce(max(_fivetran_synced),'1900-01-01') from {{ this }} )

    {% endif %}
)

SELECT * FROM renamed_casted

