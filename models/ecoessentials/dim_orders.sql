{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
order_id as orders_key,
order_id,
customer_id,
order_timestamp
FROM {{ source('ecoessentials_landing_2', 'orders') }}
