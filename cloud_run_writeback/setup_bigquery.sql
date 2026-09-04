-- Create demo dataset and table for BigQuery Writeback Action
CREATE SCHEMA IF NOT EXISTS `demo_dataset`
OPTIONS (location = 'US');

CREATE TABLE IF NOT EXISTS `demo_dataset.demo_table` (
  invoked_at TIMESTAMP,
  invoked_by STRING,
  scheduled_plan_id STRING,
  query_result_size INT64,
  choice STRING,
  note STRING
);
