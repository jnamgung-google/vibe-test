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

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Iowa-liquor-sales"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: iowaliquorsales {
  join: uscensus20205yr {
    relationship: many_to_one
    type: left_outer
    sql_on: ${uscensus20205yr.geo_id} = ${iowaliquorsales.zip_code} ;;
  }

  join: iowaavgdailytemp2025 {
    type: left_outer
    relationship: many_to_one
    sql_on: ${iowaavgdailytemp2025.date_date} = ${iowaliquorsales.sale_date_date} ;;
  }

  join: store_lifetime {
    type: left_outer
    relationship: many_to_one
    sql_on: ${iowaliquorsales.store_number} = ${store_lifetime.store_number} ;;
  }
}
