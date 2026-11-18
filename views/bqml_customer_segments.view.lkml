view: bqml_customer_segments {
  derived_table: {
    sql:
      SELECT
        user_id,
        CENTROID_ID AS centroid_id,
        ROUND(nearest_centroids_distance[OFFSET(0)].distance, 4) AS distance_to_centroid,
        traffic_source,
        country,
        gender,
        age,
        signup_date,
        recency_days,
        frequency_orders,
        total_items,
        monetary_ltv,
        avg_order_value,
        return_rate
      FROM ML.PREDICT(
        MODEL `eco-shift-478607-e5.bqml.thelook_customer_segments_kmeans`,
        TABLE `eco-shift-478607-e5.bqml.customer_360_features`
      )
    ;;
  }

  # 1. Keys
  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
    description: "Unique customer identifier (primary key)"
  }

  # 2. Dimensions
  dimension: centroid_id {
    type: number
    sql: ${TABLE}.centroid_id ;;
    description: "Raw cluster centroid ID (1 to 5) assigned by the BQML K-Means model"
  }

  dimension: customer_segment {
    type: string
    label: "Customer 360 Segment (BQML)"
    sql:
      CASE
        WHEN ${centroid_id} = 4 THEN '1. Champions & Frequent Loyalists'
        WHEN ${centroid_id} = 3 THEN '2. VIP Big-Ticket Spenders'
        WHEN ${centroid_id} = 2 THEN '3. Core Mid-Tier Buyers'
        WHEN ${centroid_id} = 1 THEN '4. High-Return / Low-Spend Shoppers'
        WHEN ${centroid_id} = 5 THEN '5. At-Risk / Dormant Customers'
        ELSE 'Unclassified'
      END ;;
    description: "Business persona mapped from BQML K-Means cluster centroids (RFM, AOV, and Return Rate)"
  }

  dimension: segment_description {
    type: string
    label: "Customer Segment Description"
    sql:
      CASE
        WHEN ${centroid_id} = 4 THEN 'Repeat brand advocates with highest order frequency (3.52x orders), freshest recency (292d), $210.33 Avg LTV, $59.66 AOV, and 51.7% Gross Margin.'
        WHEN ${centroid_id} = 3 THEN 'High-ticket luxury buyers with highest AOV ($308.00) & Avg LTV ($423.94), 53.5% Gross Margin, and near-zero Return Rate (0.91%) across 1.50 orders (58% Mens Outerwear & Suits).'
        WHEN ${centroid_id} = 2 THEN 'Active mainstream shoppers (315d recency, $72.97 AOV, $91.02 Avg LTV, 2.09% return rate, 1.24 orders) primed for 2nd-order frequency expansion.'
        WHEN ${centroid_id} = 1 THEN 'Price-sensitive low-basket shoppers ($18.23 AOV, $21.91 Avg LTV, 1.15 orders) with a 20.88% item return rate that erodes margins.'
        WHEN ${centroid_id} = 5 THEN 'Historically solid buyers ($88.81 AOV, $117.98 Avg LTV, 1.32 orders, 2.13% return rate) inactive for ~1,246 days; prime Email win-back targets.'
        ELSE 'Unclassified'
      END ;;
    description: "Detailed behavioral and unit-economics description for each BQML Customer 360 segment"
  }

  dimension: is_revenue_growth_segment {
    type: yesno
    label: "Is Revenue Growth Segment?"
    sql: ${centroid_id} IN (3, 4) ;;
    description: "True if the customer is in the top revenue-driving segments (1. Champions & Frequent Loyalists or 2. VIP Big-Ticket Spenders)"
  }

  dimension: strategic_growth_tier {
    type: string
    label: "Strategic Growth Tier"
    sql:
      CASE
        WHEN ${centroid_id} IN (3, 4) THEN '1. Revenue Growth Engine (Champions & VIPs)'
        WHEN ${centroid_id} = 2 THEN '2. Expansion Core (Mid-Tier Buyers)'
        WHEN ${centroid_id} = 5 THEN '3. Reactivation Target (Dormant Customers)'
        WHEN ${centroid_id} = 1 THEN '4. Margin Protection (High-Return Shoppers)'
        ELSE 'Other'
      END ;;
    description: "High-level marketing portfolio tier grouping BQML segments by revenue growth role"
  }

  dimension: recommended_marketing_action {
    type: string
    label: "Recommended Marketing Action"
    sql:
      CASE
        WHEN ${centroid_id} = 4 THEN 'Early Access & VIP Loyalty Rewards'
        WHEN ${centroid_id} = 3 THEN 'High-Touch Concierge & Premium Upsell Bundles'
        WHEN ${centroid_id} = 2 THEN 'Cross-Sell & Frequency Nurture Campaigns'
        WHEN ${centroid_id} = 1 THEN 'Suppress Paid Retargeting; Fit Guidance & Exchanges'
        WHEN ${centroid_id} = 5 THEN 'Win-Back Offer & Re-Engagement Campaign'
        ELSE 'Standard Marketing'
      END ;;
    description: "Targeted marketing action recommended for the customer's BQML segment"
  }

  dimension: traffic_source {
    type: string
    label: "Acquisition Channel"
    sql: ${TABLE}.traffic_source ;;
    description: "Original marketing channel that acquired the customer"
  }

  dimension: country {
    type: string
    label: "Customer Country"
    sql: ${TABLE}.country ;;
    description: "Customer country of residence"
  }

  dimension: gender {
    type: string
    label: "Customer Gender"
    sql: ${TABLE}.gender ;;
    description: "Customer gender"
  }

  dimension: age {
    type: number
    label: "Customer Age"
    sql: ${TABLE}.age ;;
    description: "Customer age in years"
  }

  dimension: age_tier {
    type: tier
    label: "Customer Age Tier"
    tiers: [18, 25, 35, 45, 55, 65]
    style: integer
    sql: ${age} ;;
    description: "Customer age bracket for demographic targeting"
  }

  dimension: distance_to_centroid {
    type: number
    sql: ${TABLE}.distance_to_centroid ;;
    value_format_name: decimal_2
    description: "Euclidean distance from the customer's standardized feature vector to their assigned cluster centroid"
  }

  dimension: recency_days {
    type: number
    sql: ${TABLE}.recency_days ;;
    value_format_name: decimal_0
    description: "Days elapsed since the customer's most recent order"
  }

  dimension: frequency_orders {
    type: number
    sql: ${TABLE}.frequency_orders ;;
    value_format_name: decimal_0
    description: "Total distinct orders placed by the customer"
  }

  dimension: monetary_ltv {
    type: number
    sql: ${TABLE}.monetary_ltv ;;
    value_format_name: usd
    description: "Net Customer Lifetime Value (excluding cancelled and returned items)"
  }

  dimension: avg_order_value {
    type: number
    sql: ${TABLE}.avg_order_value ;;
    value_format_name: usd
    description: "Customer's historical average net order value (AOV)"
  }

  dimension: return_rate {
    type: number
    sql: ${TABLE}.return_rate ;;
    value_format_name: percent_1
    description: "Proportion of ordered items returned by the customer"
  }

  dimension: expansion_upsell_potential_raw {
    type: number
    hidden: yes
    sql:
      CASE
        WHEN ${centroid_id} = 3 THEN ${avg_order_value}
        WHEN ${centroid_id} = 4 THEN ${avg_order_value} * 0.75
        WHEN ${centroid_id} = 2 THEN ${avg_order_value} * 0.50
        WHEN ${centroid_id} = 5 THEN ${avg_order_value} * 0.30
        ELSE 0
      END ;;
    description: "Expected incremental revenue from +1 repeat order weighted by segment conversion propensity"
  }

  # 3. Measures
  measure: segmented_customer_count {
    type: count
    label: "Segmented Customers"
    value_format_name: decimal_0
    description: "Total count of customers scored by the BQML K-Means segmentation model"
  }

  measure: growth_segment_customer_count {
    type: count
    label: "High-Growth Customers (Champions + VIPs)"
    filters: [is_revenue_growth_segment: "yes"]
    value_format_name: decimal_0
    description: "Number of customers in the Revenue Growth Segments (1. Champions & Frequent Loyalists and 2. VIP Big-Ticket Spenders)"
  }

  measure: growth_segment_acquisition_rate {
    type: number
    label: "High-Growth Customer Conversion Rate (%)"
    sql: SAFE_DIVIDE(${growth_segment_customer_count}, NULLIF(${segmented_customer_count}, 0)) ;;
    value_format_name: percent_2
    description: "Percentage of acquired customers who become Champions or VIP Big-Ticket Spenders"
  }

  measure: total_segment_ltv {
    type: sum
    label: "Total Net LTV"
    sql: ${monetary_ltv} ;;
    value_format_name: usd
    description: "Sum of net lifetime revenue across customers in the segment"
  }

  measure: growth_segment_ltv {
    type: sum
    label: "High-Growth Segment Net LTV"
    sql: ${monetary_ltv} ;;
    filters: [is_revenue_growth_segment: "yes"]
    value_format_name: usd
    description: "Total Net LTV generated specifically by Champions & VIP Big-Ticket Spenders"
  }

  measure: growth_segment_ltv_share {
    type: number
    label: "High-Growth Segment LTV Share (%)"
    sql: SAFE_DIVIDE(${growth_segment_ltv}, NULLIF(${total_segment_ltv}, 0)) ;;
    value_format_name: percent_1
    description: "Share of total Net LTV generated by Champions & VIP Big-Ticket Spenders"
  }

  measure: total_upsell_winback_potential {
    type: sum
    label: "Incremental Upsell & Win-Back Potential ($)"
    sql: ${expansion_upsell_potential_raw} ;;
    value_format_name: usd
    description: "Projected incremental revenue from converting +1 repeat order across VIP, Champion, Mid-Tier, and Dormant segments"
  }

  measure: average_segment_ltv {
    type: average
    label: "Avg Customer Net LTV"
    sql: ${monetary_ltv} ;;
    value_format_name: usd
    description: "Average net lifetime value (LTV) per customer in the segment"
  }

  measure: average_segment_aov {
    type: average
    label: "Avg Customer AOV"
    sql: ${avg_order_value} ;;
    value_format_name: usd
    description: "Average order value (AOV) across customers in the segment"
  }

  measure: average_frequency_orders {
    type: average
    label: "Avg Order Frequency"
    sql: ${frequency_orders} ;;
    value_format_name: decimal_2
    description: "Average number of orders per customer in the segment"
  }

  measure: average_recency_days {
    type: average
    label: "Avg Recency (Days)"
    sql: ${recency_days} ;;
    value_format_name: decimal_1
    description: "Average days since last purchase across customers in the segment"
  }

  measure: average_return_rate {
    type: average
    label: "Avg Return Rate (%)"
    sql: ${return_rate} ;;
    value_format_name: percent_1
    description: "Average item return rate across customers in the segment"
  }

  measure: average_customer_age {
    type: average
    label: "Avg Customer Age"
    sql: ${age} ;;
    value_format_name: decimal_1
    description: "Average customer age in years"
  }

  measure: average_centroid_distance {
    type: average
    label: "Avg Distance to Centroid"
    sql: ${distance_to_centroid} ;;
    value_format_name: decimal_2
    description: "Average distance to cluster center (lower indicates tighter cluster cohesion)"
  }
}
