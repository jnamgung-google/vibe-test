# The name of this view in Looker is "Iowaliquorsales"
view: iowaliquorsales {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `bq1.iowa-liquor-sales` ;;


  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: invoice_and_item_number {
    description: "A unique identifier for each specific item within an invoice."
    primary_key: yes
    type: string
    sql: ${TABLE}.invoice_and_item_number ;;
  }
    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Address" in Explore.
  dimension_group: sale_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: zip_code {
    type: zipcode
    value_format_name: id
    sql: ${TABLE}.zip_code ;;
  }

  dimension: store_location {
    type: string
    sql: ${TABLE}.store_location ;;
  }

  dimension: store_name {
    type: string
    sql: ${TABLE}.store_name ;;
  }

  dimension: store_number {
    type: string
    sql: ${TABLE}.store_number ;;
  }

  dimension: months_since_acquisition {
    type: number
    description: "Months since the store's first purchase"
    sql: DATE_DIFF(${sale_date_date}, ${store_lifetime.first_purchase_date}, MONTH) ;;
  }

  dimension: is_new_customer {
    type: yesno
    description: "True if the sale occurred on the store's first purchase date"
    sql: ${sale_date_date} = ${store_lifetime.first_purchase_date} ;;
  }

  dimension: vendor_name {
    type: string
    sql: ${TABLE}.vendor_name ;;
  }

  dimension: vendor_number {
    type: string
    hidden: yes
    sql: ${TABLE}.vendor_number ;;
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
  }

  dimension: item_description {
    type: string
    sql: ${TABLE}.item_description ;;
  }

  dimension: item_number {
    type: string
    sql: ${TABLE}.item_number ;;
  }

  dimension: bottle_volume_ml {
    type: number
    sql: ${TABLE}.bottle_volume_ml ;;
  }

  dimension: pack {
    type: number
    sql: ${TABLE}.pack ;;
  }



  measure: bottles_sold {
    type: sum
    sql: ${TABLE}.bottles_sold  ;;
    drill_fields: [county, city, category_name, vendor_name, item_description, bottle_volume_ml, store_name]
  }

  measure: sale_amt_usd {
    type: sum
    sql: ${TABLE}.sale_dollars  ;;
    value_format_name: usd_0
    drill_fields: [county, city, category_name, vendor_name, item_description, bottle_volume_ml, store_name]
  }

  dimension: cost_per_bottle {
    type: number
    sql: ${TABLE}.state_bottle_cost ;;
  }

  dimension: retail_price_per_bottle {
    type: number
    sql: ${TABLE}.state_bottle_retail ;;
  }

  measure : bottle_cost{
    type: sum
    value_format_name: usd_0
    sql: ${cost_per_bottle} ;;
  }

  measure: total_cost_cogs {
    type: sum
    value_format_name: usd_0
    description: "Total Cost of Goods Sold (state_bottle_cost * bottles_sold)"
    sql: ${TABLE}.state_bottle_cost * ${TABLE}.bottles_sold ;;
  }

  measure: total_gross_profit {
    type: sum
    value_format_name: usd_0
    description: "Total Gross Profit (Revenue - COGS)"
    sql: ${TABLE}.sale_dollars - (${TABLE}.state_bottle_cost * ${TABLE}.bottles_sold) ;;
  }

  measure: gross_margin_percent {
    type: number
    value_format_name: percent_2
    description: "Gross Margin Percentage"
    sql: ${total_gross_profit} / NULLIF(${sale_amt_usd}, 0) ;;
  }

  measure: active_stores_count {
    type: count_distinct
    description: "Number of unique active stores"
    sql: ${store_number} ;;
  }

  measure: new_stores_count {
    type: count_distinct
    description: "Number of stores acquired (first purchase in this period)"
    sql: CASE WHEN ${is_new_customer} THEN ${store_number} ELSE NULL END ;;
  }

  measure: volume_sold_gallons {
    type: number
    sql: ${TABLE}.volume_sold_gallons ;;
  }

  measure: volume_sold_liters {
    type: number
    sql: ${TABLE}.volume_sold_liters ;;
  }

  measure: consumption_per_capita {
    type: number
    sql: ${volume_sold_liters} / ${uscensus20205yr.total_population} ;;
  }
  measure: spending_per_capita {
    type: number
    value_format_name: usd
    sql: ${volume_sold_liters} / ${uscensus20205yr.total_population} ;;
  }

  parameter: total_cac_spend {
    type: number
    default_value: "0"
    description: "Enter total marketing/sales spend for the period to calculate CAC"
  }

  measure: calculated_cac {
    type: number
    value_format_name: usd
    description: "Calculated Customer Acquisition Cost (CAC Spend / New Stores)"
    sql: {% parameter total_cac_spend %} / NULLIF(${new_stores_count}, 0) ;;
  }

  measure: ltv_to_cac_ratio {
    type: number
    value_format_name: decimal_2
    description: "LTV to CAC Ratio (requires Avg Lifetime Gross Profit and CAC Spend)"
    sql: ${store_lifetime.average_lifetime_gross_profit} / NULLIF(${calculated_cac}, 0) ;;
  }
}
