view: anomalous_orders {
  derived_table: {
    sql:
      WITH order_counts AS (
        SELECT
          oi.order_id,
          u.traffic_source,
          COUNT(*) as item_count
        FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
        JOIN `bigquery-public-data.thelook_ecommerce.users` u ON oi.user_id = u.id
        GROUP BY 1, 2
      ),
      stats AS (
        SELECT
          traffic_source,
          AVG(item_count) as avg_items,
          STDDEV(item_count) as stddev_items
        FROM order_counts
        GROUP BY 1
      )
      SELECT
        oc.order_id,
        oc.traffic_source,
        oc.item_count,
        s.avg_items,
        s.stddev_items,
        (oc.item_count - s.avg_items) / NULLIF(s.stddev_items, 0) as z_score
      FROM order_counts oc
      JOIN stats s ON oc.traffic_source = s.traffic_source
    ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    primary_key: yes
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: avg_items {
    type: number
    sql: ${TABLE}.avg_items ;;
  }

  dimension: stddev_items {
    type: number
    sql: ${TABLE}.stddev_items ;;
  }

  dimension: z_score {
    type: number
    sql: ${TABLE}.z_score ;;
  }

  dimension: is_anomalous {
    type: yesno
    sql: ${item_count} > ${avg_items} + 3 * ${stddev_items} ;;
  }
}
