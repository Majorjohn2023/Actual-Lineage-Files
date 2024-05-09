{{ config(materialized='view', tags=['staging', 'supplier']) }}


WITH order_values AS (
    SELECT
        o_orderkey,
        SUM(l_extendedprice * (1 - l_discount)) AS order_value
    FROM {{ ref('stg_lineitem') }} l
    JOIN {{ ref('stg_orders') }} o ON l.l_orderkey = o.o_orderkey
    GROUP BY o_orderkey
),
average_order_value AS (
    SELECT
        AVG(order_value) AS avg_order_value
    FROM order_values
)
SELECT * FROM average_order_value
