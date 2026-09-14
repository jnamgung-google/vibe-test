- dashboard: ecommerce_operations
  title: "E-Commerce Business Operations & Performance"
  layout: newspaper
  preferred_viewer: dashboards-next

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

  elements:
  - name: title_banner
    type: text
    title_text: ""
    subtitle_text: ""
    body_text: |
      <div style="display: flex; gap: 12px; border-bottom: 2px solid #E0E0E0; padding-bottom: 12px; margin-bottom: 8px; align-items: center;">
        <a href="/dashboards/vibe_test::ecommerce_operations" style="padding: 10px 20px; border-radius: 8px; background-color: #1A73E8; color: #FFFFFF; text-decoration: none; font-weight: 600; font-size: 14px; box-shadow: 0 2px 5px rgba(26,115,232,0.3);">
          📊 Tab 1: Business Operations Overview
        </a>
        <a href="/dashboards/vibe_test::ecommerce_target_performance" style="padding: 10px 20px; border-radius: 8px; background-color: #F1F3F4; color: #3C4043; text-decoration: none; font-weight: 600; font-size: 14px;">
          🎯 Tab 2: Performance vs. Target (Interactive Writeback)
        </a>
      </div>
      <div style="padding: 4px 2px; color: #5F6368; font-size: 13px;">
        <b>E-Commerce Executive Hub:</b> Monitor real-time sales, profitability margins, item returns, customer demographics, and monthly sales target achievement. Switch to <b>Tab 2</b> above or scroll down to view & edit Monthly Sales Price Targets directly in BigQuery.
      </div>
    row: 0
    col: 0
    width: 24
    height: 3

  - name: kpi_total_revenue
    title: "Total Sales Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_sales]
    limit: 500
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color: "#1A73E8"
    row: 3
    col: 0
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: kpi_total_profit
    title: "Gross Profit"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_gross_profit]
    limit: 500
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color: "#12B886"
    row: 3
    col: 4
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: kpi_profit_margin
    title: "Gross Profit Margin (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.gross_profit_margin]
    limit: 500
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color: "#E28743"
    row: 3
    col: 8
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: kpi_total_orders
    title: "Total Orders"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_orders]
    limit: 500
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color: "#862E9C"
    row: 3
    col: 12
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: kpi_return_rate
    title: "Item Return Rate (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.item_return_rate]
    limit: 500
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color: "#FA5252"
    row: 3
    col: 16
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: kpi_basket_size
    title: "Average Basket Size"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.average_basket_size]
    limit: 500
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color: "#4C6EF5"
    row: 3
    col: 20
    width: 4
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: sales_trends_header
    type: text
    title_text: "Sales Operations & Revenue Trends"
    subtitle_text: "Understand transaction behavior and profit growth"
    row: 6
    col: 0
    width: 24
    height: 1

  - name: monthly_sales_revenue
    title: "Monthly Sales Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: looker_line
    fields: [order_items.created_month, order_items.total_sales]
    sorts: [order_items.created_month]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    row: 7
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: monthly_profit_vs_sales
    title: "Monthly Revenue & Gross Profit Comparison"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [order_items.created_month, order_items.total_sales, order_items.total_gross_profit]
    sorts: [order_items.created_month]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    stacking: ""
    colors: ["#1A73E8", "#12B886"]
    row: 7
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: monthly_average_order_value_trend
    title: "Average Order Value (AOV) Trend"
    model: vibe_test
    explore: Order_Analysis
    type: looker_line
    fields: [order_items.created_month, order_items.average_sale_price]
    sorts: [order_items.created_month]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    row: 7
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: product_analytics_header
    type: text
    title_text: "Product Performance & Merchandising Insights"
    subtitle_text: "Top category drivers, brand leaders, margin analysis, and returns"
    row: 13
    col: 0
    width: 24
    height: 1

  - name: top_product_categories
    title: "Top 10 Product Categories by Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [products.category, order_items.total_sales]
    sorts: [order_items.total_sales desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    row: 14
    col: 0
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: top_selling_brands
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
    row: 14
    col: 12
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: return_rate_by_category
    title: "Return Rates by Product Category"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [products.category, order_items.item_return_rate]
    sorts: [order_items.item_return_rate desc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#FA5252"]
    row: 22
    col: 0
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: lowest_margin_categories
    title: "Lowest Margin Categories"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [products.category, order_items.gross_profit_margin]
    sorts: [order_items.gross_profit_margin]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    colors: ["#E28743"]
    row: 22
    col: 12
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: customer_analytics_header
    type: text
    title_text: "Customer & Acquisition Analytics"
    subtitle_text: "Acquisition channels, country breakdown, gender preferences, and LTV profiles"
    row: 30
    col: 0
    width: 24
    height: 1

  - name: customers_by_country
    title: "Unique Customers by Country"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.country, order_items.total_sales]
    limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    row: 31
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: sales_by_gender
    title: "Revenue Distribution by User Gender"
    model: vibe_test
    explore: Order_Analysis
    type: looker_pie
    fields: [users.gender, order_items.total_sales]
    value_labels: legend
    label_type: labPer
    row: 31
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: acquisition_traffic_sources
    title: "Top Customer Acquisition Traffic Sources"
    model: vibe_test
    explore: Order_Analysis
    type: looker_pie
    fields: [users.traffic_source, users.count]
    value_labels: legend
    label_type: labPer
    row: 31
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: ltv_by_country
    title: "Customer Lifetime Value (LTV) by Country"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [users.country, users.average_lifetime_revenue]
    sorts: [users.average_lifetime_revenue desc]
    limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    row: 37
    col: 0
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: customer_count_by_traffic_source
    title: "Customer Count by Traffic Source"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.traffic_source, users.count]
    sorts: [users.count desc]
    limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    row: 37
    col: 12
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: logistics_header
    type: text
    title_text: "Logistical & Distribution Performance"
    subtitle_text: "Inventory distributions, sales regions, and margin contribution by warehouse"
    row: 45
    col: 0
    width: 24
    height: 1

  - name: inventory_by_distribution_center
    title: "Warehouse Inventory Counts"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [distribution_centers.name, inventory_items.count]
    sorts: [inventory_items.count desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    row: 46
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: profit_contribution_by_warehouse
    title: "Margin Contribution by Store Warehouse"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [distribution_centers.name, order_items.total_gross_profit]
    sorts: [order_items.total_gross_profit desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    row: 46
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: sales_by_distribution_center
    title: "Sales Revenue by Store Warehouse"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [distribution_centers.name, order_items.total_sales]
    sorts: [order_items.total_sales desc]
    x_axis_gridlines: false
    y_axis_gridlines: true
    row: 46
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  # =========================================================================
  # SECTION: Monthly Sales Performance vs. Target (Interactive Writeback)
  # =========================================================================
  - name: target_tracking_section_header
    type: text
    title_text: "🎯 Monthly Sales Performance vs. Target (Interactive Writeback Hub)"
    subtitle_text: "Track Actual Sales Price vs. Monthly Targets and click ⋮ on the Edit Column below to update targets live in BigQuery"
    row: 52
    col: 0
    width: 24
    height: 2

  - name: ops_target_kpi_actual_sales
    title: "Actual Total Sales Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_sales]
    limit: 500
    show_single_value_title: true
    custom_color: "#1A73E8"
    row: 54
    col: 0
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: ops_target_kpi_total_target
    title: "Total Sales Price Target"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [monthly_sales_targets.monthly_sales_target]
    limit: 500
    show_single_value_title: true
    custom_color: "#5F6368"
    row: 54
    col: 6
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: ops_target_kpi_variance
    title: "Sales vs. Target Variance ($)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [monthly_sales_targets.sales_vs_target_variance]
    limit: 500
    show_single_value_title: true
    custom_color: "#12B886"
    row: 54
    col: 12
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: ops_target_kpi_achievement_rate
    title: "Target Achievement Rate (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [monthly_sales_targets.target_achievement_rate]
    limit: 500
    show_single_value_title: true
    custom_color: "#F59F00"
    row: 54
    col: 18
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: ops_monthly_actual_vs_target_chart
    title: "Monthly Actual Sales vs. Sales Price Target ($)"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [
      order_items.created_month,
      order_items.total_sales,
      monthly_sales_targets.monthly_sales_target
    ]
    sorts: [order_items.created_month asc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    legend_position: center
    colors: ["#1A73E8", "#F59F00"]
    series_types:
      monthly_sales_targets.monthly_sales_target: line
    row: 58
    col: 0
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: ops_monthly_achievement_variance_chart
    title: "Monthly Target Achievement (%) & Variance Trend"
    model: vibe_test
    explore: Order_Analysis
    type: looker_line
    fields: [
      order_items.created_month,
      monthly_sales_targets.target_achievement_rate,
      monthly_sales_targets.sales_vs_target_variance
    ]
    sorts: [order_items.created_month asc]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    legend_position: center
    colors: ["#12B886", "#FA5252"]
    row: 58
    col: 12
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: ops_interactive_monthly_target_writeback_table
    title: "🎯 Monthly Sales Target Management Table (Click ⋮ on Edit Column to Update Target)"
    model: vibe_test
    explore: Order_Analysis
    type: looker_grid
    fields: [
      order_items.created_month,
      order_items.writeback_action,
      order_items.total_sales,
      monthly_sales_targets.monthly_sales_target,
      monthly_sales_targets.sales_vs_target_variance,
      monthly_sales_targets.target_achievement_rate,
      monthly_sales_targets.updated_by,
      monthly_sales_targets.updated_date,
      monthly_sales_targets.note
    ]
    sorts: [order_items.created_month desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: true
    row: 66
    col: 0
    width: 24
    height: 10
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
