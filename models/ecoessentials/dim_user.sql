{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
customerid as customer_key,
customerid,
subscriberfirstname as firstname,
subscriberlastname as lastname,
subscriberemail as email,
subscriberid
FROM {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }}