WITH yearly_revenue AS (
    SELECT
        DATE_PART('year', o_orderdate) AS order_year,
        SUM(o_totalprice) AS total_revenue
    FROM {{ ref('stg_orders') }}
    GROUP BY DATE_PART('year', o_orderdate)
)
SELECT 
    order_year,
    total_revenue
FROM yearly_revenue
ORDER BY order_year