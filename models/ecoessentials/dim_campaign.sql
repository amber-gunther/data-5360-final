{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'ecoessentials_dw_source'
    )
}}

SELECT
campaignid as campaign_key,
campaignid,
campaignname
FROM {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }}