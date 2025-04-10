-- models/staging/stg_lineitem.sql
WITH source AS (
    SELECT * FROM {{ source('tpch', 'lineitem') }}
)
SELECT
    l_orderkey,
    l_partkey,
    l_suppkey,
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
    l_shipinstruct as l_shipinstruct,
    l_shipmode as l_shipmode,
    l_comment as l_comment
FROM source
