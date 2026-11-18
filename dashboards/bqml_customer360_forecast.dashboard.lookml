- dashboard: bqml_customer360_forecast
  title: "Marketing Division Growth, Customer 360 & BQML Forecasting Command Center"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "End-to-end Marketing Division intelligence powered by BigQuery ML (ARIMA_PLUS 30-day revenue/order forecasting & 5-cluster K-Means Customer 360 segmentation). Includes Customer Segment Persona Descriptions at the top, Overall Forecasted vs. Actual Revenue/Order comparisons (Up/Down $ and %), Campaign ROI, and Segment DNA."

  tabs:
  - name: campaign_effectiveness
    label: "1. Executive Forecast, Segments & Campaign ROI"
  - name: growth_segment_dna
    label: "2. Revenue Growth Segment DNA"
  - name: bqml_revenue_forecast
    label: "3. BQML 30D Revenue Forecast Deep-Dive"

  filters:
  - name: traffic_source
    title: "Marketing Acquisition Channel"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: users.traffic_source
    ui_config:
      type: checkboxes
      display: popover

  - name: customer_segment
    title: "Customer 360 Segment (BQML)"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: bqml_customer_segments.customer_segment
    ui_config:
      type: checkboxes
      display: popover

  - name: country
    title: "Customer Country"
    type: field_filter
    model: vibe_test
    explore: Order_Analysis
    field: bqml_customer_segments.country
    ui_config:
      type: tag_list
      display: popover

  - name: forecast_horizon
    title: "Forecast Horizon (Days)"
    type: field_filter
    default_value: "30"
    model: vibe_test
    explore: bqml_sales_forecast
    field: bqml_sales_forecast.forecast_horizon
    ui_config:
      type: button_toggles
      display: inline

  - name: confidence_level
    title: "Confidence Interval Level"
    type: field_filter
    default_value: "0.95"
    model: vibe_test
    explore: bqml_sales_forecast
    field: bqml_sales_forecast.confidence_level
    ui_config:
      type: button_toggles
      display: inline

  elements:
  # =========================================================================
  # TAB 1: EXECUTIVE FORECAST, CUSTOMER SEGMENTS & CAMPAIGN ROI
  # =========================================================================
  - name: top_segment_descriptions_banner
    type: text
    tab_name: campaign_effectiveness
    title_text: "BQML Customer 360 Segment Guide (5-Cluster K-Means Definitions)"
    subtitle_text: "79,724 Customers Segmented by Recency, Frequency, Net LTV, Average Order Value (AOV), and Return Rate — Top 2 Segments Drive 45.6% of Total Net LTV ($3.67M)"
    body_text: |-
      * **1. Champions & Frequent Loyalists (Revenue Growth Engine — 11.8% of Customers | 9,399 Users | $1.98M Net LTV / 24.5% Share):** Repeat brand advocates with the highest order velocity (**3.52x avg orders**), freshest recency (**292 days**), **$210.33 Avg LTV**, **$59.66 AOV**, **10.0% return rate**, and **51.7% Gross Margin**. *Action: VIP Loyalty Tiers & Cross-Category Bundling (+$561k Upsell Potential).*
      * **2. VIP Big-Ticket Spenders (Revenue Growth Engine — 5.0% of Customers | 4,004 Users | $1.70M Net LTV / 21.1% Share):** High-ticket luxury buyers with the highest **AOV ($308.00)** and **Avg LTV ($423.94)**, highest **Gross Margin (53.5%)**, and near-zero **Return Rate (0.91%)** across **1.50 orders** (skewing 58% Men's Outerwear, Suits & Denim). *Action: High-Touch Concierge & 2nd-Order Upsell (+$1.23M Upsell Potential).*
      * **3. Core Mid-Tier Buyers (Expansion Core — 29.5% of Customers | 23,551 Users | $2.14M Net LTV / 26.6% Share):** Active mainstream shoppers with recent activity (**315 days recency**), low return rate (**2.09%**), **$72.97 AOV**, and **$91.02 Avg LTV** across **1.24 orders**. *Action: 2nd-Order Frequency Nurture & Category Cross-Sell (+$643k Potential).*
      * **4. High-Return / Low-Spend Shoppers (Margin Protection — 36.6% of Customers | 29,172 Users | $639k Net LTV / 7.9% Share):** Price-sensitive, low-basket buyers (**$18.23 AOV**, **$21.91 Avg LTV**, **1.15 orders**) with a **20.88% item return rate** that erodes fulfillment margins. *Action: Suppress from Paid Retargeting; Fit/Sizing Guidance & Exchange Incentives.*
      * **5. At-Risk / Dormant Customers (Reactivation Target — 17.1% of Customers | 13,598 Users | $1.60M Net LTV / 19.9% Share):** Historically healthy buyers (**$88.81 AOV**, **$117.98 Avg LTV**, **1.32 orders**, **2.13% return rate**) inactive for **1,246 days (~3.4 yrs)**. *Action: Zero-Cost Automated Email Win-Back Campaigns (+$484k Recovery Potential).*
    row: 0
    col: 0
    width: 24
    height: 5

  - name: exec_kpi_forecast_vs_actual_rev
    title: "Next 30D Forecasted Revenue vs. Actual"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.forecasted_revenue,
      bqml_sales_forecast.projected_revenue_growth_rate
    ]
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "UP vs. $595.5K Trailing 30D Actuals"
    row: 5
    col: 0
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: exec_kpi_forecast_rev_delta
    title: "Forecast vs. Actual Revenue Change ($)"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.projected_revenue_delta,
      bqml_sales_forecast.trailing_30d_revenue
    ]
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Trailing 30D Actual Revenue Baseline"
    row: 5
    col: 6
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: exec_kpi_forecast_vs_actual_orders
    title: "Next 30D Forecasted Orders vs. Actual"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.forecasted_orders,
      bqml_sales_forecast.projected_orders_growth_rate
    ]
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "UP (+38,457 Orders) vs. 9,206 Actuals"
    row: 5
    col: 12
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: exec_kpi_actual_vs_fitted_backtest
    title: "Trailing 30D Actual vs. Model Fitted"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.trailing_30d_revenue,
      bqml_sales_forecast.actual_vs_fitted_revenue_variance_pct
    ]
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "vs. $625.3K BQML Fitted (-$29.8K / 95.2% Fit)"
    row: 5
    col: 18
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: exec_overall_forecast_vs_actual_chart
    title: "Overall Forecasting Chart: Daily Actual Revenue vs. BQML Fitted Model & 30D Forecast (Up +$1.51M / +252.9%)"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: bqml_sales_forecast
    type: looker_line
    fields: [
      bqml_sales_forecast.forecast_date,
      bqml_sales_forecast.actual_revenue,
      bqml_sales_forecast.model_fitted_and_forecast_revenue,
      bqml_sales_forecast.forecasted_revenue,
      bqml_sales_forecast.revenue_prediction_lower_bound,
      bqml_sales_forecast.revenue_prediction_upper_bound
    ]
    filters:
      bqml_sales_forecast.forecast_date: "after 2026/08/15"
    sorts: [bqml_sales_forecast.forecast_date asc]
    limit: 500
    legend_position: center
    row: 8
    col: 0
    width: 12
    height: 8
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: exec_overall_forecast_vs_actual_table
    title: "Forecasted vs. Actual Numbers by Channel & Total (Up / Down $ & % Comparison)"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: bqml_sales_forecast
    type: looker_grid
    fields: [
      bqml_sales_forecast.traffic_source,
      bqml_sales_forecast.trailing_30d_revenue,
      bqml_sales_forecast.trailing_30d_fitted_revenue,
      bqml_sales_forecast.actual_vs_fitted_revenue_variance,
      bqml_sales_forecast.actual_vs_fitted_revenue_variance_pct,
      bqml_sales_forecast.forecasted_revenue,
      bqml_sales_forecast.projected_revenue_delta,
      bqml_sales_forecast.projected_revenue_growth_rate,
      bqml_sales_forecast.trailing_30d_orders,
      bqml_sales_forecast.forecasted_orders,
      bqml_sales_forecast.projected_orders_delta,
      bqml_sales_forecast.projected_orders_growth_rate
    ]
    sorts: [bqml_sales_forecast.forecasted_revenue desc]
    total: true
    show_totals: true
    show_view_names: false
    show_row_numbers: true
    truncate_text: true
    size_to_fit: true
    table_theme: transparent
    row: 8
    col: 12
    width: 12
    height: 8
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: kpi_total_net_ltv
    title: "Total Net Customer LTV"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [bqml_customer_segments.total_segment_ltv]
    row: 16
    col: 0
    width: 4
    height: 3
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: kpi_growth_segment_ltv
    title: "High-Growth Segment LTV"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [bqml_customer_segments.growth_segment_ltv]
    row: 16
    col: 4
    width: 4
    height: 3
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: kpi_growth_ltv_share
    title: "High-Growth LTV Share (%)"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [bqml_customer_segments.growth_segment_ltv_share]
    row: 16
    col: 8
    width: 4
    height: 3
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: kpi_growth_conv_rate
    title: "High-Growth Conversion Rate"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [bqml_customer_segments.growth_segment_acquisition_rate]
    row: 16
    col: 12
    width: 4
    height: 3
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: kpi_upsell_potential
    title: "Upsell & Win-Back Potential"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [bqml_customer_segments.total_upsell_winback_potential]
    row: 16
    col: 16
    width: 4
    height: 3
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: kpi_gross_margin
    title: "Gross Profit Margin (%)"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: single_value
    fields: [order_items.gross_profit_margin]
    row: 16
    col: 20
    width: 4
    height: 3
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: campaign_effectiveness_matrix
    title: "Campaign Growth Scorecard: High-Growth Customer Acquisition, ROAS & CAC Efficiency"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: looker_grid
    fields: [
      users.traffic_source,
      bqml_customer_segments.segmented_customer_count,
      bqml_customer_segments.growth_segment_customer_count,
      bqml_customer_segments.growth_segment_acquisition_rate,
      bqml_customer_segments.total_segment_ltv,
      bqml_customer_segments.growth_segment_ltv,
      bqml_customer_segments.growth_segment_ltv_share,
      bqml_customer_segments.average_segment_ltv,
      order_items.total_gross_profit,
      order_items.gross_profit_margin,
      marketing_spend.blended_cac,
      marketing_spend.cac_per_growth_customer,
      marketing_spend.ltv_to_cac_ratio,
      bqml_customer_segments.total_upsell_winback_potential
    ]
    sorts: [bqml_customer_segments.total_segment_ltv desc]
    total: true
    show_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    table_theme: transparent
    row: 19
    col: 0
    width: 24
    height: 7
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: channel_growth_ltv_vs_conv_rate
    title: "Campaign Scale vs Quality: High-Growth Segment LTV & Conversion Rate by Channel"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [
      users.traffic_source,
      bqml_customer_segments.growth_segment_ltv,
      bqml_customer_segments.growth_segment_acquisition_rate
    ]
    sorts: [bqml_customer_segments.growth_segment_ltv desc]
    y_axis_combined: false
    y_axes:
    - label: "High-Growth Segment LTV ($)"
      orientation: left
      series:
      - id: bqml_customer_segments.growth_segment_ltv
        name: "High-Growth Segment Net LTV"
        axisId: bqml_customer_segments.growth_segment_ltv
      showLabels: true
      showValues: true
      unpinAxis: false
    - label: "High-Growth Conversion Rate (%)"
      orientation: right
      series:
      - id: bqml_customer_segments.growth_segment_acquisition_rate
        name: "High-Growth Customer Conversion Rate (%)"
        axisId: bqml_customer_segments.growth_segment_acquisition_rate
      showLabels: true
      showValues: true
      unpinAxis: true
    series_types:
      bqml_customer_segments.growth_segment_acquisition_rate: line
    legend_position: center
    defaults_version: 1
    advanced_vis_config: |-
      {
        "chart": { "borderRadius": 12 },
        "plotOptions": {
          "column": { "borderRadius": 8, "borderWidth": 0 }
        },
        "tooltip": { "borderRadius": 12, "shadow": true }
      }
    row: 26
    col: 0
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: channel_roas_vs_cac_efficiency
    title: "Paid Channel ROI: LTV:CAC Ratio vs Cost per High-Growth Customer"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [
      marketing_spend.traffic_source,
      marketing_spend.ltv_to_cac_ratio,
      marketing_spend.cac_per_growth_customer,
      marketing_spend.blended_cac
    ]
    filters:
      marketing_spend.traffic_source: "-NULL"
    sorts: [marketing_spend.ltv_to_cac_ratio desc]
    legend_position: center
    defaults_version: 1
    advanced_vis_config: |-
      {
        "chart": { "borderRadius": 12 },
        "plotOptions": {
          "bar": { "borderRadius": 6, "borderWidth": 0 }
        },
        "tooltip": { "borderRadius": 12, "shadow": true }
      }
    row: 26
    col: 12
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: segment_mix_by_channel
    title: "Customer 360 Segment Portfolio Mix by Acquisition Channel"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [
      users.traffic_source,
      bqml_customer_segments.customer_segment,
      bqml_customer_segments.segmented_customer_count
    ]
    pivots: [bqml_customer_segments.customer_segment]
    sorts: [bqml_customer_segments.customer_segment asc, bqml_customer_segments.segmented_customer_count desc 0]
    stacking: percent
    legend_position: center
    row: 34
    col: 0
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: monthly_revenue_by_growth_tier
    title: "Monthly Revenue Trajectory by Strategic Growth Tier"
    tab_name: campaign_effectiveness
    model: vibe_test
    explore: Order_Analysis
    type: looker_area
    fields: [
      order_items.created_month,
      bqml_customer_segments.strategic_growth_tier,
      order_items.total_sales
    ]
    pivots: [bqml_customer_segments.strategic_growth_tier]
    filters:
      order_items.created_date: "after 2025/01/01"
    sorts: [order_items.created_month asc, bqml_customer_segments.strategic_growth_tier asc]
    stacking: normal
    legend_position: center
    row: 34
    col: 12
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  # =========================================================================
  # TAB 2: REVENUE GROWTH SEGMENT DNA
  # =========================================================================
  - name: tab2_banner
    type: text
    tab_name: growth_segment_dna
    title_text: "Revenue Growth Segment DNA & 5-Cluster Customer 360 Reference Guide"
    subtitle_text: "Deep-dive into the 16.8% of customers (Champions & VIP Big-Ticket Spenders) generating 45.6% of total Net LTV ($3.67M)"
    body_text: |-
      * **1. Champions & Frequent Loyalists (11.8% | 9,399 Users | $1.98M Net LTV):** Order **3.52x** on average (recency **292d**, **$210.33 LTV**, **$59.66 AOV**, **10.0% return rate**), anchored in repeat staples (*Intimates, Jeans, Fashion Hoodies*).
      * **2. VIP Big-Ticket Spenders (5.0% | 4,004 Users | $1.70M Net LTV):** Command a **$308.00 AOV**, **$423.94 LTV**, and **53.53% Gross Margin** with a **0.91% return rate** across **1.50 orders**, skewing **58.0% Men's department** (*Outerwear & Coats, Jeans, Suits & Sport Coats*).
      * **3. Core Mid-Tier Buyers (29.5% | 23,551 Users | $2.14M Net LTV):** Mainstream active buyers (**1.24x orders**, **315d recency**, **$72.97 AOV**, **$91.02 LTV**, **2.09% return rate**) with **$643k** in 2nd-order expansion potential.
      * **4. High-Return / Low-Spend Shoppers (36.6% | 29,172 Users | $639k Net LTV):** Low-ticket buyers (**$18.23 AOV**, **$21.91 LTV**) with a **20.88% return rate** eroding margins.
      * **5. At-Risk / Dormant Customers (17.1% | 13,598 Users | $1.60M Net LTV):** Historically strong buyers (**$88.81 AOV**, **$117.98 LTV**, **1.32x orders**, **2.13% return rate**) inactive for **1,246 days**.
    row: 0
    col: 0
    width: 24
    height: 5

  - name: customer_segment_persona_matrix
    title: "Customer 360 Segment Profiles, Descriptions, Unit Economics & Marketing Playbook"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_grid
    fields: [
      bqml_customer_segments.customer_segment,
      bqml_customer_segments.segment_description,
      bqml_customer_segments.strategic_growth_tier,
      bqml_customer_segments.recommended_marketing_action,
      bqml_customer_segments.segmented_customer_count,
      bqml_customer_segments.total_segment_ltv,
      bqml_customer_segments.average_segment_ltv,
      bqml_customer_segments.average_segment_aov,
      bqml_customer_segments.average_frequency_orders,
      bqml_customer_segments.average_recency_days,
      bqml_customer_segments.average_return_rate,
      order_items.total_gross_profit,
      order_items.gross_profit_margin,
      bqml_customer_segments.total_upsell_winback_potential
    ]
    sorts: [bqml_customer_segments.customer_segment asc]
    total: true
    show_totals: true
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    size_to_fit: true
    table_theme: transparent
    row: 5
    col: 0
    width: 24
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: segment_ltv_share_donut
    title: "Total Net LTV Share by Customer 360 Segment"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_pie
    fields: [
      bqml_customer_segments.customer_segment,
      bqml_customer_segments.total_segment_ltv
    ]
    sorts: [bqml_customer_segments.total_segment_ltv desc]
    legend_position: center
    defaults_version: 1
    advanced_vis_config: |-
      {
        "chart": { "borderRadius": 12 },
        "plotOptions": {
          "pie": { "borderRadius": 8, "innerSize": "70%", "borderWidth": 0 }
        },
        "tooltip": { "borderRadius": 12, "shadow": true }
      }
    row: 13
    col: 0
    width: 8
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: segment_ltv_vs_aov_profile
    title: "Segment Unit Economics: Average LTV vs Average Order Value"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [
      bqml_customer_segments.customer_segment,
      bqml_customer_segments.average_segment_ltv,
      bqml_customer_segments.average_segment_aov
    ]
    sorts: [bqml_customer_segments.average_segment_ltv desc]
    legend_position: center
    defaults_version: 1
    advanced_vis_config: |-
      {
        "chart": { "borderRadius": 12 },
        "plotOptions": {
          "bar": { "borderRadius": 6, "borderWidth": 0 }
        },
        "tooltip": { "borderRadius": 12, "shadow": true }
      }
    row: 13
    col: 8
    width: 8
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: segment_frequency_vs_return_rate
    title: "Behavioral Signature: Order Frequency vs Item Return Rate"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [
      bqml_customer_segments.customer_segment,
      bqml_customer_segments.average_frequency_orders,
      bqml_customer_segments.average_return_rate
    ]
    sorts: [bqml_customer_segments.customer_segment asc]
    y_axis_combined: false
    y_axes:
    - label: "Avg Order Frequency"
      orientation: left
      series:
      - id: bqml_customer_segments.average_frequency_orders
        name: "Avg Order Frequency"
        axisId: bqml_customer_segments.average_frequency_orders
      showLabels: true
      showValues: true
      unpinAxis: false
    - label: "Avg Return Rate (%)"
      orientation: right
      series:
      - id: bqml_customer_segments.average_return_rate
        name: "Avg Return Rate (%)"
        axisId: bqml_customer_segments.average_return_rate
      showLabels: true
      showValues: true
      unpinAxis: false
    series_types:
      bqml_customer_segments.average_return_rate: line
    legend_position: center
    row: 13
    col: 16
    width: 8
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: growth_segment_top_categories
    title: "Top Product Categories Driving Revenue Growth Segments (Champions & VIPs)"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [
      products.category,
      order_items.total_sales,
      order_items.total_gross_profit
    ]
    filters:
      bqml_customer_segments.is_revenue_growth_segment: "Yes"
    sorts: [order_items.total_gross_profit desc]
    limit: 12
    legend_position: center
    row: 21
    col: 0
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: department_affinity_by_segment
    title: "Department Affinity (Men vs Women) Across Customer 360 Segments"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [
      bqml_customer_segments.customer_segment,
      products.department,
      order_items.total_sales
    ]
    pivots: [products.department]
    sorts: [bqml_customer_segments.customer_segment asc]
    stacking: percent
    legend_position: center
    row: 21
    col: 12
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: growth_segment_age_tier_distribution
    title: "Demographic DNA: High-Growth Customers by Age Bracket"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_column
    fields: [
      bqml_customer_segments.age_tier,
      bqml_customer_segments.customer_segment,
      bqml_customer_segments.segmented_customer_count
    ]
    pivots: [bqml_customer_segments.customer_segment]
    filters:
      bqml_customer_segments.is_revenue_growth_segment: "Yes"
    sorts: [bqml_customer_segments.age_tier asc]
    stacking: normal
    legend_position: center
    row: 29
    col: 0
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  - name: growth_segment_top_countries
    title: "Geographic DNA: Top Markets for Revenue Growth Segments"
    tab_name: growth_segment_dna
    model: vibe_test
    explore: Order_Analysis
    type: looker_bar
    fields: [
      bqml_customer_segments.country,
      bqml_customer_segments.growth_segment_ltv,
      bqml_customer_segments.growth_segment_customer_count
    ]
    sorts: [bqml_customer_segments.growth_segment_ltv desc]
    limit: 10
    y_axis_combined: false
    y_axes:
    - label: "High-Growth Segment LTV ($)"
      orientation: left
      series:
      - id: bqml_customer_segments.growth_segment_ltv
        name: "High-Growth Segment Net LTV"
        axisId: bqml_customer_segments.growth_segment_ltv
      showLabels: true
      showValues: true
    - label: "High-Growth Customers"
      orientation: right
      series:
      - id: bqml_customer_segments.growth_segment_customer_count
        name: "High-Growth Customers (Champions + VIPs)"
        axisId: bqml_customer_segments.growth_segment_customer_count
      showLabels: true
      showValues: true
    legend_position: center
    row: 29
    col: 12
    width: 12
    height: 8
    listen:
      traffic_source: users.traffic_source
      customer_segment: bqml_customer_segments.customer_segment
      country: bqml_customer_segments.country

  # =========================================================================
  # TAB 3: BQML 30D REVENUE FORECAST DEEP-DIVE
  # =========================================================================
  - name: tab3_banner
    type: text
    tab_name: bqml_revenue_forecast
    title_text: "BQML ARIMA_PLUS 30-Day Order & Revenue Forecast vs. Actuals by Marketing Channel"
    subtitle_text: "Multi-series time-series forecasting with in-sample fitted backtesting, US holiday effects, and 95% statistical confidence bounds"
    body_text: "**Forecast vs. Actual Summary:** Next 30-day revenue is projected to surge **UP +$1,506,238 (+252.9%)**, rising from **$595,539 (Trailing 30D Actuals)** to **$2,101,777 (Next 30D Forecast)** across **47,663 orders (+38,457 orders / +417.7% vs. 9,206 Trailing 30D Actuals)**. Over the trailing 30 days, actual revenue tracked within **-4.8% (-$29,799)** of the BQML fitted baseline (**$625,337** — **95.2% model accuracy**), with **Email actuals beating the model by +3.6%**."
    row: 0
    col: 0
    width: 24
    height: 3

  - name: kpi_forecasted_revenue
    title: "Forecasted Revenue vs. Trailing 30D Actual"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.forecasted_revenue,
      bqml_sales_forecast.projected_revenue_growth_rate
    ]
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "UP vs. $595.5K Trailing 30D Actual"
    row: 3
    col: 0
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: kpi_projected_revenue_lift
    title: "Forecast vs. Actual Revenue Change ($)"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.projected_revenue_delta,
      bqml_sales_forecast.trailing_30d_revenue
    ]
    show_comparison: true
    comparison_type: value
    show_comparison_label: true
    comparison_label: "Trailing 30D Actual Revenue Baseline"
    row: 3
    col: 6
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: kpi_projected_growth_pct
    title: "Actual vs. BQML Fitted Backtest (30D)"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.trailing_30d_revenue,
      bqml_sales_forecast.actual_vs_fitted_revenue_variance_pct
    ]
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "vs. $625.3K Model Fitted (95.2% Accuracy)"
    row: 3
    col: 12
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: kpi_forecasted_orders
    title: "Forecasted Orders vs. Trailing 30D Actual"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: single_value
    fields: [
      bqml_sales_forecast.forecasted_orders,
      bqml_sales_forecast.projected_orders_growth_rate
    ]
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: "UP (+38,457 Orders) vs. 9,206 Actuals"
    row: 3
    col: 18
    width: 6
    height: 3
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: daily_revenue_forecast_trend
    title: "Daily Revenue: Historical Actuals vs. BQML Fitted Model, 30D Forecast & 95% Confidence Bounds"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: looker_line
    fields: [
      bqml_sales_forecast.forecast_date,
      bqml_sales_forecast.actual_revenue,
      bqml_sales_forecast.model_fitted_and_forecast_revenue,
      bqml_sales_forecast.forecasted_revenue,
      bqml_sales_forecast.revenue_prediction_lower_bound,
      bqml_sales_forecast.revenue_prediction_upper_bound
    ]
    filters:
      bqml_sales_forecast.forecast_date: "after 2026/08/15"
    sorts: [bqml_sales_forecast.forecast_date asc]
    limit: 500
    legend_position: center
    row: 6
    col: 0
    width: 12
    height: 8
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: daily_orders_forecast_trend
    title: "Daily Orders: Historical Actuals vs. BQML Fitted Model, 30D Forecast & 95% Confidence Bounds"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: looker_line
    fields: [
      bqml_sales_forecast.forecast_date,
      bqml_sales_forecast.actual_orders,
      bqml_sales_forecast.model_fitted_and_forecast_orders,
      bqml_sales_forecast.forecasted_orders,
      bqml_sales_forecast.orders_prediction_lower_bound,
      bqml_sales_forecast.orders_prediction_upper_bound
    ]
    filters:
      bqml_sales_forecast.forecast_date: "after 2026/08/15"
    sorts: [bqml_sales_forecast.forecast_date asc]
    limit: 500
    legend_position: center
    row: 6
    col: 12
    width: 12
    height: 8
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: campaign_trailing_vs_forecast_bar
    title: "Campaign Revenue Acceleration: Trailing 30D Actuals vs. Model Fitted vs. Next 30D Forecast"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: looker_column
    fields: [
      bqml_sales_forecast.traffic_source,
      bqml_sales_forecast.trailing_30d_revenue,
      bqml_sales_forecast.trailing_30d_fitted_revenue,
      bqml_sales_forecast.forecasted_revenue,
      bqml_sales_forecast.projected_revenue_growth_rate
    ]
    sorts: [bqml_sales_forecast.forecasted_revenue desc]
    y_axis_combined: false
    y_axes:
    - label: "Revenue ($)"
      orientation: left
      series:
      - id: bqml_sales_forecast.trailing_30d_revenue
        name: "Trailing 30D Actual Revenue"
        axisId: bqml_sales_forecast.trailing_30d_revenue
      - id: bqml_sales_forecast.trailing_30d_fitted_revenue
        name: "Trailing 30D Model Fitted Revenue"
        axisId: bqml_sales_forecast.trailing_30d_fitted_revenue
      - id: bqml_sales_forecast.forecasted_revenue
        name: "Forecasted Revenue (BQML)"
        axisId: bqml_sales_forecast.forecasted_revenue
      showLabels: true
      showValues: true
      unpinAxis: false
    - label: "Forecast vs. Actual Growth (%)"
      orientation: right
      series:
      - id: bqml_sales_forecast.projected_revenue_growth_rate
        name: "Forecast vs. Actual Revenue Change (%)"
        axisId: bqml_sales_forecast.projected_revenue_growth_rate
      showLabels: true
      showValues: true
      unpinAxis: true
    series_types:
      bqml_sales_forecast.projected_revenue_growth_rate: line
    legend_position: center
    row: 14
    col: 0
    width: 10
    height: 8
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level

  - name: arima_model_diagnostics_table
    title: "BQML ARIMA_PLUS Forecast vs. Actuals, Fitted Backtest Variance & Model Diagnostics"
    tab_name: bqml_revenue_forecast
    model: vibe_test
    explore: bqml_sales_forecast
    type: looker_grid
    fields: [
      bqml_sales_forecast.traffic_source,
      bqml_arima_evaluation.revenue_arima_order,
      bqml_arima_evaluation.average_revenue_aic,
      bqml_arima_evaluation.has_holiday_effect,
      bqml_sales_forecast.trailing_30d_revenue,
      bqml_sales_forecast.trailing_30d_fitted_revenue,
      bqml_sales_forecast.actual_vs_fitted_revenue_variance,
      bqml_sales_forecast.actual_vs_fitted_revenue_variance_pct,
      bqml_sales_forecast.forecasted_revenue,
      bqml_sales_forecast.projected_revenue_delta,
      bqml_sales_forecast.projected_revenue_growth_rate,
      bqml_sales_forecast.revenue_prediction_lower_bound,
      bqml_sales_forecast.revenue_prediction_upper_bound,
      bqml_sales_forecast.trailing_30d_orders,
      bqml_sales_forecast.forecasted_orders,
      bqml_sales_forecast.projected_orders_delta,
      bqml_sales_forecast.forecasted_aov
    ]
    sorts: [bqml_sales_forecast.forecasted_revenue desc]
    total: true
    show_totals: true
    show_view_names: false
    show_row_numbers: true
    truncate_text: true
    size_to_fit: true
    table_theme: transparent
    row: 14
    col: 10
    width: 14
    height: 8
    listen:
      traffic_source: bqml_sales_forecast.traffic_source
      forecast_horizon: bqml_sales_forecast.forecast_horizon
      confidence_level: bqml_sales_forecast.confidence_level
