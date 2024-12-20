{{
  config(
    materialized='view'
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
),

renamed_casted_hashed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
        promo_id::VARCHAR(20) AS promo_desc,
        discount::INT AS discount_usd,
        (status='active') AS is_active,
        CONVERT_TIMEZONE( 'UTC' , _fivetran_synced ) AS load_date
    FROM src_promos
    UNION ALL
    SELECT 
        md5('No promo') AS promo_id,
        'No promo' AS promo_desc,
        0 AS discount_usd,
        False AS is_active,
        Null AS load_date
)

SELECT * FROM renamed_casted_hashed