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
    
    - name: Region
      title: Region
      type: field_filter
      default_value: "North America, EMEA"
      allow_multiple_values: true
      required: false
      model: your_model_name
      explore: order_items
      field: users.region
      ui_config:
        type: button_group
        display: inline

  elements:
    # -----------------------------------------------------------
    # ROW 1: LUKE'S REQUIREMENT - 6 INDICATORS WITH YOY COMPARISON
    # -----------------------------------------------------------
    - name: "Total Revenue (YoY)"
      title: "Total Revenue"
      type: single_value
      model: your_model_name
      explore: order_items
      measures: [order_items.total_revenue]
      dynamic_fields: 
        - table_calculation: prior_year_revenue
          label: "Prior Year"
          expression: "offset(${order_items.total_revenue}, 1)"
          value_format: "$#,##0.00"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false # Higher is better
      listen: {Date Range: order_items.created_date, Region: users.region}
      row: 0
      col: 0
      width: 4
      height: 4

    - name: "Active Users (YoY)"
      title: "Active Users"
      type: single_value
      model: your_model_name
      explore: events
      measures: [events.unique_users]
      dynamic_fields:
        - table_calculation: prior_year_users
          label: "Prior Year"
          expression: "offset(${events.unique_users}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      listen: {Date Range: events.created_date, Region: users.region}
      row: 0
      col: 4
      width: 4
      height: 4
      
    - name: "Gross Margin (YoY)"
      title: "Gross Margin %"
      type: single_value
      model: your_model_name
      explore: order_items
      measures: [order_items.gross_margin_percent]
      dynamic_fields:
        - table_calculation: prior_year_margin
          label: "Prior Year"
          expression: "offset(${order_items.gross_margin_percent}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      listen: {Date Range: order_items.created_date, Region: users.region}
      row: 0
      col: 8
      width: 4
      height: 4

    - name: "CAC (YoY)"
      title: "Customer Acq. Cost"
      type: single_value
      model: your_model_name
      explore: marketing_spend
      measures: [marketing.average_cac]
      dynamic_fields:
        - table_calculation: prior_year_cac
          label: "Prior Year"
          expression: "offset(${marketing.average_cac}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true # Lower CAC is better! Red if YoY grows.
      listen: {Date Range: marketing.spend_date, Region: users.region}
      row: 0
      col: 12
      width: 4
      height: 4

    - name: "Churn Rate (YoY)"
      title: "Churn Rate %"
      type: single_value
      model: your_model_name
      explore: subscriptions
      measures: [subscriptions.churn_rate]
      dynamic_fields:
        - table_calculation: prior_year_churn
          label: "Prior Year"
          expression: "offset(${subscriptions.churn_rate}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true # Lower churn is better!
      listen: {Date Range: subscriptions.created_date, Region: users.region}
      row: 0
      col: 16
      width: 4
      height: 4

    - name: "CLV (YoY)"
      title: "Cust. Lifetime Value"
      type: single_value
      model: your_model_name
      explore: order_items
      measures: [users.average_lifetime_value]
      dynamic_fields:
        - table_calculation: prior_year_clv
          label: "Prior Year"
          expression: "offset(${users.average_lifetime_value}, 1)"
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: false
      listen: {Date Range: order_items.created_date, Region: users.region}
      row: 0
      col: 20
      width: 4
      height: 4

    # -----------------------------------------------------------
    # ROW 2: LUKE'S REQUIREMENT - GAUGE/TARGET CHARTS
    # -----------------------------------------------------------
    - name: "Q3 Revenue vs Target"
      title: "Revenue Pacing (vs Target)"
      type: looker_gauge # Can be swapped to `looker_bullet` if gauge is not enabled
      model: your_model_name
      explore: order_items
      measures: [order_items.total_revenue, order_items.target_revenue]
      listen: {Date Range: order_items.created_date, Region: users.region}
      row: 4
      col: 0
      width: 8
      height: 6

    - name: "New Customers vs Target"
      title: "New Logo Pacing (vs Target)"
      type: looker_gauge 
      model: your_model_name
      explore: events
      measures: [events.new_users, events.target_new_users]
      listen: {Date Range: events.created_date, Region: users.region}
      row: 4
      col: 8
      width: 8
      height: 6

    - name: "Support CSAT vs Target"
      title: "CSAT Score (%)"
      type: looker_gauge 
      model: your_model_name
      explore: zendesk
      measures: [zendesk.average_csat, zendesk.csat_target]
      listen: {Date Range: zendesk.created_date, Region: users.region}
      row: 4
      col: 16
      width: 8
      height: 6

    # -----------------------------------------------------------
    # ROW 3: DETAILED ACTIONABLE TRENDS & TABLES (Overview additions)
    # -----------------------------------------------------------
    - name: "Revenue Trend vs Target"
      title: "Revenue by Month vs. Target"
      type: looker_column
      model: your_model_name
      explore: order_items
      dimensions: [order_items.created_month]
      measures: [order_items.total_revenue, order_items.target_revenue]
      y_axes: [{label: "Revenue ($)", orientation: left, series: [{axisId: order_items.total_revenue, id: order_items.total_revenue, name: Total Revenue}], showLabels: true, showValues: true}]
      series_types:
        order_items.target_revenue: line # Overlay line chart on top of column chart
      colors: ["#1A73E8", "#E8710A"] 
      show_values: false
      x_axis_gridlines: false
      y_axis_gridlines: true
      listen: {Date Range: order_items.created_date, Region: users.region}
      row: 10
      col: 0
      width: 14
      height: 7

    - name: "Top Performing Campaigns"
      title: "Top Campaigns (Actionable Detail)"
      type: looker_grid
      model: your_model_name
      explore: marketing_spend
      dimensions: [marketing.campaign_name, marketing.channel]
      measures: [marketing.total_spend, marketing.conversions, marketing.cpa]
      sorts: [marketing.conversions desc]
      limit: 10
      show_view_names: false
      show_row_numbers: true
      conditional_formatting:
        - type: greater_than
          value: 50.00 # Highlight CPAs over $50 as red
          background_color: "#FAD2CF"
          font_color: "#A50E0E"
          color_application:
            collection_id: default
            palette_id: default
      listen: {Date Range: marketing.spend_date, Region: users.region}
      row: 10
      col: 14
      width: 10
      height: 7
