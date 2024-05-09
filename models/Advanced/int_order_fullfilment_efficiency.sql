WITH order_fulfillment AS (
    SELECT
        o_orderkey,
        DATEDIFF(day, MIN(o_orderdate), MIN(l_receiptdate)) AS days_to_fulfill -- Assuming you are using a SQL flavor that supports DATEDIFF
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_lineitem') }} l ON o.o_orderkey = l.l_orderkey
    GROUP BY o_orderkey
)
SELECT 
    o_orderkey,
    days_to_fulfill
FROM order_fulfillment