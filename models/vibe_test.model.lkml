connection: "default_bigquery_connection"

include: "/views/**/*.view.lkml"

datagroup: vibe_test_datagroup {
  max_cache_age: "1 hour"
}

persist_with: vibe_test_datagroup

explore: Order_Analysis {
  label: "Order Analysis"
  description: "Explore for order items and related dimensions."
  view_name: order_items
  
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
