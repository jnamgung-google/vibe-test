view: bqml_arima_evaluation {
  derived_table: {
    sql:
      SELECT
        r.traffic_source,
        CONCAT('ARIMA(', r.non_seasonal_p, ',', r.non_seasonal_d, ',', r.non_seasonal_q, ')') AS revenue_arima_order,
        ROUND(r.aic, 2) AS revenue_model_aic,
        ROUND(r.variance, 2) AS revenue_model_variance,
        r.has_holiday_effect,
        r.has_spikes_and_dips,
        CONCAT('ARIMA(', o.non_seasonal_p, ',', o.non_seasonal_d, ',', o.non_seasonal_q, ')') AS orders_arima_order,
        ROUND(o.aic, 2) AS orders_model_aic
      FROM ML.ARIMA_EVALUATE(
        MODEL `eco-shift-478607-e5.bqml.thelook_daily_revenue_forecast`,
        STRUCT(FALSE AS show_all_candidate_models)
      ) r
      LEFT JOIN ML.ARIMA_EVALUATE(
        MODEL `eco-shift-478607-e5.bqml.thelook_daily_orders_forecast`,
        STRUCT(FALSE AS show_all_candidate_models)
      ) o
        ON r.traffic_source = o.traffic_source
    ;;
  }

  # 1. Keys
  dimension: traffic_source {
    primary_key: yes
    type: string
    sql: ${TABLE}.traffic_source ;;
    description: "Marketing acquisition channel evaluated in the ARIMA_PLUS model"
  }

  # 2. Dimensions
  dimension: revenue_arima_order {
    type: string
    label: "Revenue ARIMA(p,d,q) Order"
    sql: ${TABLE}.revenue_arima_order ;;
    description: "Best-fit non-seasonal ARIMA(p,d,q) order selected by auto-ARIMA for revenue"
  }

  dimension: orders_arima_order {
    type: string
    label: "Orders ARIMA(p,d,q) Order"
    sql: ${TABLE}.orders_arima_order ;;
    description: "Best-fit non-seasonal ARIMA(p,d,q) order selected by auto-ARIMA for orders"
  }

  dimension: has_holiday_effect {
    type: yesno
    label: "Has US Holiday Effect"
    sql: ${TABLE}.has_holiday_effect ;;
    description: "Whether the ARIMA_PLUS pipeline detected significant US holiday effects"
  }

  dimension: has_spikes_and_dips {
    type: yesno
    label: "Cleaned Spikes & Dips"
    sql: ${TABLE}.has_spikes_and_dips ;;
    description: "Whether anomaly spikes/dips were automatically cleaned during training"
  }

  dimension: revenue_model_aic_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.revenue_model_aic ;;
  }

  dimension: orders_model_aic_raw {
    type: number
    hidden: yes
    sql: ${TABLE}.orders_model_aic ;;
  }

  # 3. Measures
  measure: average_revenue_aic {
    type: average
    label: "Revenue Model AIC"
    sql: ${revenue_model_aic_raw} ;;
    value_format_name: decimal_2
    description: "Akaike Information Criterion (AIC) of the selected revenue ARIMA_PLUS model"
  }

  measure: average_orders_aic {
    type: average
    label: "Orders Model AIC"
    sql: ${orders_model_aic_raw} ;;
    value_format_name: decimal_2
    description: "Akaike Information Criterion (AIC) of the selected orders ARIMA_PLUS model"
  }
}
