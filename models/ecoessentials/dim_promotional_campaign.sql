{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
campaign_id as campaign_key,
campaign_id,
campaign_name,
campaign_discount
FROM {{ source('ecoessentials_landing_2', 'promotional_campaign') }}
