view: users {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.users` ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: welcome_banner {
    sql: 'welcome' ;;
    html:  Hello {{ _user_attributes['first_name']}} ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  filter: target_country {
    type: string
    suggest_dimension: country
  }

  dimension: country_comparison {
    type: string
    sql: CASE WHEN {% condition target_country %} ${country} {% endcondition %}
    THEN ${country}
    ELSE 'REST Of the WORLD'
    END;;
  }
  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  measure: count {

    type: count
  }
}
