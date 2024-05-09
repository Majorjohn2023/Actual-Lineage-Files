WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o_orderdate) AS order_month,
        SUM(o_totalprice) AS total_revenue
    FROM {{ ref('stg_orders') }}
    GROUP BY order_month
),
monthly_revenue_growth AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
        (total_revenue - LAG(total_revenue) OVER (ORDER BY order_month)) / LAG(total_revenue) OVER (ORDER BY order_month) AS growth_rate
    FROM monthly_revenue
)
SELECT * FROM monthly_revenue_growth