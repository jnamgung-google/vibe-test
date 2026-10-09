- dashboard: executive_overview
  title: "Executive Overview & Pulse"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "A highly actionable executive summary combining top-line YoY indicators, target tracking, and strategic operational trends."
  
  filters:
    - name: Date Range
      title: Date Range
      type: date_filter
      default_value: "12 months ago for 12 months" # safer than year-to-date for YoY comparison
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
    # ROW 1: 6 INDICATORS WITH TARGET/COMPARISON (FIXED DIMENSIONS)
    # -----------------------------------------------------------
    - name: "Total Revenue (YoY)"
      title: "Total Sales (YoY)"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      dimensions: [order_items.created_year]
      measures: [order_items.total_sales]
      sorts: [order_items.created_year desc]
      limit: 2
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false 
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 0
      width: 4
      height: 4

    - name: "Active Users (YoY)"
      title: "Total Users (YoY)"
      type: single_value
      model: vibe_test
      explore: Order_Analysis
      dimensions: [users.created_year]
      measures: [users.count]
      sorts: [users.created_year desc]
      limit: 2
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
      dimensions: [order_items.created_year]
      measures: [order_items.gross_profit_margin]
      sorts: [order_items.created_year desc]
      limit: 2
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
      dimensions: [order_items.created_year]
      measures: [marketing_spend.blended_cac]
      sorts: [order_items.created_year desc]
      limit: 2
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true
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
      dimensions: [order_items.created_year]
      measures: [order_items.order_return_rate]
      sorts: [order_items.created_year desc]
      limit: 2
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true
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
      dimensions: [order_items.created_year]
      measures: [users.average_lifetime_revenue]
      sorts: [order_items.created_year desc]
      limit: 2
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 0
      col: 20
      width: 4
      height: 4

    # -----------------------------------------------------------
    # ROW 2: TARGET PACING (FIXED - NO PLUGINS REQUIRED)
    # -----------------------------------------------------------
    - name: "Sales vs Target"
      title: "Sales (Progress vs Target)"
      type: single_value 
      model: vibe_test
      explore: Order_Analysis
      measures: [order_items.total_sales, monthly_sales_targets.monthly_sales_target]
      show_comparison: true
      comparison_type: progress_percentage
      listen: {Date Range: order_items.created_date, Country: users.country}
      row: 4
      col: 0
      width: 8
      height: 6

    - name: "Repeat Customer Rate"
      title: "Repeat Customer Rate (%)"
      type: single_value 
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
      type: single_value 
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
