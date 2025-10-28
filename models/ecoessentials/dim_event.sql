{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'ecoessentials_dw_source'
    )
}}

SELECT
emaileventid as eventid, 
emaileventid,
eventtimestamp,
eventtype
FROM {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }}