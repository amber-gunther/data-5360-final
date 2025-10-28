{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
product_id as productkey,
product_id,
product_type,
product_name,
price
FROM {{ source('ecoessentials_landing_2', 'product') }}
