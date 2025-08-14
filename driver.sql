-- driver.sql — AGS Game Audience (Snowflake)
-- Runs the SQL files in order to (re)create the pipeline end-to-end.

!set variable_substitution=true
!set exit_on_error=true

-- 0) Session / DB context (role, warehouse, database)
!source sql/000_env.sql

-- 1) Foundations
!source sql/010_file_format_raw_ff_json_logs.sql
!source sql/020_storage_integration_aws.sql
!source sql/030_stage_raw_uni_kishore_pipeline.sql

-- 2) Tables
!source sql/040_table_ed_pipeline_logs.sql
!source sql/041_table_logs_enhanced.sql
!source sql/042_table_pl_game_logs.sql
!source sql/043_table_time_of_day_lu.sql

-- 3) Views
!source sql/050_view_pl_logs.sql

-- 4) Ingestion (Snowpipe)
!source sql/060_snowpipe_pipe_get_new_files.sql
-- NOTE: With this order, the stream below will NOT capture rows ingested
-- before it is created. If you want the stream to see the very first batch,
-- swap steps 4 and 5 (create the stream before the pipe starts ingesting).

-- 5) CDC (Stream)
!source sql/070_stream_ed_cdc_stream.sql

-- 6) Orchestration (Task)
!source sql/080_task_cdc_load_logs_enhanced.sql
