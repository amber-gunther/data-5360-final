{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
emaileventid as eventid, 
emaileventid,
eventtimestamp,
eventtype
FROM {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }}