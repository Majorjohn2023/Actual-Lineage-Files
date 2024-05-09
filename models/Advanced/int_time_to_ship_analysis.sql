WITH time_to_ship AS (
    SELECT
        o_orderkey,
        DATEDIFF(day, MIN(o_orderdate), MIN(l_shipdate)) AS days_to_ship
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_lineitem') }} l ON o.o_orderkey = l.l_orderkey
    GROUP BY o_orderkey
)
SELECT 
    o_orderkey,
    days_to_ship
FROM time_to_ship