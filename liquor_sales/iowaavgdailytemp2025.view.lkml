view: iowaavgdailytemp2025 {
  sql_table_name: `eco-shift-478607-e5.bq1.iowa-avg-daily-temp-2025` ;;


  dimension_group: date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: state {
    type: string
    hidden: yes
    sql: ${TABLE}.state ;;
  }
  measure: avg_precipitation {
    type: number
    sql: ${TABLE}.avg_precipitation ;;
  }
  measure: avg_temp {
    type: number
    sql: ${TABLE}.avg_temp ;;
  }
}
