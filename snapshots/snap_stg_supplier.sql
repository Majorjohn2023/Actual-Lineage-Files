{% snapshot supplier_snapshot %}

{{
    config(
      target_schema='snapshot',
      unique_key='s_suppkey',
      strategy='check',
      check_cols=['s_name']  
    )
}}


SELECT * FROM {{ ref('stg_supplier') }}

{% endsnapshot %}

-- testingsndjsnd

