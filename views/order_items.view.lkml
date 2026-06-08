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

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    description: "Total sales amount"
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
}
