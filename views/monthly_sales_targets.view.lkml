view: monthly_sales_targets {
  label: "Monthly Sales Targets (Writeback)"
  derived_table: {
    sql:
      WITH default_months AS (
        SELECT
          FORMAT_DATE('%Y-%m', month_date) AS target_month,
          CASE
            WHEN EXTRACT(YEAR FROM month_date) <= 2024 THEN 100000.0
            WHEN EXTRACT(YEAR FROM month_date) = 2025 THEN 120000.0
            ELSE 150000.0
          END AS target_amount,
          'system-default@google.com' AS updated_by,
          TIMESTAMP('2024-01-01 00:00:00 UTC') AS updated_at,
          'Baseline Monthly Target' AS note
        FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', '2027-12-01', INTERVAL 1 MONTH)) AS month_date
      ),
      combined AS (
        SELECT target_month, target_amount, updated_by, updated_at, note
        FROM `eco-shift-478607-e5.demo_dataset.monthly_sales_targets`
        UNION ALL
        SELECT target_month, target_amount, updated_by, updated_at, note
        FROM default_months
      ),
      ranked AS (
        SELECT
          target_month,
          target_amount,
          updated_by,
          updated_at,
          note,
          ROW_NUMBER() OVER (PARTITION BY target_month ORDER BY updated_at DESC) AS rn
        FROM combined
      )
      SELECT
        target_month,
        target_amount,
        updated_by,
        updated_at,
        note
      FROM ranked
      WHERE rn = 1 ;;
  }

  dimension: target_month {
    primary_key: yes
    label: "Target Month (YYYY-MM)"
    type: string
    sql: ${TABLE}.target_month ;;
    description: "Year-Month in YYYY-MM format (e.g., 2026-09). Click '...' to update the monthly sales price target."
    tags: ["demo-bq-insert"]
  }

  dimension: target_amount_dim {
    label: "Monthly Sales Target Dimension ($)"
    type: number
    sql: ${TABLE}.target_amount ;;
    value_format_name: usd_0
    tags: ["demo-bq-insert"]
  }

  measure: monthly_sales_target {
    label: "Monthly Sales Price Target ($)"
    type: sum_distinct
    sql_distinct_key: ${target_month} ;;
    sql: ${TABLE}.target_amount ;;
    value_format_name: usd_0
    description: "Active Monthly Sales Price Target from BigQuery (click '...' on Month or Target to update)"
    tags: ["demo-bq-insert"]
  }

  measure: sales_vs_target_variance {
    label: "Sales vs Target Variance ($)"
    type: number
    sql: ${order_items.total_sales} - ${monthly_sales_target} ;;
    value_format_name: usd_0
    description: "Actual Total Sales Price minus Monthly Sales Price Target"
  }

  measure: target_achievement_rate {
    label: "Target Achievement (%)"
    type: number
    sql: SAFE_DIVIDE(${order_items.total_sales}, ${monthly_sales_target}) ;;
    value_format_name: percent_1
    description: "Actual Total Sales Price as a percentage of Monthly Sales Price Target"
  }

  dimension: updated_by {
    label: "Target Last Updated By"
    type: string
    sql: ${TABLE}.updated_by ;;
  }

  dimension_group: updated {
    label: "Target Last Updated"
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: note {
    label: "Target Adjustment Reason / Note"
    type: string
    sql: ${TABLE}.note ;;
  }
}
