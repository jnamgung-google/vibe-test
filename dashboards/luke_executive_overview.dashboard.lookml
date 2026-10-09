- dashboard: executive_overview
  title: "Executive Overview & Pulse"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "A highly actionable executive summary combining top-line YoY indicators, target tracking, and strategic operational trends."
  
  # Dashboard-level filters
  filters:
    - name: Date Range
      title: Date Range
      type: date_filter
      default_value: "This Year to Date"
      allow_multiple_values: true
      required: false
      ui_config:
        type: advanced
        display: popover
    
    - name: Country
      title: Country
      type: field_filter
      default_value: ""
      allow_multiple_values: true
      required: false
      model: vibe_test
      explore: Order_Analysis
      field: users.country
      ui_config:
        type: tag_list
        display: popover

  elements:
    # -----------------------------------------------------------
    # ROW 1: LUKE'S REQUIREMENT (6 INDICATORS COMPARING YOY, MAPPED LOCALLY)
    # -----------------------------------------------------------
    - name: "Total Revenue (YoY)"
      title: "Total Sales"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      measures: [order_items.total_sales]
      dynamic_fields: 
        - table_calculation: prior_year_sales
          label: "Prior Year"
          expression: "offset(${order_items.total_sales}, 1)"
          value_format: "$#,##0.00"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false 
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 0
      width: 4
      height: 4

    - name: "Active Users (YoY)"
      title: "Total Users"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      measures: [users.count]
      dynamic_fields:
        - table_calculation: prior_year_users
          label: "Prior Year"
          expression: "offset(${users.count}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 4
      width: 4
      height: 4
      
    - name: "Gross Margin (YoY)"
      title: "Gross Margin %"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      measures: [order_items.gross_profit_margin]
      dynamic_fields:
        - table_calculation: prior_year_margin
          label: "Prior Year"
          expression: "offset(${order_items.gross_profit_margin}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 8
      width: 4
      height: 4

    - name: "CAC (YoY)"
      title: "Blended CAC"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      measures: [marketing_spend.blended_cac]
      dynamic_fields:
        - table_calculation: prior_year_cac
          label: "Prior Year"
          expression: "offset(${marketing_spend.blended_cac}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true # Lower CAC is better
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 12
      width: 4
      height: 4

    - name: "Return Rate (YoY)"
      title: "Order Return Rate"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      measures: [order_items.order_return_rate]
      dynamic_fields:
        - table_calculation: prior_year_returns
          label: "Prior Year"
          expression: "offset(${order_items.order_return_rate}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true # Lower return rate is better
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 16
      width: 4
      height: 4

    - name: "LTV (YoY)"
      title: "Avg Lifetime Revenue"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      measures: [users.average_lifetime_revenue]
      dynamic_fields:
        - table_calculation: prior_year_ltv
          label: "Prior Year"
          expression: "offset(${users.average_lifetime_revenue}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 20
      width: 4
      height: 4

    # -----------------------------------------------------------
    # ROW 2: LUKE'S REQUIREMENT - GAUGE/TARGET CHARTS
    # -----------------------------------------------------------
    - name: "Sales vs Target"
      title: "Sales vs Monthly Target"
      type: looker_gauge 
      model: vibe_test
      explore: Order_Analysis
      measures: [order_items.total_sales, monthly_sales_targets.monthly_sales_target]
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 4
      col: 0
      width: 8
      height: 6

    - name: "Repeat Customer Rate"
      title: "Repeat Customer Rate (%)"
      type: looker_gauge 
      model: vibe_test
      explore: Order_Analysis
      measures: [users.repeat_customer_rate]
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 4
      col: 8
      width: 8
      height: 6

    - name: "Average Basket Size"
      title: "Avg Basket Size"
      type: looker_gauge 
      model: vibe_test
      explore: Order_Analysis
      measures: [order_items.average_basket_size]
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 4
      col: 16
      width: 8
      height: 6

    # -----------------------------------------------------------
    # ROW 3: DETAILED ACTIONABLE TRENDS & TABLES
    # -----------------------------------------------------------
    - name: "Sales Trend vs Target"
      title: "Sales by Month vs. Target"
      type: looker_column
      model: vibe_test
      explore: Order_Analysis
      dimensions: [order_items.created_month]
      measures: [order_items.total_sales, monthly_sales_targets.monthly_sales_target]
      y_axes: [{label: "Sales ($)", orientation: left, series: [{axisId: order_items.total_sales, id: order_items.total_sales, name: Total Sales}], showLabels: true, showValues: true}]
      series_types:
        monthly_sales_targets.monthly_sales_target: line 
      colors: ["#1A73E8", "#E8710A"] 
      show_values: false
      x_axis_gridlines: false
      y_axis_gridlines: true
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 10
      col: 0
      width: 14
      height: 7

    - name: "Top Performing Sources"
      title: "Top Traffic Sources (Actionable Detail)"
      type: looker_grid
      model: vibe_test
      explore: Order_Analysis
      dimensions: [users.traffic_source]
      measures: [marketing_spend.total_marketing_spend, order_items.total_sales, marketing_spend.blended_cac]
      sorts: [order_items.total_sales desc]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      conditional_formatting:
        - type: greater_than
          value: 50.00 
          background_color: "#FAD2CF"
          font_color: "#A50E0E"
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 10
      col: 14
      width: 10
      height: 7
