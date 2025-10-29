--only half sure what i'm even doing. order_line has a lot of fields we wanted to be in this fact table, so i took everything out of order_line that i could, then found the others in order. only one join so yay but also now i'm anxious that i didn't do it right
--worker_id and warehouse_id not present anywhere. didn't we decide that this is data we don't have yet?

{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
ol.order_line_key,
o.orders_key,
c.campaign_key,
p.product_key,
cu.customer_key,
o.order_timestamp,
ol.discount,
ol.price_after_discount,
ol.quantity
FROM {{ ref('dim_order_line') }} ol
INNER JOIN {{ ref('dim_orders') }} o
    on ol.order_id = o.order_id
INNER JOIN {{ ref('dim_campaign') }} c
    on c.campaign_key = ol.campaign_id
INNER JOIN {{ ref('dim_product') }} p 
    on p.product_id = ol.product_id
INNER JOIN {{ ref('dim_customer') }} cu  
    on cu.customer_id = o.customer_id

