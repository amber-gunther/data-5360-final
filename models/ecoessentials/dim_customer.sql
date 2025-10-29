{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    ) }}

SELECT
c.customer_id as customer_key,
c.customer_id,
c.customer_first_name,
c.customer_last_name,
c.customer_phone,
c.customer_address,
c.customer_city,
c.customer_state,
c.customer_zip,
c.customer_country,
s.subscriberemail as email,
s.subscriberid
FROM {{ source('ecoessentials_landing_2', 'customer') }} c
inner join {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }} s
    on s.customerid = c.customer_id
