WITH customer_feedback AS (
    SELECT
        o_custkey,
        AVG(o_totalprice) AS avg_order_value,
        COUNT(DISTINCT CASE WHEN l_returnflag = 'R' THEN l_orderkey ELSE NULL END) AS return_count
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_lineitem') }} l ON o.o_orderkey = l.l_orderkey
    GROUP BY o_custkey
),
customer_satisfaction AS (
    SELECT
        o_custkey,
        avg_order_value,
        return_count,
        CASE
            WHEN avg_order_value > 50000 AND return_count = 0 THEN 'Highly Satisfied'
            WHEN avg_order_value > 50000 AND return_count > 0 THEN 'Satisfied'
            WHEN return_count = 0 THEN 'Neutral'
            ELSE 'Dissatisfied'
        END AS satisfaction_level
    FROM customer_feedback
)
SELECT * FROM customer_satisfaction