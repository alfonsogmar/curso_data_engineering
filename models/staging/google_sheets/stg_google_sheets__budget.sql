{{
  config(
    materialized='view'
  )
}}

WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['product_id', 'month']) }} AS budget_id,
        product_id::VARCHAR(40) AS product_id,
        quantity::INT AS quantity,
        month::DATE AS month,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
    FROM src_budget
)

SELECT * FROM renamed_casted