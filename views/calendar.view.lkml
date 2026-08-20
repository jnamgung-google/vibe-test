view: calendar {
  sql_table_name: `eco-shift-478607-e5.bq1.calendar` ;;

# --- The Custom Calendar Definition Block ---
  calendar_definition: {
    reference_date: reference_date
    timeframe_mapping: {
      custom_year: fiscal_year
      custom_quarter: fiscal_quarter_of_year
      custom_week: 445_week_of_year
    }
    timeframe_ordinal_mapping: {
      custom_year: fiscal_year_num
      custom_quarter: fiscal_quarter_of_year_num
      custom_week: 445_week_num
    }
  }

  dimension: reference_date {
    type: date
    convert_tz: no
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.reference_date ;;
  }

# --- Standard Calendar Dimensions ---
  dimension: calendar_year {
    type: string
    group_label: "Standard Calendar"
    sql: ${TABLE}.calendar_year ;;
  }

  dimension: calendar_year_num {
    type: number
    group_label: "Standard Calendar"
    sql: ${TABLE}.calendar_year_num ;;
  }

  dimension: calenar_quarter {
    type: string
    sql: ${TABLE}.`Calenar quater` ;;
  }

# --- Fiscal & 4-4-5 Retail Calendar Dimensions ---
  dimension: fiscal_year {
    type: string
    group_label: "Fiscal Calendar"
    sql: ${TABLE}.fiscal_year ;;
  }

  dimension: fiscal_year_num {
    type: number
    group_label: "Fiscal Calendar"
    sql: ${TABLE}.fiscal_year_num ;;
  }

  dimension: fiscal_quarter_of_year {
    type: string
    group_label: "Fiscal Calendar"
    sql: ${TABLE}.fiscal_quarter_of_year ;;
  }

  dimension: fiscal_quarter_of_year_num {
    type: number
    group_label: "Fiscal Calendar"
    sql: ${TABLE}.fiscal_quarter_of_year_num ;;
  }

  dimension: 445_week_num {
    type: number
    label: "4-4-5 Week Number"
    group_label: "4-4-5 Calendar"
    description: "The numeric representation of the 4-4-5 week"
    sql: ${TABLE}.calendar_week_num ;;
  }

  dimension: 445_week_of_year {
    type: string
    label: "4-4-5 Week of Year"
    group_label: "4-4-5 Calendar"
    description: "The string/formatted representation of the 4-4-5 week"
    sql: ${TABLE}.calendar_week_of_year ;;
  }

  measure: count {
    type: count
    hidden: yes
  }
}
