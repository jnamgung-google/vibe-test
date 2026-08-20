view: users {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.users` ;;

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
    description: "Account creation date/time (sign-up date)"
  }

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

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  measure: count {
    type: count
  }

  dimension: is_repeat_customer {
    type: yesno
    description: "Has the customer placed 2 or more orders?"
    sql: (SELECT COUNT(DISTINCT oi.order_id) FROM `bigquery-public-data.thelook_ecommerce.order_items` oi WHERE oi.user_id = ${TABLE}.id) > 1 ;;
  }

  dimension: has_returns {
    type: yesno
    description: "Has the customer returned at least one item?"
    sql: (SELECT COUNT(*) FROM `bigquery-public-data.thelook_ecommerce.order_items` oi WHERE oi.user_id = ${TABLE}.id AND oi.status = 'Returned') > 0 ;;
  }

  measure: count_repeat_customers {
    type: count
    filters: [is_repeat_customer: "yes"]
    description: "Number of repeat customers"
  }

  measure: repeat_customer_rate {
    type: number
    label: "Repeat Customer Rate (%)"
    description: "Percentage of customers who have placed 2 or more orders"
    sql: ${count_repeat_customers} / NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }

  dimension: lifetime_revenue {
    label: "Customer Lifetime Revenue (LTV)"
    description: "Total spent by this customer over their lifetime"
    type: number
    sql: (SELECT COALESCE(SUM(oi.sale_price), 0) FROM `bigquery-public-data.thelook_ecommerce.order_items` oi WHERE oi.user_id = ${TABLE}.id) ;;
    value_format_name: usd
  }

  measure: average_lifetime_revenue {
    label: "Average Customer LTV"
    description: "Average customer lifetime value across the selected cohort of users"
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }
}
