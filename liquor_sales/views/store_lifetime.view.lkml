view: store_lifetime {
  derived_table: {
    sql:
      SELECT
        store_number,
        MIN(date) as first_purchase_date,
        MAX(date) as last_purchase_date,
        SUM(sale_dollars) as lifetime_revenue,
        SUM(sale_dollars - (state_bottle_cost * bottles_sold)) as lifetime_gross_profit
      FROM `bq1.iowa-liquor-sales`
      GROUP BY 1
    ;;
  }

  dimension: store_number {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.store_number ;;
  }

  dimension_group: first_purchase {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_purchase_date ;;
  }

  dimension_group: last_purchase {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_purchase_date ;;
  }

  dimension: lifetime_revenue {
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: lifetime_gross_profit {
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_gross_profit ;;
  }

  dimension: lifetime_revenue_tier {
    type: tier
    tiers: [0, 1000, 5000, 10000, 50000, 100000]
    style: integer
    sql: ${lifetime_revenue} ;;
  }

  measure: average_lifetime_revenue {
    type: average
    value_format_name: usd
    description: "Average lifetime revenue per store"
    sql: ${lifetime_revenue} ;;
  }

  measure: average_lifetime_gross_profit {
    type: average
    value_format_name: usd
    description: "Average lifetime gross profit per store (LTV)"
    sql: ${lifetime_gross_profit} ;;
  }
}
