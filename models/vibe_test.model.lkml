connection: "default_bigquery_connection"

include: "/views/**/*.view.lkml"
include: "/dashboards/**/*.dashboard.lookml"

datagroup: vibe_test_datagroup {
  max_cache_age: "1 hour"
}

persist_with: vibe_test_datagroup


explore: Order_Analysis {
  label: "Order Analysis"
  description: "Explore for order items and related dimensions."
  view_name: order_items

  sql_always_where:
    {% if _user_attributes['country'] == '%' or _user_attributes['country'] == nil or _user_attributes['country'] == '' %}
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
}
