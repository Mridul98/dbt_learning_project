{{ config(materialized='table') }}

with joined_table as (
  select 
  ctm.domain_name,
  ctm.actual_maturity_level as m_pg,
  dmv.maturity as m_snowflake,
  dmv.maturity_manual as m_manual,
  dmv."check" as manual_vs_snowflake
  from
    {{ref("compiled_tech_map")}} ctm
  left join {{source('static_builtwith_tables','DIGITAL_MATURITY_VALIDATE')}} dmv  
  on ctm.domain_name = dmv.domain_name

)
select 
  joined_table.*,
  {{ is_dm_score_same('m_pg','m_manual') }} as manual_vs_pg,
  case 
  	when 
  		joined_table.m_pg = joined_table.m_manual
  		and
  		joined_table.m_pg = joined_table.m_snowflake
  	then 'True'
  	else 'False'
  end as manual_vs_pg_vs_snowflake,
  {{demo_macro()}} as demo_macro
from
   joined_table