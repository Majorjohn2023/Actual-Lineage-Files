WITH sales_channel AS (
    SELECT
        o_orderpriority,
        COUNT(*) AS total_orders,
        SUM(o_totalprice) AS total_sales
    FROM {{ ref('stg_orders') }}
    GROUP BY o_orderpriority
)
SELECT
    o_orderpriority,
    total_orders,
    total_sales,
    (total_sales / NULLIF(total_orders, 0)) AS avg_sale_per_order
FROM sales_channel