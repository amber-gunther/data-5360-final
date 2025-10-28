{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
campaignid as campaign_key,
campaignid,
campaignname
FROM {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }}