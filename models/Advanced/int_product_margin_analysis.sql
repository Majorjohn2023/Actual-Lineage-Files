WITH product_costs AS (
    SELECT
        l_partkey,
        SUM(l_extendedprice * (1 - l_discount)) - SUM(l_extendedprice * l_discount) AS net_revenue
    FROM {{ ref('stg_lineitem') }}
    GROUP BY l_partkey
),
product_margin_analysis AS (
    SELECT
        p.p_partkey,
        p.p_retailprice,
        pc.net_revenue,
        (pc.net_revenue - p.p_retailprice) / NULLIF(p.p_retailprice, 0) AS profit_margin
    FROM {{ ref('stg_part') }} p
    JOIN product_costs pc ON p.p_partkey = pc.l_partkey
)
SELECT * FROM product_margin_analysis