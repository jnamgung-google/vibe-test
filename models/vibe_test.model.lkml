connection: "default_bigquery_connection"

include: "/views/**/*.view.lkml"
include: "/dashboards/**/*.dashboard.lookml"

datagroup: vibe_test_datagroup {
  max_cache_age: "0 seconds"
}

persist_with: vibe_test_datagroup


explore: Order_Analysis {
  label: "Order Analysis"
  description: "Explore for order items and related dimensions."
  view_name: order_items
  persist_for: "0 seconds"

  sql_always_where:
    {% if _user_attributes['country'] == '%' or _user_attributes['country'] == nil or _user_attributes['country'] == '' or _user_attributes['country'] == 'Thailand' %}
      1=1
    {% else %}
      ${users.country} = {{ _user_attributes['country'] | sql_quote }}
    {% endif %} ;;

  ## Example of using naive native access_filter instead of sql_always_where:
  ## access_filter: {
  ##   user_attribute: country
  ##   field: users.country
  ## }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: marketing_spend {
    type: left_outer
    sql_on: ${users.created_date} = ${marketing_spend.spend_date}
      and ${users.traffic_source} = ${marketing_spend.traffic_source} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: anomalous_orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${anomalous_orders.order_id} ;;
    relationship: many_to_one
  }

  join: monthly_sales_targets {
    view_label: "Monthly Sales Targets (Writeback)"
    type: left_outer
    sql_on: ${order_items.created_month} = ${monthly_sales_targets.target_month} ;;
    relationship: many_to_one
  }

  join: bqml_customer_segments {
    view_label: "Customer 360 Segmentation (BQML K-Means)"
    type: left_outer
    sql_on: ${users.id} = ${bqml_customer_segments.user_id} ;;
    relationship: many_to_one
  }
}

explore: bqml_sales_forecast {
  label: "BQML Order & Revenue Forecasting"
  description: "Time-series actuals and BQML ARIMA_PLUS future forecasts for daily orders and revenue by marketing traffic source."
  view_name: bqml_sales_forecast
  persist_for: "0 seconds"

  join: bqml_arima_evaluation {
    view_label: "BQML ARIMA Model Diagnostics"
    type: left_outer
    sql_on: ${bqml_sales_forecast.traffic_source} = ${bqml_arima_evaluation.traffic_source} ;;
    relationship: many_to_one
  }

  join: marketing_spend {
    view_label: "Marketing Spend"
    type: left_outer
    sql_on: ${bqml_sales_forecast.forecast_date} = ${marketing_spend.spend_date}
      and ${bqml_sales_forecast.traffic_source} = ${marketing_spend.traffic_source} ;;
    relationship: many_to_one
    fields: [
      marketing_spend.spend_date,
      marketing_spend.traffic_source,
      marketing_spend.daily_spend,
      marketing_spend.total_marketing_spend
    ]
  }
}
