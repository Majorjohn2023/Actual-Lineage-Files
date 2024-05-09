WITH nation_order_stats AS (
    SELECT
        n_nationkey,
        COUNT(*) AS total_orders,
        SUM(o_totalprice) AS total_revenue
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_customers') }} c ON o.o_custkey = c.c_custkey
    JOIN {{ ref('stg_nation') }} n ON c.c_nationkey = n.n_nationkey
    GROUP BY n_nationkey
)
SELECT * FROM nation_order_stats