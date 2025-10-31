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
d.date_key,
cu.subscriberid as subscriber_key,
e.event_key,
e.eventtimestamp
FROM {{ ref('dim_campaign') }} c
inner join {{ref('dim_order_line')}} ol 
    on c.campaignid = ol.campaign_id
inner join {{ ref('dim_product')}} p
    on p.product_id = ol.product_id
inner join {{ ref('dim_orders') }} o 
    on o.order_id = ol.order_id
inner join {{ ref('dim_customer') }} cu 
    on cu.customer_id = o.customer_id
inner join {{ ref('dim_event')}} e
    on e.emaileventid = cu.emaileventid
inner join {{ref('dim_date')}} d
    on e.eventtimestamp::date = d.date_key --yyyy-mm-dd

    --where d.date_key = e.eventtimestamp::date
    --where d.date_key = cast(e.eventtimestamp as date)
    --where d.date_key = left(e.eventtimestamp, 10)