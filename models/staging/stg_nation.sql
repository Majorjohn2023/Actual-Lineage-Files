-- models/staging/stg_nation.sql
WITH source AS (
    SELECT * FROM {{ source('tpch', 'nation') }}
)
SELECT
    n_nationkey,
    n_name,
    n_regionkey,
    n_comment
FROM source
