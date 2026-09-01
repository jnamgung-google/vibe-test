- dashboard: ecommerce_performance
  title: "E-Commerce Executive Hub & User Acquisition ROI"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Executive Command Center & Acquisition Performance Tracking"

  filters:
  - name: created_date
    title: "Created Date"
    type: date_filter
    default_value: "last 365 days"

  - name: country
    title: "Country"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: users.country

  - name: category
    title: "Category"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: products.category

  - name: traffic_source
    title: "Traffic Source"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: users.traffic_source

  elements:
  # Title Banner Markdown Element
  - name: title_banner
    type: text
    title_text: "E-Commerce Executive Command Dashboard"
    subtitle_text: "Sales, Operations, Customer Lifetime Value (LTV), and marketing Acquisition ROI"
    body_text: "Welcome to the E-Commerce Executive Command Center. This dashboard helps track core operational growth, user acquisition CAC, return rates, inventory levels, and geographic cohorts. Use filters to query specific date ranges, countries, channels, and product categories."
    row: 0
    col: 0
    width: 24
    height: 3

  # ROW 1: Executive KPI Panel (H3)
  - name: kpi_sales_revenue
    title: "Sales Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_sales]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#1A73E8"
    row: 3
    col: 0
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: kpi_gross_profit
    title: "Gross Profit"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_gross_profit]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#12B886"
    row: 3
    col: 3
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: kpi_profit_margin
    title: "Gross Margin (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.gross_profit_margin]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#E28743"
    row: 3
    col: 6
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: kpi_total_orders
    title: "Total Orders"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_orders]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#862E9C"
    row: 3
    col: 9
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: kpi_average_order_value
    title: "AOV"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.average_order_value]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#4C6EF5"
    row: 3
    col: 12
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: kpi_item_return_rate
    title: "Return Rate (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.item_return_rate]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#FA5252"
    row: 3
    col: 15
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: kpi_repeat_customer_rate
    title: "Repeat Cust. Rate (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [users.repeat_customer_rate]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#7950F2"
    row: 3
    col: 18
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: kpi_blended_cac
    title: "Blended CAC"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [marketing_spend.blended_cac]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#FD7E14"
    row: 3
    col: 21
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  # ROW 2: Sales Trends Header (H1)
  - name: sales_trends_header
    type: text
    title_text: "Sales Operations & Revenue Trends"
    subtitle_text: "Underlying revenue metrics, margins, and customer retention kinetics"
    row: 6
    col: 0
    width: 24
    height: 1

  # ROW 2: Sales Trends Charts
  - name: monthly_revenue_and_profit
    title: "Monthly Revenue & Gross Profit Trend"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [order_items.created_month, order_items.total_sales, order_items.total_gross_profit]
    sorts: [order_items.created_month]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#1A73E8", "#12B886"]
    row: 7
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: monthly_aov_trend
    title: "Monthly Average Order Value (AOV) Trend"
    model: vibe_test
    explore: Order_Analysis
    type: looker_line
    fields: [order_items.created_month, order_items.average_order_value]
    sorts: [order_items.created_month]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#4C6EF5"]
    row: 7
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: monthly_repeat_customer_share
    title: "Repeat Customer Revenue Share Trend (%)"
    model: vibe_test
    explore: Order_Analysis
    type: looker_line
    fields: [order_items.created_month, order_items.repeat_customer_revenue_share]
    sorts: [order_items.created_month]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#7950F2"]
    row: 7
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  # ROW 3: Acquisition Header (H1)
  - name: acquisition_channels_header
    type: text
    title_text: "Customer Acquisition Analytics & Marketing Spend ROI"
    subtitle_text: "Track user growth cost efficiency (CAC) and LTV performance by channel"
    row: 13
    col: 0
    width: 24
    height: 1

  # ROW 3: Acquisition & CAC Charts
  - name: cac_by_channel
    title: "Blended CAC by Traffic Source Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [marketing_spend.traffic_source, marketing_spend.blended_cac]
    sorts: [marketing_spend.blended_cac desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#FD7E14"]
    row: 14
    col: 0
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: ltv_cac_ratio_by_channel
    title: "LTV:CAC Ratio by Traffic Source Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [marketing_spend.traffic_source, marketing_spend.ltv_to_cac_ratio]
    sorts: [marketing_spend.ltv_to_cac_ratio desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#12B886"]
    row: 14
    col: 6
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: signups_vs_spend_by_channel
    title: "Acquired Customers vs. Marketing Spend"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [marketing_spend.traffic_source, users.count, marketing_spend.total_marketing_spend]
    sorts: [users.count desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    row: 14
    col: 12
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: monthly_signup_cohorts
    title: "Monthly User Acquired Cohorts by Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.created_month, users.traffic_source, users.count]
    pivots: [users.traffic_source]
    sorts: [users.created_month]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    stacking: normal
    row: 14
    col: 18
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  # ROW 4: Merchandising Header (H1)
  - name: merchandising_header
    type: text
    title_text: "Merchandising & Product Performance Analytics"
    subtitle_text: "Core profitability margins, top category drivers, and return risk analysis"
    row: 20
    col: 0
    width: 24
    height: 1

  # ROW 4: Merchandising Charts
  - name: top_categories_revenue
    title: "Top 10 Product Categories by Sales & Profit"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [products.category, order_items.total_sales, order_items.total_gross_profit]
    sorts: [order_items.total_sales desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#1A73E8", "#12B886"]
    row: 21
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: category_return_rates
    title: "Product Category Return Rates (%)"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [products.category, order_items.item_return_rate]
    sorts: [order_items.item_return_rate desc]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#FA5252"]
    row: 21
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: top_brands_sales
    title: "Top 10 Brands by Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [products.brand, order_items.total_sales]
    sorts: [order_items.total_sales desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#4C6EF5"]
    row: 21
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  # ROW 5: Demographics Header (H1)
  - name: demographics_header
    type: text
    title_text: "User Demographics & Regional Dynamics"
    subtitle_text: "Analyze high value customer clusters, locations, and gender preferences"
    row: 27
    col: 0
    width: 24
    height: 1

  # ROW 5: Demographics Charts
  - name: customer_ltv_by_country
    title: "Customer Lifetime Value (LTV) by Country"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [users.country, users.average_lifetime_revenue]
    sorts: [users.average_lifetime_revenue desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#FD7E14"]
    row: 28
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: users_and_repeat_by_country
    title: "Customer Volume & Repeat Purchase Rates by Country"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.country, users.count, users.repeat_customer_rate]
    sorts: [users.count desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    row: 28
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: gender_distribution
    title: "Sales Distribution by Gender"
    model: vibe_test
    explore: Order_Analysis
    type: looker_pie
    fields: [users.gender, order_items.total_sales]
    value_labels: legend
    label_type: labPer
    row: 28
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  # ROW 6: Logistics Header (H1)
  - name: logistics_header
    type: text
    title_text: "Operations, Warehousing and Logistics Insights"
    subtitle_text: "Inventory level controls, logistics allocations, and regional profits"
    row: 34
    col: 0
    width: 24
    height: 1

  # ROW 6: Logistics Charts
  - name: warehouse_inventory
    title: "Total Inventory Volumes by Warehouse Center"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [distribution_centers.name, inventory_items.count]
    sorts: [inventory_items.count desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#12B886"]
    row: 35
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: warehouse_profit_margins
    title: "Gross Profit margin by Warehouse Center"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [distribution_centers.name, order_items.total_gross_profit]
    sorts: [order_items.total_gross_profit desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#E28743"]
    row: 35
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source

  - name: warehouse_order_volumes
    title: "Total Shipped Order Volume by Warehouse"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [distribution_centers.name, order_items.total_orders]
    sorts: [order_items.total_orders desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#4C6EF5"]
    row: 35
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
