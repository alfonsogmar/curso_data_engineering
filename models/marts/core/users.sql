{{
  config(
    materialized='table'
  )
}}

WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__users') }}
),


SELECT * FROM stg_users