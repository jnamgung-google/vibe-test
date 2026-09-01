view: marketing_spend {
  derived_table: {
    sql:
      SELECT
        DATE(created_at) as spend_date,
        traffic_source,
        MAX(CASE
          WHEN traffic_source = 'Search' THEN 1500 + 300 * SIN(EXTRACT(DAYOFYEAR FROM created_at) / 10.0)
          WHEN traffic_source = 'Facebook' THEN 1200 + 250 * SIN(EXTRACT(DAYOFYEAR FROM created_at) / 12.0)
          WHEN traffic_source = 'Display' THEN 800 + 150 * SIN(EXTRACT(DAYOFYEAR FROM created_at) / 15.0)
          ELSE 0
        END) as daily_spend
      FROM `bigquery-public-data.thelook_ecommerce.users`
      WHERE traffic_source IN ('Search', 'Facebook', 'Display')
      GROUP BY 1, 2
      ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.spend_date AS STRING), '_', ${TABLE}.traffic_source) ;;
  }

  dimension: spend_date {
    type: date
    sql: ${TABLE}.spend_date ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: daily_spend {
    type: number
    sql: ${TABLE}.daily_spend ;;
    value_format_name: usd
  }

  measure: total_marketing_spend {
    type: sum
    sql: ${daily_spend} ;;
    value_format_name: usd
    description: "Total de-duplicated marketing spend per channel/date"
  }

  measure: blended_cac {
    type: number
    label: "Blended CAC"
    description: "Total Marketing Spend divided by acquired users count"
    sql: ${total_marketing_spend} / NULLIF(${users.count}, 0) ;;
    value_format_name: usd
  }

  measure: ltv_to_cac_ratio {
    type: number
    label: "LTV:CAC Ratio"
    description: "Average customer lifetime value (LTV) divided by Blended CAC"
    sql: ${users.average_lifetime_revenue} / NULLIF(${blended_cac}, 0) ;;
    value_format_name: decimal_2
  }
}
