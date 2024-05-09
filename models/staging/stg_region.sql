-- models/staging/stg_region.sql
WITH source AS (
    SELECT * FROM {{ source('tpch', 'region') }}
)
SELECT
    r_regionkey,
    r_name,
    r_comment
FROM source
