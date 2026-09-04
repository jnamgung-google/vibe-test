include: "/views/calendar.view.lkml"

view: order_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.order_items` ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    description: "The order item's processing status (e.g., Completed, Shipped, Processing, Returned, Cancelled)"
  }

  # ============================================================================
  # BigQuery Writeback Action (Best Practice: Cloud Run Functions -> BigQuery)
  # ============================================================================
  dimension: writeback_action {
    label: "Demo BigQuery Writeback"
    type: string
    sql: 'Send to BigQuery' ;;
    description: "Trigger writeback action to append order review into BigQuery demo_table"
    action: {
      label: "Demo BigQuery Insert"
      url: "https://demo-bq-insert-action-ipxtzv6mmq-uc.a.run.app/action-0/execute"
      icon_url: "https://cloud.google.com/images/favicon.ico"
      form_param: {
        name: "choice"
        type: select
        label: "Choose"
        required: yes
        default: "Yes"
        option: {
          name: "Yes"
          label: "Yes"
        }
        option: {
          name: "No"
          label: "No"
        }
        option: {
          name: "Maybe"
          label: "Maybe"
        }
      }
      form_param: {
        name: "note"
        type: textarea
        label: "Note"
        required: no
      }
      param: {
        name: "order_id"
        value: "{{ order_id._value }}"
      }
      user_attribute_param: {
        user_attribute: "email"
        name: "email"
      }
    }
  }

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
    description: "The date and time this order item was created"
  }

  dimension_group: shipped {
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
    sql: ${TABLE}.shipped_at ;;
    description: "The date and time this order item was shipped"
  }

  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
    description: "The date and time this order item was delivered"
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
    description: "The date and time this order item was returned"
  }

  dimension: days_to_return {
    type: number
    sql: TIMESTAMP_DIFF(${returned_raw}, ${delivered_raw}, DAY) ;;
    description: "Number of days between delivery and return"
  }

  dimension_group: created {
    type: custom_calendar
    # Optional list of allowed timeframes
    custom_timeframes: [
      custom_week,
      custom_quarter,
      custom_year
    ]
    sql: ${TABLE}.created_at ;;
    based_on_calendar: calendar
  }

  dimension: 445_week_no {
    type: number
    group_label: "Created Date"
    description: "Use this dimension as rows and pivot by Year to get side-by-side YoY analysis"
    sql: (
      SELECT calendar_week_num
      FROM `eco-shift-478607-e5.bq1.calendar`
      WHERE reference_date = DATE(${TABLE}.created_at)
    ) ;;
  }


  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    description: "Total sales amount"
  }

  measure: total_sales_yoy_growth_rate {
    type: period_over_period
    label: "Sales YoY Growth %"
    based_on: total_sales
    based_on_time: created_custom_year
    custom_calendar_period: custom_year
    kind: relative_change              # Automatically calculates ((Current - Prior) / Prior)
    value_format_name: percent_1
  }

  measure: total_sales_yoy_growth_rate_445 {
    type: period_over_period
    label: "Sales YoY Growth % - 445"
    based_on: total_sales
    based_on_time: created_custom_week
    custom_calendar_period: custom_year
    kind: relative_change              # Automatically calculates ((Current - Prior) / Prior)
    value_format_name: percent_1
  }


  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_gross_profit {
    type: number
    label: "Total Gross Profit"
    description: "Total Sales Revenue minus Total Inventory Cost"
    sql: ${total_sales} - ${inventory_items.total_cost} ;;
    value_format_name: usd
  }

  measure: gross_profit_margin {
    type: number
    label: "Gross Profit Margin (%)"
    description: "Gross Profit expressed as a percentage of total sales revenue"
    sql: ${total_gross_profit} / NULLIF(${total_sales}, 0) ;;
    value_format_name: percent_2
  }

  measure: average_order_value {
    type: number
    label: "Average Order Value (AOV)"
    description: "Average revenue generated per order"
    sql: ${total_sales} / NULLIF(${total_orders}, 0) ;;
    value_format_name: usd
  }

  measure: count {
    type: count
  }

  measure: average_basket_size {
    type: number
    label: "Average Basket Size"
    description: "Average number of items per unique order"
    sql: ${count} / NULLIF(${total_orders}, 0) ;;
    value_format_name: decimal_2
  }

  measure: count_returned_items {
    type: count
    label: "Returned Items Count"
    description: "Number of order items that were returned"
    filters: [status: "Returned"]
  }

  measure: item_return_rate {
    type: number
    label: "Item Return Rate (%)"
    description: "Percentage of ordered items that were returned"
    sql: ${count_returned_items} / NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_orders {
    type: count_distinct
    sql: ${order_id} ;;
    description: "Total number of unique orders reference"
  }

  measure: count_orders_with_returns {
    type: count_distinct
    sql: ${order_id} ;;
    filters: [status: "Returned"]
    description: "Number of unique orders with at least one returned item"
  }

  measure: order_return_rate {
    type: number
    label: "Order Return Rate (%)"
    description: "Percentage of unique orders that had at least one item returned"
    sql: ${count_orders_with_returns} / NULLIF(${total_orders}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_returned_value {
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "Returned"]
    value_format_name: usd
    description: "Total sale price value of returned items"
  }

  measure: return_value_rate {
    type: number
    label: "Return Value Rate (%)"
    description: "Total returned value divided by total sales revenue"
    sql: ${total_returned_value} / NULLIF(${total_sales}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_returned_cost {
    type: sum
    sql: ${inventory_items.cost} ;;
    filters: [status: "Returned"]
    value_format_name: usd
    description: "Total cost of returned items (inventory loss)"
  }

  measure: average_days_to_return {
    type: average
    sql: ${days_to_return} ;;
    value_format_name: decimal_1
    description: "Average number of days between delivery and return"
  }

  measure: count_returned_items_repeat_customers {
    type: count
    filters: [status: "Returned", users.is_repeat_customer: "yes"]
    hidden: yes
  }

  measure: count_items_repeat_customers {
    type: count
    filters: [users.is_repeat_customer: "yes"]
    hidden: yes
  }

  measure: repeat_customer_return_rate {
    type: number
    label: "Repeat Customer Return Rate (%)"
    description: "Percentage of items returned by repeat customers relative to their total purchases"
    sql: ${count_returned_items_repeat_customers} / NULLIF(${count_items_repeat_customers}, 0) ;;
    value_format_name: percent_2
  }

  measure: repeat_customer_sales {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_repeat_customer: "yes"]
    value_format_name: usd
    description: "Total sales revenue from repeat customers"
  }

  measure: repeat_customer_revenue_share {
    type: number
    label: "Repeat Customer Revenue Share (%)"
    description: "Percentage of total sales revenue originating from repeat customers"
    sql: ${repeat_customer_sales} / NULLIF(${total_sales}, 0) ;;
    value_format_name: percent_2
  }

  # ==========================================
  # PROMOTION WHAT-IF ANALYSIS AND FORECASTING
  # ==========================================

  parameter: promo_discount_percent {
    type: number
    label: "Select Discount (%)"
    description: "Discount percentage for simulated promo scenario"
    default_value: "0"
    allowed_value: { label: "0% (No Discount)" value: "0" }
    allowed_value: { label: "5%" value: "5" }
    allowed_value: { label: "10%" value: "10" }
    allowed_value: { label: "15%" value: "15" }
    allowed_value: { label: "20%" value: "20" }
    allowed_value: { label: "25%" value: "25" }
    allowed_value: { label: "30%" value: "30" }
    allowed_value: { label: "40%" value: "40" }
    allowed_value: { label: "50%" value: "50" }
  }

  parameter: promo_volume_lift_percent {
    type: number
    label: "Select Volume Lift (%)"
    description: "Estimated order volume increase under promo scenario"
    default_value: "0"
    allowed_value: { label: "0% (No Volume Lift)" value: "0" }
    allowed_value: { label: "5% Lift" value: "5" }
    allowed_value: { label: "10% Lift" value: "10" }
    allowed_value: { label: "15% Lift" value: "15" }
    allowed_value: { label: "20% Lift" value: "20" }
    allowed_value: { label: "30% Lift" value: "30" }
    allowed_value: { label: "50% Lift" value: "50" }
    allowed_value: { label: "75% Lift" value: "75" }
    allowed_value: { label: "100% Lift (Double)" value: "100" }
  }

  measure: simulated_orders {
    type: number
    label: "Simulated Orders"
    description: "Baseline orders scaled by volume lift"
    sql: ${total_orders} * (1 + ({% parameter promo_volume_lift_percent %} / 100.0)) ;;
    value_format_name: decimal_0
  }

  measure: simulated_sales {
    type: number
    label: "Simulated Sales"
    description: "Baseline sales scaled by volume lift and reduced by discount"
    sql: ${total_sales} * (1 + ({% parameter promo_volume_lift_percent %} / 100.0)) * (1 - ({% parameter promo_discount_percent %} / 100.0)) ;;
    value_format_name: usd
  }

  measure: simulated_cost {
    type: number
    label: "Simulated Cost"
    hidden: yes
    sql: ${inventory_items.total_cost} * (1 + ({% parameter promo_volume_lift_percent %} / 100.0)) ;;
    value_format_name: usd
  }

  measure: simulated_gross_profit {
    type: number
    label: "Simulated Gross Profit"
    description: "Simulated Sales minus Simulated Cost"
    sql: ${simulated_sales} - ${simulated_cost} ;;
    value_format_name: usd
  }

  measure: simulated_gross_margin_percent {
    type: number
    label: "Simulated Gross Margin (%)"
    description: "Simulated Gross Profit divided by Simulated Sales"
    sql: ${simulated_gross_profit} / NULLIF(${simulated_sales}, 0) ;;
    value_format_name: percent_2
  }

  measure: orders_net_impact {
    type: number
    label: "Orders Net Impact"
    description: "Simulated Orders minus Baseline Orders"
    sql: ${simulated_orders} - ${total_orders} ;;
    value_format_name: decimal_0
  }

  measure: sales_net_impact {
    type: number
    label: "Sales Net Impact"
    description: "Simulated Sales minus Baseline Sales"
    sql: ${simulated_sales} - ${total_sales} ;;
    value_format_name: usd
  }

  measure: profit_net_impact {
    type: number
    label: "Profit Net Impact"
    description: "Simulated Gross Profit minus Baseline Gross Profit"
    sql: ${simulated_gross_profit} - ${total_gross_profit} ;;
    value_format_name: usd
  }

  measure: sales_lift_percent {
    type: number
    label: "Sales Lift (%)"
    description: "Percent change in sales under simulated promo scenario"
    sql: (${simulated_sales} - ${total_sales}) / NULLIF(${total_sales}, 0) ;;
    value_format_name: percent_2
  }

  measure: profit_lift_percent {
    type: number
    label: "Profit Lift (%)"
    description: "Percent change in gross profit under simulated promo scenario"
    sql: (${simulated_gross_profit} - ${total_gross_profit}) / NULLIF(${total_gross_profit}, 0) ;;
    value_format_name: percent_2
  }

  measure: days_in_period {
    type: count_distinct
    label: "Days in Period"
    hidden: yes
    sql: DATE(${created_date}) ;;
  }

  measure: baseline_daily_run_rate_sales {
    type: number
    label: "Baseline Daily Run Rate (Sales)"
    hidden: yes
    sql: ${total_sales} / NULLIF(${days_in_period}, 0) ;;
    value_format_name: usd
  }

  measure: simulated_daily_run_rate_sales {
    type: number
    label: "Simulated Daily Run Rate (Sales)"
    hidden: yes
    sql: ${simulated_sales} / NULLIF(${days_in_period}, 0) ;;
    value_format_name: usd
  }

  measure: projected_30d_sales_baseline {
    type: number
    label: "Projected 30D Revenue (Baseline)"
    description: "Baseline 30-day projected sales run-rate"
    sql: ${baseline_daily_run_rate_sales} * 30 ;;
    value_format_name: usd
  }

  measure: projected_30d_sales_simulation {
    type: number
    label: "Projected 30D Revenue (Scenario)"
    description: "Simulated 30-day projected sales run-rate"
    sql: ${simulated_daily_run_rate_sales} * 30 ;;
    value_format_name: usd
  }

  measure: projected_30d_sales_impact {
    type: number
    label: "Projected 30D Revenue Impact"
    description: "Difference in projected 30-day revenue under promotion"
    sql: ${projected_30d_sales_simulation} - ${projected_30d_sales_baseline} ;;
    value_format_name: usd
  }

  measure: baseline_daily_run_rate_orders {
    type: number
    label: "Baseline Daily Run Rate (Orders)"
    hidden: yes
    sql: ${total_orders} / NULLIF(${days_in_period}, 0) ;;
    value_format_name: decimal_0
  }

  measure: simulated_daily_run_rate_orders {
    type: number
    label: "Simulated Daily Run Rate (Orders)"
    hidden: yes
    sql: ${simulated_orders} / NULLIF(${days_in_period}, 0) ;;
    value_format_name: decimal_0
  }

  measure: projected_30d_orders_baseline {
    type: number
    label: "Projected 30D Orders (Baseline)"
    description: "Baseline 30-day projected orders run-rate"
    sql: ${baseline_daily_run_rate_orders} * 30 ;;
    value_format_name: decimal_0
  }

  measure: projected_30d_orders_simulation {
    type: number
    label: "Projected 30D Orders (Scenario)"
    description: "Simulated 30-day projected orders run-rate"
    sql: ${simulated_daily_run_rate_orders} * 30 ;;
    value_format_name: decimal_0
  }

  measure: projected_30d_orders_impact {
    type: number
    label: "Projected 30D Orders Impact"
    description: "Difference in projected 30-day orders under promotion"
    sql: ${projected_30d_orders_simulation} - ${projected_30d_orders_baseline} ;;
    value_format_name: decimal_0
  }
}
