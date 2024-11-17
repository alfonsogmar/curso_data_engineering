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
        md5(promo_id) AS promo_id,
        promo_id AS promo_desc,
        to_numeric((discount/100), 5, 2) AS discount,
        status,
        _fivetran_synced AS load_date
    FROM src_promos
    UNION ALL
    SELECT 
        md5('') AS promo_id,
        'No promo' AS promo_desc,
        0.00 AS discount,
        'Inactive' AS status,
        Null AS load_date
    )

SELECT * FROM renamed_casted_hashed