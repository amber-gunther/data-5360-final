{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    ) }}

SELECT
customer_id as customerkey,
customer_id,
customer_first_name,
customer_last_name,
customer_phone,
customer_address,
customer_city,
customer_state,
customer_zip,
customer_country
FROM {{ source('ecoessentials_landing_2', 'customer') }}