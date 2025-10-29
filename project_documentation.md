# Deliverable #2: Extract, Load, and Transform 

## Extracting data (copied from Project Overview):

### Fivetran Connection Credentials:
- Transactional Database for the online purchases:
- Use a PostgreSQL Amazon RDS connector
- Host: database-1.c3ckkcekkkxp.us-east-1.rds.amazonaws.com
- User: fivetran_usr
- Password: dw_fivetran
- Database: ecoessentials
- Update Method: Detect changes via Fivetran Teleport Sync
 
### Salesforce Marketing Cloud Email Events dataset:
- Use an Amazon S3 connector
- Bucket Name: salesforce-marketing-emails
- Access Approach: Access Key and Secret
- Access Key ID: ---
- Access Key Secret: ---
- You will need to click `+ Add Files`, create your table name, preview to ensure there is a file available (it should be called marketing_emails.csv)

## Files created

### _src_ecoessentials.yml

```
 version: 2

sources:
  - name: ecoessentials_landing
    database: group3project
    schema: ecoessentials_dw_source
    tables: 
      - name: salesforce_marketing_emails
  - name: ecoessentials_landing_2
    database: group3project
    schema: ecoessentials_transactional_db
    tables: 
      - name: promotional_campaign
      - name: customer
      - name: orders
      - name: order_line
      - name: product 
```

### dim_date.sql

```
{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

with cte_date as (
{{ dbt_date.get_date_dimension("1990-01-01", "2050-12-31") }}
)

SELECT
date_day as date_key,
date_day,
day_of_week,
month_of_year,
month_name,
quarter_of_year,
year_number
from cte_date
```

### dim_campaign.sql (from salesforce_marketing_emails)

```
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
```

### dim_customer.sql (from salesforce_marketing_emails)

```
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
s.emaileventid, 
s.subscriberemail as email,
s.subscriberid
FROM {{ source('ecoessentials_landing_2', 'customer') }} c
inner join {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }} s
    on s.customerid = c.customer_id
    where s.customerid != 'NULL'
```

### dim_event.sql (from salesforce_marketing_emails)

```
{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
emaileventid as event_key, 
emaileventid,
eventtimestamp,
eventtype
FROM {{ source('ecoessentials_landing', 'salesforce_marketing_emails') }}
```

### dim_user.sql (from salesforce_marketing_emails)

```
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
```

### dim_order_line.sql (from ecoessentials_transactional_db)

```
{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
order_line_id as order_line_key,
order_line_id,
order_id,
product_id,
campaign_id,
quantity,
discount,
promotional_campaign,
price_after_discount
FROM {{ source('ecoessentials_landing_2', 'order_line') }}
```

### dim_orders.sql (from ecoessentials_transactional_db)

```
{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
order_id as orders_key,
order_id,
customer_id,
order_timestamp
FROM {{ source('ecoessentials_landing_2', 'orders') }}
```

### dim_product.sql (from ecoessentials_transactional_db)

```
{{ config(
    materialized = 'table',
    database = 'group3project',
    schema = 'final_part_2'
    )
}}

SELECT
product_id as product_key,
product_id,
product_type,
product_name,
price
FROM {{ source('ecoessentials_landing_2', 'product') }}
```

### dim_promotional_campaign.sql (from ecoessentials_transactional_db)

```
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
```

### fact_email.sql

```
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
--d.date_key,
cu.subscriberid as subscriber_key,
e.event_key,
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
    on e.eventtimestamp = d.date_key
    where d.date_key = left(e.eventtimestamp, 10)
```

### fact_sale.sql

```
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

```