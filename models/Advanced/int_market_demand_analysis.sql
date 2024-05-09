WITH market_demand AS (
    SELECT
        p_type,
        SUM(l_quantity) AS total_quantity_demanded
    FROM {{ ref('stg_lineitem') }} l
    JOIN {{ ref('stg_part') }} p ON l.l_partkey = p.p_partkey
    GROUP BY p_type
)
SELECT * FROM market_demand