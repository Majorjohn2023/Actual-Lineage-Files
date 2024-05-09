-- models/staging/stg_supplier.sql
{{ config(materialized='view', tags=['staging', 'supplier']) }}


WITH source AS (
    SELECT * FROM {{ source('tpch', 'supplier') }}
)
SELECT
    s_suppkey,
    s_name,
    s_address,
    s_nationkey,
    s_phone,
    s_acctbal,
    s_comment
FROM source
-- testing