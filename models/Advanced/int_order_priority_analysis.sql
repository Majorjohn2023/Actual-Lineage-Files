WITH order_priority_stats AS (
    SELECT
        o_orderpriority,
        COUNT(*) AS total_orders,
        AVG(o_totalprice) AS avg_order_value
    FROM {{ ref('stg_orders') }}
    GROUP BY o_orderpriority
)
SELECT * FROM order_priority_stats
