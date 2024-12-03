{{
  config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['order_id', 'product_id']
  )
}}

WITH src_order_items AS (
    SELECT * 
    FROM {{source('sql_server_dbo','order_items') }}
),

casted_with_surrogate_key AS(
    SELECT
        {{ dbt_utils.generate_surrogate_key(['order_id','product_id']) }} AS order_item_id,
        order_id::VARCHAR(40) AS order_id,
        product_id::VARCHAR(40) AS product_id,
        quantity::INT AS quantity,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS load_date_utc
    FROM src_order_items

    {% if is_incremental() %}

    where _fivetran_synced >= (select coalesce(max(load_date_utc),'1900-01-01') from {{ this }} )

    {% endif %}
)

SELECT * FROM casted_with_surrogate_key