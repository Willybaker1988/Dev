use test_db;

--alter stage MY_AZURE_DL_OBJECT_STAGE set credentials=(azure_sas_token='sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2019-12-31T175950Z&st=2019-11-29T095950Z&spr=https&sig=Hezm8b2jKFkCyvoMhy2sFewuk9YjMLAy7Nc14ji0SVQ%3D');

SELECT  FROM TEST_DB.INFORMATION_SCHEMA.STAGES WHERE STAGE_URL = 'azurestoragewbdltest.blob.core.windows.nettest1';


LIST @MY_AZURE_DL_OBJECT_STAGE;

SELECT 
       t.$1 AS id
     , t.$2 AS user_id
     , t.$3 AS order_date
     , t.$4 AS order_status
  FROM
    @MY_AZURE_DL_OBJECT_STAGEtestfolder t
    

create notification integration azure_event_grid_datalake_gen2_test
  enabled = true
  type = queue
  notification_provider = azure_storage_queue
  azure_storage_queue_primary_uri = 'httpsstoragewbdltest.queue.core.windows.netsb-snowpipeevents-wbdltest'
  azure_tenant_id = '41fae877-429a-4435-854f-b696cb99c60f';
  
  
desc notification integration azure_event_grid_datalake_gen2_test;

CREATE OR REPLACE pipe test_db.public.mypipe_from_datalake_gen2
  auto_ingest = true
  integration = azure_event_grid_datalake_gen2_test
  AS
  COPY INTO test_db.public.orders_test
  (
        id
    ,   user_id
    ,   order_date 
    ,   order_status 
  )
  FROM (
  SELECT 
         t.$1 AS id
       , t.$2 AS user_id
       , t.$3 AS order_date
       , t.$4 AS order_status
    FROM
      @MY_AZURE_DL_OBJECT_STAGEtestfolder t
  );


select 
from table(information_schema.copy_history(TABLE_NAME = 'test_db.public.orders_test',
     start_time= dateadd(hours, -24, current_timestamp())));
