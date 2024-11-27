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
        address_id::VARCHAR(40) AS address_id,
        address::VARCHAR(100) AS address,
        zipcode::VARCHAR(5) AS zipcode,
        country::VARCHAR(20) AS country,
        state::VARCHAR(20) AS state,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS load_date_utc
    FROM src_addresses
    )

SELECT * FROM renamed_casted