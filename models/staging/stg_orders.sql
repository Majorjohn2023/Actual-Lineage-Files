-- models/staging/stg_orders.sql
{{ config(materialized='incremental', unique_key='o_orderkey', tags=['staging', 'orders']) }}

WITH source AS (
    SELECT * FROM {{ source('tpch', 'orders') }}
)
SELECT
    o_orderkey,
    o_custkey,
    o_orderstatus,
    o_totalprice,
    o_orderdate,
    o_orderpriority,
    o_clerk,
    o_shippriority,
    o_comment
FROM source
