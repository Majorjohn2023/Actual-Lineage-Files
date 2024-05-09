WITH monthly_demand AS (
    SELECT
        DATE_TRUNC('month', l_shipdate) AS month,
        COUNT(*) AS total_orders,
        SUM(l_quantity) AS total_quantity
    FROM {{ ref('stg_lineitem') }}
    GROUP BY DATE_TRUNC('month', l_shipdate)
)
SELECT
    month,
    total_orders,
    total_quantity
FROM monthly_demand
ORDER BY total_quantity DESC
