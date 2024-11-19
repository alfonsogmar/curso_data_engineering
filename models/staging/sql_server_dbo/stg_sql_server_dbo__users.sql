{{
  config(
    materialized='view'
  )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
),

renamed_casted AS (
    SELECT
        USER_ID,
        CONVERT_TIMEZONE('UTC', UPDATED_AT) AS updated_at, -- necesario si no vamos a hacer snapshot?
        ADDRESS_ID,
        LAST_NAME,
        CONVERT_TIMEZONE('UTC', CREATED_AT) AS created_at, -- necesario si no vamos a hacer snapshot?
        PHONE_NUMBER,
        TOTAL_ORDERS,
        FIRST_NAME,
        EMAIL,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED)  AS load_date
    FROM src_users
    )

SELECT * FROM renamed_casted