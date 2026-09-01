- dashboard: promotion_what_if
  title: "Promotional Scenario What-If & Forecast Analysis"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Simulate promotional pricing and volume lift scenarios to examine net impact on sales, orders, profits, and 30-day outlooks"

  filters:
  - name: created_date
    title: "Baseline Date Range"
    type: date_filter
    default_value: "last 90 days"

  - name: country
    title: "Country Filter"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: users.country

  - name: category
    title: "Product Category"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: products.category

  - name: traffic_source
    title: "User Traffic Source"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: users.traffic_source

  - name: promo_discount
    title: "Simulation: Discount %"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: order_items.promo_discount_percent
    default_value: "10"

  - name: promo_lift
    title: "Simulation: Volume Lift %"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: order_items.promo_volume_lift_percent
    default_value: "20"

  elements:
  # Title Banner Markdown Element
  - name: title_banner
    type: text
    title_text: "Promotion Scenario What-If Modeling Command"
    subtitle_text: "Analyze sales, profit margins, and volume forecast variance under customized pricing and lift assumptions."
    body_text: "Adjust the **Simulation: Discount %** and **Simulation: Volume Lift %** filters to run real-time promotional what-if models. This dashboard evaluates hypothetical sales and gross margins segmented by country, product category, and user acquisition traffic channels, including 30-day forward forecasts."
    row: 0
    col: 0
    width: 24
    height: 3

  # KPI Section Header
  - name: kpi_section_header
    type: text
    title_text: "Executive Summary: Scenario Net Impact Metrics"
    row: 3
    col: 0
    width: 24
    height: 1

  # KPIs Group: Baseline vs Scenario
  - name: baseline_vs_simulated_orders
    title: "Baseline vs. Simulated Orders"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [order_items.total_orders, order_items.simulated_orders]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    colors: ["#74C0FC", "#1C7ED6"]
    row: 4
    col: 0
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: orders_net_impact
    title: "Orders Volume Change (Lift)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.orders_net_impact]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#1C7ED6"
    row: 4
    col: 4
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: baseline_vs_simulated_sales
    title: "Baseline vs. Simulated Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [order_items.total_sales, order_items.simulated_sales]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    colors: ["#8CE99A", "#2B8A3E"]
    row: 4
    col: 8
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: sales_net_impact
    title: "Revenue Net Impact ($)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.sales_net_impact]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#2B8A3E"
    row: 4
    col: 12
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: profit_net_impact_single
    title: "Gross Profit Impact ($)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.profit_net_impact]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#FD7E14"
    row: 4
    col: 16
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: simulated_margin_percent
    title: "Scenario Gross Margin (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.simulated_gross_margin_percent]
    show_single_value_title: true
    show_comparison: false
    custom_color: "#7950F2"
    row: 4
    col: 20
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  # PRODUCT & CATEGORY SECTION
  - name: product_section_header
    type: text
    title_text: "Product Merchandising: Category-Level Promotional Sensitivity"
    row: 7
    col: 0
    width: 24
    height: 1

  - name: category_revenue_simulation
    title: "Revenue Impact: Baseline vs. Simulated Sales by Category"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [products.category, order_items.total_sales, order_items.simulated_sales]
    sorts: [order_items.total_sales desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#D0EBFF", "#1971C2"]
    row: 8
    col: 0
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: category_profit_impact
    title: "Profit Contribution & Sales Lift (%) by Category"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [products.category, order_items.profit_net_impact, order_items.sales_lift_percent]
    sorts: [order_items.profit_net_impact desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    series_types:
      order_items.sales_lift_percent: looker_line
    colors: ["#FD7E14", "#7950F2"]
    row: 8
    col: 12
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  # COUNTRY SECTION
  - name: country_section_header
    type: text
    title_text: "Regional Dynamics: Country-Level Scenario Impact"
    row: 14
    col: 0
    width: 24
    height: 1

  - name: country_revenue_simulation
    title: "Revenue Impact: Baseline vs. Simulated Sales by Country"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.country, order_items.total_sales, order_items.simulated_sales]
    sorts: [order_items.total_sales desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#E5DBFF", "#5F3DC4"]
    row: 15
    col: 0
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: country_profit_impact
    title: "Profit Net Impact & Margin % by Country"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [users.country, order_items.profit_net_impact, order_items.simulated_gross_margin_percent]
    sorts: [order_items.profit_net_impact desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    series_types:
      order_items.simulated_gross_margin_percent: looker_scatter
    colors: ["#E6FCF5", "#0CA678"]
    row: 15
    col: 12
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  # ACQUISITION CHANNEL SECTION
  - name: channel_section_header
    type: text
    title_text: "Acquisition & Traffic Channels: Promo Volume Performance"
    row: 21
    col: 0
    width: 24
    height: 1

  - name: channel_revenue_simulation
    title: "Revenue Impact: Baseline vs. Simulated Sales by Acquisition Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.traffic_source, order_items.total_sales, order_items.simulated_sales]
    sorts: [order_items.total_sales desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#FFF0F6", "#D01C5E"]
    row: 22
    col: 0
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: channel_profit_impact
    title: "Profit Contribution & Sales Lift (%) by Traffic Source"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.traffic_source, order_items.profit_net_impact, order_items.sales_lift_percent]
    sorts: [order_items.profit_net_impact desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    series_types:
      order_items.sales_lift_percent: looker_line
    colors: ["#FD7E14", "#7950F2"]
    row: 22
    col: 12
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  # FORECAST SECTION
  - name: forecast_section_header
    type: text
    title_text: "30-Day Outlook & Future Run-Rate Sales Projection"
    row: 28
    col: 0
    width: 24
    height: 1

  - name: forecast_revenue_projection
    title: "Projected 30-Day Sales Run-Rate: Baseline vs. Simulated Promo"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [order_items.projected_30d_sales_baseline, order_items.projected_30d_sales_simulation]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    colors: ["#FFF9DB", "#F59F00"]
    row: 29
    col: 0
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent

  - name: forecast_orders_projection
    title: "Projected 30-Day Orders Count Run-Rate: Baseline vs. Simulated Promo"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [order_items.projected_30d_orders_baseline, order_items.projected_30d_orders_simulation]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: false
    show_x_axis_ticks: true
    colors: ["#FFF0F6", "#E64980"]
    row: 29
    col: 12
    width: 12
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
      traffic_source: users.traffic_source
      promo_discount: order_items.promo_discount_percent
      promo_lift: order_items.promo_volume_lift_percent
