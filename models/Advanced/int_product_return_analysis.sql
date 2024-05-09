WITH product_returns AS (
    SELECT
        l_partkey,
        COUNT(*) AS total_count,
        COUNT(CASE WHEN l_returnflag = 'R' THEN l_orderkey END) AS return_count
    FROM {{ ref('stg_lineitem') }}
    GROUP BY l_partkey
),
return_rate AS (
    SELECT
        l_partkey,
        total_count,
        return_count,
        (return_count::FLOAT / total_count) AS return_rate
    FROM product_returns
)
SELECT * FROM return_rate