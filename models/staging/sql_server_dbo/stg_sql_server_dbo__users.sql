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
        USER_ID::VARCHAR AS USER_ID,
        --CONVERT_TIMEZONE('UTC', UPDATED_AT) AS updated_at, -- necesario si no vamos a hacer snapshot?
        ADDRESS_ID::VARCHAR AS ADDRESS_ID,
        LAST_NAME::VARCHAR AS LAST_NAME,
        CONVERT_TIMEZONE('UTC', CREATED_AT) AS created_at_utc, -- necesario si no vamos a hacer snapshot?
        PHONE_NUMBER::VARCHAR AS PHONE_NUMBER,
        --TOTAL_ORDERS,    No se usará en nuestro data warehouse, todos los valores son nulos
        FIRST_NAME::VARCHAR AS FIRST_NAME,
        EMAIL::VARCHAR AS EMAIL,
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED)  AS load_date_utc
    FROM src_users
    )

SELECT * FROM renamed_casted