-- models/intermediate/int_customer_orders.sql
WITH customer_orders AS (
    SELECT
        c_custkey,
        COUNT(o_orderkey) AS total_orders,
        SUM(o_totalprice) AS total_spent
    FROM {{ ref('stg_customers') }} c
    LEFT JOIN {{ ref('stg_orders') }} o ON c.c_custkey = o.o_custkey
    GROUP BY c.c_custkey
)
SELECT * FROM customer_orders
