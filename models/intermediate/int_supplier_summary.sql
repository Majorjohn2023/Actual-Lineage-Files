-- models/intermediate/int_supplier_summary.sql
WITH supplier_summary AS (
    SELECT
        s_suppkey,
        COUNT(ps_partkey) AS total_parts_supplied,
        SUM(ps_availqty) AS total_quantity_supplied
    FROM {{ ref('stg_supplier') }} s
    LEFT JOIN {{ ref('stg_partsupp') }} ps ON s.s_suppkey = ps.ps_suppkey
    GROUP BY s_suppkey
)
SELECT * FROM supplier_summary
