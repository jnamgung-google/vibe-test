- dashboard: ecommerce_target_performance
  title: "E-Commerce Business Operations - Performance vs. Target"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Track monthly sales revenue against monthly sales price targets, analyze variance & achievement rates, and dynamically edit monthly targets via BigQuery Writeback Actions."

  filters:
  - name: created_date
    title: "Created Date"
    type: date_filter
    default_value: "last 12 months"

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
  - name: tab_navigation_header
    type: text
    title_text: ""
    subtitle_text: ""
    body_text: |
      <div style="display: flex; gap: 12px; border-bottom: 2px solid #E0E0E0; padding-bottom: 12px; margin-bottom: 8px; align-items: center;">
        <a href="/dashboards/vibe_test::ecommerce_operations" style="padding: 10px 20px; border-radius: 8px; background-color: #F1F3F4; color: #3C4043; text-decoration: none; font-weight: 600; font-size: 14px;">
          📊 Tab 1: Business Operations Overview
        </a>
        <a href="/dashboards/vibe_test::ecommerce_target_performance" style="padding: 10px 20px; border-radius: 8px; background-color: #1A73E8; color: #FFFFFF; text-decoration: none; font-weight: 600; font-size: 14px; box-shadow: 0 2px 5px rgba(26,115,232,0.3);">
          🎯 Tab 2: Performance vs. Target (Interactive Writeback)
        </a>
      </div>
      <div style="padding: 4px 2px; color: #5F6368; font-size: 13px;">
        <b>Monthly Sales Target Management Hub:</b> Monitor actual sales revenue against monthly targets. To modify any month's target, click the <b>three dots (⋮)</b> on the <b>🎯 Edit Monthly Sales Target</b> column in the table below.
      </div>
    row: 0
    col: 0
    width: 24
    height: 3

  # KPI Row: Performance vs Target
  - name: target_kpi_actual_sales
    title: "Actual Total Sales Revenue"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.total_sales]
    limit: 500
    show_single_value_title: true
    custom_color: "#1A73E8"
    row: 3
    col: 0
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: target_kpi_total_target
    title: "Total Sales Price Target"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [monthly_sales_targets.monthly_sales_target]
    limit: 500
    show_single_value_title: true
    custom_color: "#5F6368"
    row: 3
    col: 6
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: target_kpi_variance
    title: "Sales vs. Target Variance ($)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [monthly_sales_targets.sales_vs_target_variance]
    limit: 500
    show_single_value_title: true
    custom_color: "#12B886"
    row: 3
    col: 12
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: target_kpi_achievement_rate
    title: "Target Achievement Rate (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [monthly_sales_targets.target_achievement_rate]
    limit: 500
    show_single_value_title: true
    custom_color: "#F59F00"
    row: 3
    col: 18
    width: 6
    height: 4
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  # Trend Charts Row
  - name: monthly_actual_vs_target_chart
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
    row: 7
    col: 0
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  - name: monthly_achievement_variance_chart
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
    row: 7
    col: 12
    width: 12
    height: 8
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category

  # Interactive Writeback Management Table
  - name: interactive_monthly_target_writeback_table
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
    row: 15
    col: 0
    width: 24
    height: 10
    listen:
      created_date: order_items.created_date
      country: users.country
      category: products.category
