view: products {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.products` ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: distribution_center_id {
    type: number
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Search Google for {{ value }}"
      url: "http://www.google.com/search?q={{ value | encode_uri }}"
      icon_url: "https://www.google.com/favicon.ico"
    }

    link: {
      label: "{{ value }} Dashboard"
      url: "/dashboards/wn53JUCInjuy84CLvOKlGN?category=&department=&Brand={{ value | encode_uri }}"
      icon_url: "/favicon.ico"
    }

  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  measure: total_retail_price {
    type: sum
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: average_retail_price {
    type: average
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: count {
    type: count
  }
}
