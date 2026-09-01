# Define the database connection to be used for this model.
connection: "default_bigquery_connection"

# include all the views
include: "/views/**/*.view.lkml"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: iowa_liquor_sales_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: iowa_liquor_sales_default_datagroup

explore: iowaliquorsales {
  join: uscensus20205yr {
    relationship: many_to_one
    type: left_outer
    sql_on: ${uscensus20205yr.geo_id} = ${iowaliquorsales.zip_code} ;;
  }

  join: store_lifetime {
    type: left_outer
    relationship: many_to_one
    sql_on: ${iowaliquorsales.store_number} = ${store_lifetime.store_number} ;;
  }
}
