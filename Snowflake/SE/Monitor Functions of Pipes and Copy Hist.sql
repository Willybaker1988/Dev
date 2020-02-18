show pipes;


--Monitor Pipes
select *
  from table(information_schema.pipe_usage_history(
    date_range_start=>dateadd('day',-1,current_date()),
    date_range_end=>current_date(),
    pipe_name=>'SOURCE_SYSTEM_TEST.SAPRAW.SNOWPIPE_CSKT'))
UNION ALL
select *
  from table(information_schema.pipe_usage_history(
    date_range_start=>dateadd('day',-1,current_date()),
    date_range_end=>current_date(),
    pipe_name=>'SOURCE_SYSTEM_TEST.SAPRAW.SNOWPIPE_CSKS'));
    
---Monitor Copy History
SELECT * 
from table(information_schema.copy_history(table_name=>'0COMP_CODE_TEXT', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0COSTCENTER_0101_HIER', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0COSTELMNT_0102_HIER', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0COSTELMNT_0102_HIER_INTVL', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0COSTELMNT_ATTR', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0COSTELMNT_TEXT', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0CO_OM_CCA_1', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0CO_OM_CCA_9', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0CURTYPE_TEXT', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0PROFIT_CTR_ATTR', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0PROFIT_CTR_TEXT', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0VENDOR_ATTR', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0VENDOR_TEXT', start_time=> current_date::timestamp_ltz))  
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'0VTYPE_TEXT', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'CSKS', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'CSKT', start_time=> current_date::timestamp_ltz))
UNION ALL
SELECT * from table(information_schema.copy_history(table_name=>'ZDIVISION', start_time=> current_date::timestamp_ltz))


--check pipe status
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_CSKS');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0COSTELMNT_0102_HIER_INTVL');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0PROFIT_CTR_TEXT');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_ZDIVISION');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0VENDOR_TEXT');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0CURTYPE_TEXT');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0COMP_CODE_TEXT');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_CSKT');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0VENDOR_ATTR');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0COSTELMNT_0102_HIER');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0CO_OM_CCA_1');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0COSTCENTER_0101_HIER');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0PROFIT_CTR_ATTR');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0COSTELMNT_ATTR');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0CO_OM_CCA_9');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0COSTELMNT_TEXT');
SELECT SYSTEM$PIPE_STATUS('SNOWPIPE_0VTYPE_TEXT');
