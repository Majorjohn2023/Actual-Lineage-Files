WITH product_availability AS (
    SELECT
        p_partkey,
        COUNT(DISTINCT ps_suppkey) AS suppliers_count
    FROM {{ ref('stg_partsupp') }}
    JOIN {{ ref('stg_part') }} ON ps_partkey = p_partkey
    GROUP BY p_partkey
)
SELECT * FROM product_availability