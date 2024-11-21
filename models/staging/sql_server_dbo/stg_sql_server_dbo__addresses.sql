{{
  config(
    materialized='view'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
),

renamed_casted AS (
    SELECT
        address_id,
        address,
        zipcode,
        country,
        state,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS load_date_utc
    FROM src_addresses
    )

SELECT * FROM renamed_casted