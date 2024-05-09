WITH regional_sales AS (
    SELECT
        r_name,
        SUM(o_totalprice) AS total_sales
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_customers') }} c ON o.o_custkey = c.c_custkey
    JOIN {{ ref('stg_nation') }} n ON c.c_nationkey = n.n_nationkey
    JOIN {{ ref('stg_region') }} r ON n.n_regionkey = r.r_regionkey
    GROUP BY r_name
)
SELECT * FROM regional_sales