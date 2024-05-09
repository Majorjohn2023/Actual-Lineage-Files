WITH yearly_customer_growth AS (
    SELECT
        DATE_PART('year', o_orderdate) AS order_year,
        COUNT(DISTINCT c_custkey) AS num_customers
    FROM {{ ref('stg_customers') }} c
    JOIN {{ ref('stg_orders') }} o ON c.c_custkey = o.o_custkey
    GROUP BY order_year
    ORDER BY order_year
)
SELECT * FROM yearly_customer_growth
