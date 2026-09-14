-- Setup script for Looker BigQuery Writeback Action Hub
-- Project: eco-shift-478607-e5

CREATE SCHEMA IF NOT EXISTS `eco-shift-478607-e5.demo_dataset`
OPTIONS(location="US");

-- 1. Monthly Sales Price Targets Table (Append-only log; LookML takes latest row per target_month)
CREATE TABLE IF NOT EXISTS `eco-shift-478607-e5.demo_dataset.monthly_sales_targets` (
  target_month STRING OPTIONS(description="Target Year-Month in YYYY-MM format, e.g., 2026-09"),
  target_amount FLOAT64 OPTIONS(description="Monthly Sales Price Target in USD"),
  updated_by STRING OPTIONS(description="User email who updated the target"),
  updated_at TIMESTAMP OPTIONS(description="Timestamp of the target update"),
  note STRING OPTIONS(description="Adjustment reason or comment")
);

-- 2. General Audit Log Table
CREATE TABLE IF NOT EXISTS `eco-shift-478607-e5.demo_dataset.demo_table` (
  invoked_at TIMESTAMP,
  invoked_by STRING,
  scheduled_plan_id STRING,
  query_result_size INT64,
  choice STRING,
  note STRING
);
