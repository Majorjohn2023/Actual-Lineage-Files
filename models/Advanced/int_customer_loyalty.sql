{{ config(materialized='view', tags=['staging', 'supplier']) }}


WITH customer_orders AS (
    SELECT
        o_custkey,
        COUNT(*) AS orders_count
    FROM {{ ref('stg_orders') }}
    GROUP BY o_custkey
),
customer_loyalty AS (
    SELECT
        o_custkey,
        orders_count,
        CASE
            WHEN orders_count >= 10 THEN 'High'
            WHEN orders_count >= 5 THEN 'Medium'
            ELSE 'Low'
        END AS loyalty_level
    FROM customer_orders
)
SELECT * FROM customer_loyalty

-- this is just testingdsadcvfadsa