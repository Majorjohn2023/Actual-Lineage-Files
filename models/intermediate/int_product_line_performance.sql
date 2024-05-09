WITH product_line_performance AS (
    SELECT
        p_type,
        COUNT(l_orderkey) AS total_orders,
        SUM(l_extendedprice * (1 - l_discount)) AS total_revenue
    FROM {{ ref('stg_lineitem') }} l
    JOIN {{ ref('stg_part') }} p ON l.l_partkey = p.p_partkey
    GROUP BY p_type
)
SELECT * FROM product_line_performance