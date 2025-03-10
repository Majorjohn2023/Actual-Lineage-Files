-- models/staging/stg_customers.sql. this is me testing things out
{{ config(materialized='view', tags=['staging', 'customers']) }}

WITH source AS (
    SELECT * FROM {{ source('tpch', 'customer') }}
)
SELECT
    c_custkey,
    c_name,
    c_address,
    c_nationkey,
    c_phone as c_phone,
    c_acctbal as c_acctbal,
    c_mktsegment as c_mktsegment,
    c_comment as c_comment
FROM source
Limit {{ env_var("dbt_limit") }}
