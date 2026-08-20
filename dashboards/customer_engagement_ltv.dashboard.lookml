- dashboard: customer_engagement_ltv
  title: "Customer Engagement & Lifetime Value (LTV) Analysis"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Deep dive into customer LTV, repeat purchase behavior, acquisition efficiency, and returns impact."

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

  - name: traffic_source
    title: "Traffic Source"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: users.traffic_source

  elements:
  # Title Banner
  - name: title_banner
    type: text
    title_text: "Customer Engagement & LTV Control Center"
    subtitle_text: "Analyze cohort value, loyalty metrics, acquisition ROI, and return correlations"
    body_text: "This dashboard provides a comprehensive view of customer value and engagement. Track LTV trends, repeat purchase patterns, marketing channel efficiency, and how returns affect customer lifetime value. Use filters to slice by country, channel, or timeframe."
    row: 0
    col: 0
    width: 24
    height: 3

  # ROW 1: KPIs Header
  - name: kpi_header
    type: text
    title_text: "Executive Loyalty & Engagement KPIs"
    row: 3
    col: 0
    width: 24
    height: 1

  # KPIs
  - name: kpi_avg_ltv
    title: "Average Customer LTV"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [users.average_lifetime_revenue]
    row: 4
    col: 0
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: kpi_repeat_rate
    title: "Repeat Customer Rate"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [users.repeat_customer_rate]
    row: 4
    col: 3
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: kpi_total_customers
    title: "Total Customers"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [users.count]
    row: 4
    col: 6
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: kpi_repeat_customers
    title: "Repeat Customers"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [users.count_repeat_customers]
    row: 4
    col: 9
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: kpi_aov
    title: "Average Order Value (AOV)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.average_order_value]
    row: 4
    col: 12
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: kpi_basket_size
    title: "Average Basket Size"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.average_basket_size]
    row: 4
    col: 15
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: kpi_order_return_rate
    title: "Order Return Rate (%)"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.order_return_rate]
    row: 4
    col: 18
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: kpi_repeat_revenue_share
    title: "Repeat Cust. Revenue Share"
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.repeat_customer_revenue_share]
    row: 4
    col: 21
    width: 3
    height: 3
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  # ROW 2: LTV Profiles Header
  - name: ltv_profiles_header
    type: text
    title_text: "Customer Lifetime Value (LTV) Cohort Analysis"
    subtitle_text: "Understanding value distribution across demographics and signup timeframes"
    row: 7
    col: 0
    width: 24
    height: 1

  # LTV Charts
  - name: ltv_by_channel
    title: "LTV by Acquisition Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [users.traffic_source, users.average_lifetime_revenue]
    sorts: [users.average_lifetime_revenue desc]
    row: 8
    col: 0
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: ltv_by_country
    title: "LTV by Customer Country"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [users.country, users.average_lifetime_revenue]
    sorts: [users.average_lifetime_revenue desc]
    limit: 10
    row: 8
    col: 6
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: ltv_by_gender
    title: "LTV by Gender"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.gender, users.average_lifetime_revenue]
    row: 8
    col: 12
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: ltv_by_cohort
    title: "LTV by Signup Cohort (Month)"
    model: vibe_test
    explore: Order_Analysis
    type: looker_line
    fields: [users.created_month, users.average_lifetime_revenue]
    sorts: [users.created_month]
    row: 8
    col: 18
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  # ROW 3: Engagement & Repeat Behavior Header
  - name: engagement_header
    type: text
    title_text: "Customer Engagement & Retention Kinetics"
    subtitle_text: "Analyze repeat purchase patterns and customer mix"
    row: 14
    col: 0
    width: 24
    height: 1

  # Engagement Charts
  - name: repeat_rate_by_channel
    title: "Repeat Customer Rate by Acquisition Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.traffic_source, users.repeat_customer_rate]
    sorts: [users.repeat_customer_rate desc]
    row: 15
    col: 0
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: repeat_rate_by_country
    title: "Repeat Customer Rate by Country (Top 10)"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.country, users.repeat_customer_rate]
    sorts: [users.repeat_customer_rate desc]
    limit: 10
    row: 15
    col: 6
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: monthly_revenue_repeat_vs_new
    title: "Monthly Sales: Repeat vs. New Customers"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [order_items.created_month, users.is_repeat_customer, order_items.total_sales]
    pivots: [users.is_repeat_customer]
    sorts: [order_items.created_month]
    stacking: normal
    row: 15
    col: 12
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: customer_mix_repeat_vs_new
    title: "Customer Mix: Repeat vs. New"
    model: vibe_test
    explore: Order_Analysis
    type: looker_pie
    fields: [users.is_repeat_customer, users.count]
    row: 15
    col: 18
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  # ROW 4: Acquisition ROI Header
  - name: acquisition_roi_header
    type: text
    title_text: "Acquisition Channel ROI & Efficiency"
    subtitle_text: "Comparing LTV against Customer Acquisition Costs (CAC)"
    row: 21
    col: 0
    width: 24
    height: 1

  # Acquisition Charts
  - name: ltv_to_cac_ratio_by_channel
    title: "LTV:CAC Ratio by Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [marketing_spend.traffic_source, marketing_spend.ltv_to_cac_ratio]
    sorts: [marketing_spend.ltv_to_cac_ratio desc]
    row: 22
    col: 0
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: blended_cac_by_channel
    title: "Blended CAC by Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [marketing_spend.traffic_source, marketing_spend.blended_cac]
    sorts: [marketing_spend.blended_cac desc]
    row: 22
    col: 6
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: signups_vs_spend
    title: "Acquired Customers vs. Marketing Spend"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [marketing_spend.traffic_source, users.count, marketing_spend.total_marketing_spend]
    sorts: [users.count desc]
    row: 22
    col: 12
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: signup_cohorts_by_channel
    title: "Monthly Signup Cohorts by Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.created_month, users.traffic_source, users.count]
    pivots: [users.traffic_source]
    sorts: [users.created_month]
    stacking: normal
    row: 22
    col: 18
    width: 6
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  # ROW 5: Returns Impact Header
  - name: returns_impact_header
    type: text
    title_text: "Returns Impact on Customer Lifetime Value"
    subtitle_text: "Analyze how return behavior correlates with overall customer value"
    row: 28
    col: 0
    width: 24
    height: 1

  # Returns Impact Charts
  - name: ltv_returns_vs_no_returns
    title: "LTV: Customers with Returns vs. No Returns"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.has_returns, users.average_lifetime_revenue]
    row: 29
    col: 0
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: repeat_rate_returns_vs_no_returns
    title: "Repeat Customer Rate: Returns vs. No Returns"
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [users.has_returns, users.repeat_customer_rate]
    row: 29
    col: 8
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source

  - name: returned_value_by_channel
    title: "Total Returned Value by Channel"
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [users.traffic_source, order_items.total_returned_value]
    sorts: [order_items.total_returned_value desc]
    row: 29
    col: 16
    width: 8
    height: 6
    listen:
      created_date: order_items.created_date
      country: users.country
      traffic_source: users.traffic_source
