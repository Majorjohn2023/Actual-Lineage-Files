WITH product_sales AS (
    SELECT
        p_partkey,
        COUNT(l_orderkey) AS total_orders,
        SUM(l_quantity) AS total_quantity_sold
    FROM {{ ref('stg_part') }} p
    JOIN {{ ref('stg_lineitem') }} l ON p.p_partkey = l.l_partkey
    GROUP BY p_partkey
),
top_selling_products AS (
    SELECT *,
           RANK() OVER (ORDER BY total_quantity_sold DESC) AS sales_rank
    FROM product_sales
)
SELECT * FROM top_selling_products
