{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
c.campaign_key,
p.product_key,
cu.customer_key,
d.time_key,
ev.event_key,
FROM {{ ref('dim_customer') }} cu
inner join {{ ref('dim_campaign') }} c 
    on c.customer_id = cu.customer_id
inner join {{ ref('dim_user')}} u
    on u.customer_id = cu.customer_id