{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ ref('user_snapshot') }}
),

renamed_casted AS (
    SELECT
        user_id::VARCHAR(40) AS user_id,
        CONVERT_TIMEZONE('UTC', updated_at) AS updated_at_utc, -- necesario si no vamos a hacer snapshot?
        address_id::VARCHAR(40) AS address_id,
        first_name::VARCHAR(50) AS first_name,
        last_name::VARCHAR(50) AS last_name,
        CONVERT_TIMEZONE('UTC', created_at) AS created_at_utc, -- necesario si no vamos a hacer snapshot?
        phone_number::VARCHAR(12) AS phone_number,
        --total_orders,    No se usará en nuestro data warehouse, todos los valores son nulos
        email::VARCHAR(50) AS email,
        CONVERT_TIMEZONE('UTC', _fivetran_synced)  AS load_date_utc,
        CONVERT_TIMEZONE('UTC', dbt_valid_from) AS valid_from_utc,
        CONVERT_TIMEZONE('UTC', dbt_valid_to) AS valid_to_utc,
        (dbt_valid_to IS NULL) AS is_current
    FROM src_users
)

SELECT * FROM renamed_casted