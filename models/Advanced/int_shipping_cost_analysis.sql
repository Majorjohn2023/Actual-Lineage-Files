WITH shipping_cost AS (
    SELECT
        l_orderkey,
        SUM(l_extendedprice * l_discount) AS total_shipping_cost
    FROM {{ ref('stg_lineitem') }}
    GROUP BY l_orderkey
),
shipping_cost_summary AS (
    SELECT
        AVG(total_shipping_cost) AS avg_shipping_cost,
        MAX(total_shipping_cost) AS max_shipping_cost,
        MIN(total_shipping_cost) AS min_shipping_cost
    FROM shipping_cost
)
SELECT * FROM shipping_cost_summary