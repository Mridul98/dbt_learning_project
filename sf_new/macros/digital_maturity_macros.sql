{% macro is_dm_score_same(table_one_col,table_two_col) -%}
    case 
        when 
            {{table_one_col}} = {{table_two_col}}
        then 
            'True'
        else 
            'False'
    end
{%- endmacro -%}


{%- macro demo_macro() -%}
    {%- set hello = {{select distinct domain_name from SANDBOX.MAHMUD_EXPERIMENT.COMPILED_TECH_MAP }} -%}
    {{hello}}
{%- endmacro -%}