WITH order_sizes AS (
    SELECT
        l_orderkey,
        COUNT(*) AS lineitem_count
    FROM {{ ref('stg_lineitem') }}
    GROUP BY l_orderkey
)
SELECT
    lineitem_count,
    COUNT(*) AS number_of_orders
FROM order_sizes
GROUP BY lineitem_count