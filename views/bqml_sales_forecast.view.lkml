view: bqml_sales_forecast {
  derived_table: {
    sql:
      WITH historical_daily AS (
        SELECT
          DATE(oi.created_at) AS forecast_date,
          u.traffic_source,
          ROUND(SUM(oi.sale_price), 2) AS actual_revenue,
          CAST(COUNT(DISTINCT oi.order_id) AS FLOAT64) AS actual_orders
        FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
        JOIN `bigquery-public-data.thelook_ecommerce.users` u
          ON oi.user_id = u.id
        WHERE oi.status NOT IN ('Cancelled', 'Returned')
          AND DATE(oi.created_at) BETWEEN '2026-07-01' AND '2026-10-26'
        GROUP BY 1, 2
      ),
      revenue_explain AS (
        SELECT
          DATE(time_series_timestamp) AS forecast_date,
          traffic_source,
          time_series_type,
          ROUND(GREATEST(time_series_adjusted_data, 0), 2) AS fitted_revenue,
          CASE WHEN time_series_type = 'forecast' THEN ROUND(time_series_data, 2) ELSE CAST(NULL AS FLOAT64) END AS forecast_revenue,
          CASE WHEN time_series_type = 'forecast' THEN ROUND(GREATEST(prediction_interval_lower_bound, 0), 2) ELSE CAST(NULL AS FLOAT64) END AS revenue_lower_bound,
          CASE WHEN time_series_type = 'forecast' THEN ROUND(prediction_interval_upper_bound, 2) ELSE CAST(NULL AS FLOAT64) END AS revenue_upper_bound
        FROM ML.EXPLAIN_FORECAST(
          MODEL `eco-shift-478607-e5.bqml.thelook_daily_revenue_forecast`,
          STRUCT(
            {% parameter forecast_horizon %} AS horizon,
            {% parameter confidence_level %} AS confidence_level
          )
        )
        WHERE DATE(time_series_timestamp) >= '2026-07-01'
      ),
      orders_explain AS (
        SELECT
          DATE(time_series_timestamp) AS forecast_date,
          traffic_source,
          time_series_type,
          ROUND(GREATEST(time_series_adjusted_data, 0), 2) AS fitted_orders,
          CASE WHEN time_series_type = 'forecast' THEN ROUND(time_series_data, 2) ELSE CAST(NULL AS FLOAT64) END AS forecast_orders,
          CASE WHEN time_series_type = 'forecast' THEN ROUND(GREATEST(prediction_interval_lower_bound, 0), 2) ELSE CAST(NULL AS FLOAT64) END AS orders_lower_bound,
          CASE WHEN time_series_type = 'forecast' THEN ROUND(prediction_interval_upper_bound, 2) ELSE CAST(NULL AS FLOAT64) END AS orders_upper_bound
        FROM ML.EXPLAIN_FORECAST(
          MODEL `eco-shift-478607-e5.bqml.thelook_daily_orders_forecast`,
          STRUCT(
            {% parameter forecast_horizon %} AS horizon,
            {% parameter confidence_level %} AS confidence_level
          )
        )
        WHERE DATE(time_series_timestamp) >= '2026-07-01'
      )
      SELECT
        r.forecast_date,
        r.traffic_source,
        CASE WHEN r.time_series_type = 'history' THEN 'Actual' ELSE 'Forecast' END AS record_type,
        h.actual_revenue,
        CASE WHEN r.time_series_type = 'history' THEN r.fitted_revenue ELSE CAST(NULL AS FLOAT64) END AS historical_fitted_revenue,
        r.fitted_revenue AS model_fitted_and_forecast_revenue,
        r.forecast_revenue,
        r.revenue_lower_bound,
        r.revenue_upper_bound,
        h.actual_orders,
        CASE WHEN o.time_series_type = 'history' THEN o.fitted_orders ELSE CAST(NULL AS FLOAT64) END AS historical_fitted_orders,
        o.fitted_orders AS model_fitted_and_forecast_orders,
        o.forecast_orders,
        o.orders_lower_bound,
        o.orders_upper_bound
      FROM revenue_explain r
      LEFT JOIN orders_explain o
        ON r.forecast_date = o.forecast_date
       AND r.traffic_source = o.traffic_source
      LEFT JOIN historical_daily h
        ON r.forecast_date = h.forecast_date
       AND r.traffic_source = h.traffic_source
    ;;
  }

  # 1. Keys
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.forecast_date AS STRING), '_', ${TABLE}.traffic_source, '_', ${TABLE}.record_type) ;;
    description: "Composite primary key (Date + Traffic Source + Record Type)"
  }

  # 2. Dimensions
  dimension_group: forecast {
    label: "Activity"
    type: time
    datatype: date
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.forecast_date ;;
    description: "Date of historical actuals or future BQML ARIMA_PLUS forecast"
  }

  dimension: traffic_source {
    type: string
    label: "Traffic Source"
    sql: ${TABLE}.traffic_source ;;
    description: "Marketing acquisition channel (Search, Organic, Facebook, Email, Display)"
  }

  dimension: record_type {
    type: string
    label: "Actual vs. Forecast"
    sql: ${TABLE}.record_type ;;
    description: "Distinguishes historical 'Actual' observations from future BQML 'Forecast' rows"
  }

  dimension: is_trailing_30d_actual {
    type: yesno
    hidden: yes
    sql: ${record_type} = 'Actual' AND ${forecast_raw} BETWEEN DATE '2026-09-27' AND DATE '2026-10-26' ;;
  }

  dimension: actual_revenue_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.actual_revenue ;;
  }

  dimension: historical_fitted_revenue_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.historical_fitted_revenue ;;
  }

  dimension: model_fitted_and_forecast_revenue_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.model_fitted_and_forecast_revenue ;;
  }

  dimension: forecast_revenue_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.forecast_revenue ;;
  }

  dimension: revenue_lower_bound_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.revenue_lower_bound ;;
  }

  dimension: revenue_upper_bound_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.revenue_upper_bound ;;
  }

  dimension: actual_orders_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.actual_orders ;;
  }

  dimension: historical_fitted_orders_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.historical_fitted_orders ;;
  }

  dimension: model_fitted_and_forecast_orders_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.model_fitted_and_forecast_orders ;;
  }

  dimension: forecast_orders_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.forecast_orders ;;
  }

  dimension: orders_lower_bound_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.orders_lower_bound ;;
  }

  dimension: orders_upper_bound_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.orders_upper_bound ;;
  }

  # 3. Measures
  measure: actual_revenue {
    type: sum
    label: "Actual Revenue"
    sql: ${actual_revenue_raw} ;;
    value_format_name: usd
    description: "Historical completed order revenue"
  }

  measure: trailing_30d_revenue {
    type: sum
    label: "Trailing 30D Actual Revenue"
    sql: ${actual_revenue_raw} ;;
    filters: [is_trailing_30d_actual: "yes"]
    value_format_name: usd
    description: "Completed order revenue in the 30 days immediately preceding the forecast window (2026-09-27 to 2026-10-26)"
  }

  measure: trailing_30d_fitted_revenue {
    type: sum
    label: "Trailing 30D Model Fitted Revenue"
    sql: ${historical_fitted_revenue_raw} ;;
    filters: [is_trailing_30d_actual: "yes"]
    value_format_name: usd
    description: "BQML ARIMA_PLUS in-sample fitted/expected revenue over the trailing 30 days (2026-09-27 to 2026-10-26)"
  }

  measure: actual_vs_fitted_revenue_variance {
    type: number
    label: "Actual vs. Fitted Variance ($)"
    sql: ${trailing_30d_revenue} - ${trailing_30d_fitted_revenue} ;;
    value_format_name: usd
    description: "Trailing 30D Actual Revenue minus BQML Model Fitted Revenue (positive means actuals outperformed the model baseline)"
  }

  measure: actual_vs_fitted_revenue_variance_pct {
    type: number
    label: "Actual vs. Fitted Variance (%)"
    sql: SAFE_DIVIDE(${trailing_30d_revenue} - ${trailing_30d_fitted_revenue}, NULLIF(${trailing_30d_fitted_revenue}, 0)) ;;
    value_format_name: percent_1
    description: "Percentage variance between Trailing 30D Actual Revenue and BQML Model Fitted Revenue"
  }

  measure: model_fitted_and_forecast_revenue {
    type: sum
    label: "BQML Fitted & Forecast Revenue (Continuous)"
    sql: ${model_fitted_and_forecast_revenue_raw} ;;
    value_format_name: usd
    description: "Continuous BQML ARIMA_PLUS trajectory combining historical fitted values and future forecasted revenue"
  }

  measure: forecasted_revenue {
    type: sum
    label: "Forecasted Revenue (BQML)"
    sql: ${forecast_revenue_raw} ;;
    value_format_name: usd
    description: "Point forecast of future revenue from BQML ARIMA_PLUS model"
  }

  measure: projected_revenue_delta {
    type: number
    label: "Forecast vs. Actual Revenue Change ($)"
    sql: ${forecasted_revenue} - ${trailing_30d_revenue} ;;
    value_format_name: usd
    description: "Next 30D Forecasted Revenue minus Trailing 30D Actual Revenue (Up/Down dollar delta)"
  }

  measure: projected_revenue_growth_rate {
    type: number
    label: "Forecast vs. Actual Revenue Change (%)"
    sql: SAFE_DIVIDE(${forecasted_revenue} - ${trailing_30d_revenue}, NULLIF(${trailing_30d_revenue}, 0)) ;;
    value_format_name: percent_1
    description: "Percentage revenue growth (Up/Down %) projected in the forecast window vs. the trailing 30 days of actuals"
  }

  measure: combined_revenue {
    type: number
    label: "Total Revenue (Actual + Forecast)"
    sql: COALESCE(${actual_revenue}, 0) + COALESCE(${forecasted_revenue}, 0) ;;
    value_format_name: usd
    description: "Continuous revenue series combining historical actuals and future BQML forecasts"
  }

  measure: revenue_prediction_lower_bound {
    type: sum
    label: "Revenue Forecast Lower Bound (CI)"
    sql: ${revenue_lower_bound_raw} ;;
    value_format_name: usd
    description: "Lower bound of the statistical confidence interval for forecasted revenue"
  }

  measure: revenue_prediction_upper_bound {
    type: sum
    label: "Revenue Forecast Upper Bound (CI)"
    sql: ${revenue_upper_bound_raw} ;;
    value_format_name: usd
    description: "Upper bound of the statistical confidence interval for forecasted revenue"
  }

  measure: actual_orders {
    type: sum
    label: "Actual Orders"
    sql: ${actual_orders_raw} ;;
    value_format_name: decimal_0
    description: "Historical completed distinct order count"
  }

  measure: trailing_30d_orders {
    type: sum
    label: "Trailing 30D Actual Orders"
    sql: ${actual_orders_raw} ;;
    filters: [is_trailing_30d_actual: "yes"]
    value_format_name: decimal_0
    description: "Completed distinct orders in the 30 days immediately preceding the forecast window"
  }

  measure: trailing_30d_fitted_orders {
    type: sum
    label: "Trailing 30D Model Fitted Orders"
    sql: ${historical_fitted_orders_raw} ;;
    filters: [is_trailing_30d_actual: "yes"]
    value_format_name: decimal_0
    description: "BQML ARIMA_PLUS in-sample fitted/expected orders over the trailing 30 days"
  }

  measure: model_fitted_and_forecast_orders {
    type: sum
    label: "BQML Fitted & Forecast Orders (Continuous)"
    sql: ${model_fitted_and_forecast_orders_raw} ;;
    value_format_name: decimal_0
    description: "Continuous BQML ARIMA_PLUS trajectory combining historical fitted orders and future forecasted orders"
  }

  measure: forecasted_orders {
    type: sum
    label: "Forecasted Orders (BQML)"
    sql: ${forecast_orders_raw} ;;
    value_format_name: decimal_0
    description: "Point forecast of future distinct orders from BQML ARIMA_PLUS model"
  }

  measure: projected_orders_delta {
    type: number
    label: "Forecast vs. Actual Orders Change (#)"
    sql: ${forecasted_orders} - ${trailing_30d_orders} ;;
    value_format_name: decimal_0
    description: "Next 30D Forecasted Orders minus Trailing 30D Actual Orders (Up/Down order volume delta)"
  }

  measure: projected_orders_growth_rate {
    type: number
    label: "Forecast vs. Actual Orders Change (%)"
    sql: SAFE_DIVIDE(${forecasted_orders} - ${trailing_30d_orders}, NULLIF(${trailing_30d_orders}, 0)) ;;
    value_format_name: percent_1
    description: "Percentage order volume growth (Up/Down %) projected in the forecast window vs. the trailing 30 days"
  }

  measure: combined_orders {
    type: number
    label: "Total Orders (Actual + Forecast)"
    sql: COALESCE(${actual_orders}, 0) + COALESCE(${forecasted_orders}, 0) ;;
    value_format_name: decimal_0
    description: "Continuous orders series combining historical actuals and future BQML forecasts"
  }

  measure: orders_prediction_lower_bound {
    type: sum
    label: "Orders Forecast Lower Bound (CI)"
    sql: ${orders_lower_bound_raw} ;;
    value_format_name: decimal_0
    description: "Lower bound of the statistical confidence interval for forecasted orders"
  }

  measure: orders_prediction_upper_bound {
    type: sum
    label: "Orders Forecast Upper Bound (CI)"
    sql: ${orders_upper_bound_raw} ;;
    value_format_name: decimal_0
    description: "Upper bound of the statistical confidence interval for forecasted orders"
  }

  measure: trailing_30d_aov {
    type: number
    label: "Trailing 30D Actual AOV"
    sql: SAFE_DIVIDE(${trailing_30d_revenue}, NULLIF(${trailing_30d_orders}, 0)) ;;
    value_format_name: usd
    description: "Actual Average Order Value over the trailing 30 days"
  }

  measure: forecasted_aov {
    type: number
    label: "Forecasted AOV (BQML)"
    sql: SAFE_DIVIDE(${forecasted_revenue}, NULLIF(${forecasted_orders}, 0)) ;;
    value_format_name: usd
    description: "Projected Average Order Value (Forecasted Revenue / Forecasted Orders)"
  }

  # 4. Parameters
  parameter: forecast_horizon {
    label: "Forecast Horizon (Days)"
    description: "Number of future days to forecast with BQML ARIMA_PLUS (default 30)"
    type: unquoted
    default_value: "30"
    allowed_value: {
      label: "14 Days"
      value: "14"
    }
    allowed_value: {
      label: "30 Days"
      value: "30"
    }
    allowed_value: {
      label: "60 Days"
      value: "60"
    }
    allowed_value: {
      label: "90 Days"
      value: "90"
    }
  }

  parameter: confidence_level {
    label: "Prediction Confidence Level"
    description: "Statistical confidence level for lower and upper prediction bounds (default 95%)"
    type: unquoted
    default_value: "0.95"
    allowed_value: {
      label: "80%"
      value: "0.80"
    }
    allowed_value: {
      label: "90%"
      value: "0.90"
    }
    allowed_value: {
      label: "95%"
      value: "0.95"
    }
    allowed_value: {
      label: "99%"
      value: "0.99"
    }
  }
}
