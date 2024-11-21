{{
  config(
    materialized='table'
  )
}}

WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbg__users') }}
),


SELECT * FROM stg_users