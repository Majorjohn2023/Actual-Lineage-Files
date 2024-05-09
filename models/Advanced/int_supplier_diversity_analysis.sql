WITH supplier_diversity AS (
    SELECT
        s_nationkey,
        COUNT(DISTINCT s_suppkey) AS unique_suppliers
    FROM {{ ref('stg_supplier') }}
    GROUP BY s_nationkey
)
SELECT * FROM supplier_diversity