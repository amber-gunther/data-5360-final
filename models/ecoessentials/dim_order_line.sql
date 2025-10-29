{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
order_line_id as order_line_key,
order_line_id,
order_id,
product_id,
campaign_id,
quantity,
discount,
promotional_campaign,
price_after_discount
FROM {{ source('ecoessentials_landing_2', 'order_line') }}
