{{
    config(
        materialized='table'
    )
}}


WITH stg_promos AS (
    SELECT * FROM {{ ref('stg_sql_server_dbo__promos') }}
),

selected_fields AS (
    SELECT
        promo_id,
        promo_desc,
        discount_usd,
        is_active
    FROM
        stg_promos
)

SELECT * FROM selected_fields