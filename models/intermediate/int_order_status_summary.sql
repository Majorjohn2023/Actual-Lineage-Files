WITH order_status_summary AS (
    SELECT
        o_orderstatus,
        COUNT(*) AS total_orders,
        SUM(o_totalprice) AS total_revenue
    FROM {{ ref('stg_orders') }}
    GROUP BY o_orderstatus
)
SELECT * FROM order_status_summary