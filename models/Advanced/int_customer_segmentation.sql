WITH customer_spending AS (
    SELECT
        o_custkey,
        SUM(l_extendedprice * (1 - l_discount)) AS total_spending
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_lineitem') }} l ON o.o_orderkey = l.l_orderkey
    GROUP BY o_custkey
),
customer_segmentation AS (
    SELECT
        o_custkey,
        total_spending,
        CASE
            WHEN total_spending > 12000 THEN 'Premium'
            WHEN total_spending > 5000 THEN 'Gold'
            ELSE 'Silver'
        END AS customer_segment
    FROM customer_spending
)
SELECT * FROM customer_segmentation