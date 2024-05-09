WITH supply_cost_analysis AS (
    SELECT
        ps_suppkey,
        AVG(ps_supplycost) AS avg_supply_cost,
        SUM(ps_supplycost * ps_availqty) AS total_cost
    FROM {{ ref('stg_partsupp') }}
    GROUP BY ps_suppkey
)
SELECT * FROM supply_cost_analysis
