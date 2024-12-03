{{
  config(
    materialized='table'
  )
}}

WITH stg_addresses AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
),

selected_fields AS (
    SELECT
        address_id,
        address,
        zipcode,
        country,
        state
    FROM stg_addresses
)

SELECT * FROM selected_fields