WITH supplier_performance AS (
    SELECT
        l_suppkey,
        COUNT(*) AS total_orders_fulfilled,
        AVG(l_extendedprice * (1 - l_discount)) AS avg_order_value
    FROM {{ ref('stg_lineitem') }}
    GROUP BY l_suppkey
)
SELECT * FROM supplier_performance