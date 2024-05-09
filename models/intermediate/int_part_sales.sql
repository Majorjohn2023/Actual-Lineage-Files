-- models/intermediate/int_part_sales.sql
WITH part_sales AS (
    SELECT
        p_partkey,
        SUM(l_quantity) AS total_quantity_sold,
        SUM(l_extendedprice) AS total_sales
    FROM {{ ref('stg_part') }} p
    LEFT JOIN {{ ref('stg_lineitem') }} l ON p.p_partkey = l.l_partkey
    GROUP BY p_partkey
)
SELECT * FROM part_sales
