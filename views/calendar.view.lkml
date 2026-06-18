view: calendar {
  sql_table_name: `eco-shift-478607-e5.bq1.calendar` ;;

  dimension: calenar_quater {
    type: string
    sql: ${TABLE}.`Calenar quater` ;;
  }
  dimension: calendar_week_num {
    type: number
    sql: ${TABLE}.calendar_week_num ;;
  }
  dimension: calendar_week_of_year {
    type: string
    sql: ${TABLE}.calendar_week_of_year ;;
  }
  dimension: calendar_year {
    type: string
    sql: ${TABLE}.calendar_year ;;
  }
  dimension: calendar_year_num {
    type: number
    sql: ${TABLE}.calendar_year_num ;;
  }
  dimension: fiscal_quarter_of_year {
    type: string
    sql: ${TABLE}.fiscal_quarter_of_year ;;
  }
  dimension: fiscal_quarter_of_year_num {
    type: number
    sql: ${TABLE}.fiscal_quarter_of_year_num ;;
  }
  dimension: fiscal_year {
    type: string
    sql: ${TABLE}.fiscal_year ;;
  }
  dimension: fiscal_year_num {
    type: number
    sql: ${TABLE}.fiscal_year_num ;;
  }
  dimension_group: reference {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.reference_date ;;
  }
  measure: count {
    type: count
  }
}
