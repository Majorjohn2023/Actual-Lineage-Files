-- models/staging/stg_partsupp.sql
WITH source AS (
    SELECT * FROM {{ source('tpch', 'partsupp') }}
)
SELECT
    ps_partkey,
    ps_suppkey,
    ps_availqty,
    ps_supplycost,
    ps_comment
FROM source
