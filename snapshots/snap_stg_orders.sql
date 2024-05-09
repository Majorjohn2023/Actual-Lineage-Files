{% snapshot orders_snapshot %}

{{
    config(
      target_schema='snapshot',
      unique_key='o_orderkey',
      strategy='check',
      check_cols=['o_orderstatus']  
    )
}}

SELECT * FROM {{ ref('stg_orders') }}

{% endsnapshot %}
