{{
  config(
    materialized='table'
  )
}}

WITH stg_budget AS (
    SELECT * 
    FROM {{ ref('stg_google_sheets__budget') }}
),

stg_products AS (
    SELECT product_id
    FROM {{ ref('stg_sql_server_dbo__products') }}
),

stg_order_items AS (
    SELECT *
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
),

stg_orders AS (
    SELECT order_id, created_at_utc
    FROM {{ ref('stg_sql_server_dbo__orders') }}
),


total_sold_products AS (
    SELECT
        prd.product_id AS product_id,
        LAST_DAY(ord.created_at_utc, 'month') AS month,
        SUM(ordit.quantity) AS quantity
    FROM
        stg_products prd
    JOIN
        stg_order_items ordit
    ON
        prd.product_id = ordit.product_id
    JOIN
        stg_orders ord
    ON
        ordit.order_id = ord.order_id
    GROUP BY
        prd.product_id, LAST_DAY(ord.created_at_utc, 'month')
),

actual_vs_budgeted AS (
    SELECT
        stg_budget.month,
        stg_budget.product_id,
        stg_budget.quantity AS budgeted_sales,
        total_sold_products.quantity AS actual_sales,
        total_sold_products.quantity-stg_budget.quantity AS sales_difference,
        (total_sold_products.quantity-stg_budget.quantity)>=0 AS expectations_met
    FROM
        stg_budget
    JOIN
        total_sold_products
    ON
        stg_budget.product_id = total_sold_products.product_id AND
        stg_budget.month = total_sold_products.month
    ORDER BY
        stg_budget.month
)

SELECT * FROM actual_vs_budgeted