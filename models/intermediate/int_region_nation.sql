-- models/intermediate/int_region_nation.sql
WITH region_nation AS (
    SELECT
        n_nationkey,
        n_name AS nation_name,
        r_name AS region_name
    FROM {{ ref('stg_nation') }} n
    JOIN {{ ref('stg_region') }} r ON n.n_regionkey = r.r_regionkey
)
SELECT * FROM region_nation
