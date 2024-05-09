WITH supplier_revenue AS (
    SELECT
        s_suppkey,
        SUM(l_extendedprice * (1 - l_discount)) AS total_revenue
    FROM {{ ref('stg_supplier') }} s
    JOIN {{ ref('stg_lineitem') }} l ON s.s_suppkey = l.l_suppkey
    GROUP BY s_suppkey
)
SELECT * FROM supplier_revenue
