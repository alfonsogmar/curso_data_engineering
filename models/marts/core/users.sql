{{
  config(
    materialized='table'
  )
}}

WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__users') }}
),

selected_fields AS (
    SELECT
        user_id,
        first_name,
        last_name,
        email,
        address_id, -- mejor hacer join con tabla de addresses
        phone_number
    FROM stg_users
)


SELECT * FROM selected_fields