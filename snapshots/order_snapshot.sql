{% snapshot order_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='order_id',
        strategy='check',
        check_cols=['delivered_at_utc','status']
    )
}}

SELECT *
FROM {{ ref('base_sql_server_dbo__orders') }}

{% endsnapshot %}