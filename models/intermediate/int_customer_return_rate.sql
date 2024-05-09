WITH customer_returns AS (
    SELECT
        c_custkey,
        COUNT(DISTINCT o_orderkey) AS total_orders,
        COUNT(DISTINCT CASE WHEN l_returnflag = 'R' THEN l_orderkey ELSE NULL END) AS total_returns
    FROM {{ ref('stg_customers') }} c
    JOIN {{ ref('stg_orders') }} o ON c.c_custkey = o.o_custkey
    JOIN {{ ref('stg_lineitem') }} l ON o.o_orderkey = l.l_orderkey
    GROUP BY c_custkey
),
customer_return_rate AS (
    SELECT *,
           (total_returns::FLOAT / total_orders) AS return_rate
    FROM customer_returns
)
SELECT * FROM customer_return_rate


-- adsjasbakbd
