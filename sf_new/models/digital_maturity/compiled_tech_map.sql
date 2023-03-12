
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}
with raw_maturity_score as (
      
        select
            cbtm.domain_name,
            sum(
               case 
                    when cbd.maturity = 'high' then 10   
                    when cbd.maturity = 'medium' then 1 
                    when cbd.maturity = 'low' then 0
                    else 0
               end
            ) as maturity_postgres 
        from {{source('builtwith_tables','CUST_BUILTWITH_TECHNOLOGY_MAP')}} as cbtm
        left join {{source('static_builtwith_tables','CUST_BUILTWITH_DATA')}} as cbd
        on cbtm.technology_name = cbd.technology
        where
            cbtm.currently_live = 'Y'
        group by 1
   )

   select
        rms.domain_name,
        case
            when rms.maturity_postgres > 39 then 'High'
            when rms.maturity_postgres <= 39 and rms.maturity_postgres > 9 then 'Medium'
            when rms.maturity_postgres <= 9 then 'Low'
        end as actual_maturity_level
   from 
        raw_maturity_score as rms
/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
