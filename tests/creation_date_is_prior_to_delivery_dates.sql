SELECT * FROM {{ ref('stg_sql_server_dbo__orders') }}
WHERE
    NOT (
        delivered_at_utc IS Null
        OR (
            delivered_at_utc IS NOT Null
            AND
            created_at_utc <= delivered_at_utc
        )
    )
    OR
    NOT (
        estimated_delivery_at_utc IS Null
        OR (
            estimated_delivery_at_utc IS NOT Null
            AND
            created_at_utc <= estimated_delivery_at_utc
        )
    )