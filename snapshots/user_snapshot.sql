{% snapshot user_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='user_id',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

SELECT *
FROM {{ source('sql_server_dbo', 'users') }}

{% endsnapshot %}