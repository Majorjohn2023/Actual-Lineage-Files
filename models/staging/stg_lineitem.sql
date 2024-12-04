-- models/staging/stg_lineitem.sql
WITH source AS (
    SELECT * FROM {{ source('tpch', 'lineitem') }}
)
SELECT
    l_orderkey,
    l_partkey as a,
    l_suppkey as b,
    l_linenumber,
    l_quantity,
    l_extendedprice,
    l_discount,
    l_tax,
    l_returnflag,
    l_linestatus,
    l_shipdate,
    l_commitdate,
    l_receiptdate,
    l_shipinstruct,
    l_shipmode,
    l_comment
FROM source
