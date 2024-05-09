WITH inventory_turnover AS (
    SELECT
        ps_partkey,
        SUM(l_quantity) AS total_sold,
        AVG(ps_availqty) AS average_inventory
    FROM {{ ref('stg_lineitem') }} l
    JOIN {{ ref('stg_partsupp') }} ps ON l.l_partkey = ps.ps_partkey
    GROUP BY ps_partkey
)
SELECT
    ps_partkey,
    total_sold,
    average_inventory,
    (total_sold / NULLIF(average_inventory, 0)) AS turnover_rate
FROM inventory_turnover