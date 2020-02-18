CALL stproc_create_load_snapshot(CAST(CURRENT_DATE AS VARCHAR));
CALL stproc_create_build_load_snapshot(SELECT EXECUTION_ID FROM FRAMEWORK.PUBLIC.LOAD_SNAPSHOT WHERE COMPLETED_AT IS NULL);
CALL stproc_execute_build_load();
CALL stproc_update_load_snapshot();


CREATE OR REPLACE PROCEDURE stproc_check_for_running_load()
RETURNS string
LANGUAGE JAVASCRIPT
EXECUTE AS owner
AS
$$
var cmd = "SELECT COUNT(*) FROM FRAMEWORK.PUBLIC.LOAD_SNAPSHOT WHERE COMPLETED_AT IS NULL"
var stmt = snowflake.createStatement(
          {
          sqlText: cmd
          }
          );
var result1 = stmt.execute();
result1.next();
return result1.getColumnValue(1);
$$
;


CREATE OR REPLACE PROCEDURE stproc_create_load_snapshot(EXECUTION_DATE VARCHAR)
RETURNS string
LANGUAGE JAVASCRIPT
EXECUTE AS owner
AS
$$
  var check = "CALL stproc_check_for_running_load()"
  var stmt_sh = snowflake.createStatement(
            {
            sqlText: check
            }
            );
  var check_result = stmt_sh.execute();
  check_result.next();
   
 
  if (check_result.getColumnValue(1)==true) {
    var x = true
    
    var cmd = "UPDATE FRAMEWORK.PUBLIC.SOURCE_TABLES x SET x.EXECUTION_ID = d.EXECUTION_ID, x.TASK_EXECUTION_TIMESTAMP = d.TASK_EXECUTION_TIMESTAMP,x.TABLE_NAME = d.TABLE_NAME,x.TABLE_CATALOG = d.TABLE_CATALOG,x.LAST_LOAD_TIME = d.LAST_LOAD_TIME,x.LAST_FILE_LOADED = d.LAST_FILE_LOADED,x.ROW_COUNT = d.ROW_COUNT,x.IS_LOADED = d.IS_LOADED FROM ( SELECT MD5(CURRENT_TIMESTAMP::TIMESTAMP_NTZ) AS EXECUTION_ID, CURRENT_TIMESTAMP::TIMESTAMP_NTZ AS TASK_EXECUTION_TIMESTAMP, S.TABLE_NAME, S.TABLE_CATALOG , D.LAST_LOAD_TIME, D.LAST_FILE_LOADED, D.ROW_COUNT, CASE WHEN TO_DATE(:1, 'YYYY-MM-DD') = D.LAST_LOAD_TIME::DATE THEN 1 ELSE 0 END AS IS_LOADED FROM FRAMEWORK.PUBLIC.SOURCE_TABLES S LEFT JOIN ( SELECT S.TABLE_NAME ,S.TABLE_CATALOG, S.FILE_NAME AS LAST_FILE_LOADED, S.ROW_COUNT AS ROW_COUNT, F.LAST_LOAD_TIME FROM DEMO_DB.ACCOUNT_USAGE_VIEWS.VW_REP_MONITOR_SAPRAW S INNER JOIN ( SELECT TABLE_NAME,TABLE_CATALOG, MAX(LAST_LOAD_TIME::TIMESTAMP_NTZ) AS LAST_LOAD_TIME FROM DEMO_DB.ACCOUNT_USAGE_VIEWS.VW_REP_MONITOR_SAPRAW GROUP BY TABLE_NAME,TABLE_CATALOG ) F ON S.TABLE_NAME = F.TABLE_NAME AND S.TABLE_CATALOG = F.TABLE_CATALOG AND S.LAST_LOAD_TIME::TIMESTAMP_NTZ = F.LAST_LOAD_TIME )D ON S.TABLE_NAME = D.TABLE_NAME AND S.TABLE_CATALOG = D.TABLE_CATALOG ORDER BY S.TABLE_CATALOG,CASE WHEN TO_DATE(CAST(CURRENT_DATE AS VARCHAR),'YYYY-MM-DD') = D.LAST_LOAD_TIME::DATE THEN 1 ELSE 0 END DESC , D.LAST_LOAD_TIME DESC ) d WHERE x.TABLE_NAME = d.TABLE_NAME AND x.TABLE_CATALOG = d.TABLE_CATALOG";
    var stmt = snowflake.createStatement(
              {
              sqlText: cmd,
              binds: [EXECUTION_DATE]
              }
              );
    var result1 = stmt.execute();
    result1.next();
    
    return x
    
  } else {
    var x = false
    
    var cmd = "UPDATE FRAMEWORK.PUBLIC.SOURCE_TABLES x SET x.EXECUTION_ID = d.EXECUTION_ID, x.TASK_EXECUTION_TIMESTAMP = d.TASK_EXECUTION_TIMESTAMP,x.TABLE_NAME = d.TABLE_NAME,x.TABLE_CATALOG = d.TABLE_CATALOG,x.LAST_LOAD_TIME = d.LAST_LOAD_TIME,x.LAST_FILE_LOADED = d.LAST_FILE_LOADED,x.ROW_COUNT = d.ROW_COUNT,x.IS_LOADED = d.IS_LOADED FROM ( SELECT MD5(CURRENT_TIMESTAMP::TIMESTAMP_NTZ) AS EXECUTION_ID, CURRENT_TIMESTAMP::TIMESTAMP_NTZ AS TASK_EXECUTION_TIMESTAMP, S.TABLE_NAME, S.TABLE_CATALOG , D.LAST_LOAD_TIME, D.LAST_FILE_LOADED, D.ROW_COUNT, CASE WHEN TO_DATE(:1, 'YYYY-MM-DD') = D.LAST_LOAD_TIME::DATE THEN 1 ELSE 0 END AS IS_LOADED FROM FRAMEWORK.PUBLIC.SOURCE_TABLES S LEFT JOIN ( SELECT S.TABLE_NAME ,S.TABLE_CATALOG, S.FILE_NAME AS LAST_FILE_LOADED, S.ROW_COUNT AS ROW_COUNT, F.LAST_LOAD_TIME FROM DEMO_DB.ACCOUNT_USAGE_VIEWS.VW_REP_MONITOR_SAPRAW S INNER JOIN ( SELECT TABLE_NAME,TABLE_CATALOG, MAX(LAST_LOAD_TIME::TIMESTAMP_NTZ) AS LAST_LOAD_TIME FROM DEMO_DB.ACCOUNT_USAGE_VIEWS.VW_REP_MONITOR_SAPRAW GROUP BY TABLE_NAME,TABLE_CATALOG ) F ON S.TABLE_NAME = F.TABLE_NAME AND S.TABLE_CATALOG = F.TABLE_CATALOG AND S.LAST_LOAD_TIME::TIMESTAMP_NTZ = F.LAST_LOAD_TIME )D ON S.TABLE_NAME = D.TABLE_NAME AND S.TABLE_CATALOG = D.TABLE_CATALOG ORDER BY S.TABLE_CATALOG,CASE WHEN TO_DATE(CAST(CURRENT_DATE AS VARCHAR),'YYYY-MM-DD') = D.LAST_LOAD_TIME::DATE THEN 1 ELSE 0 END DESC , D.LAST_LOAD_TIME DESC ) d WHERE x.TABLE_NAME = d.TABLE_NAME AND x.TABLE_CATALOG = d.TABLE_CATALOG";
    var stmt = snowflake.createStatement(
              {
              sqlText: cmd,
              binds: [EXECUTION_DATE]
              }
              );
    var result1 = stmt.execute();
    result1.next();
    
    var cmd_insert = "INSERT INTO FRAMEWORK.PUBLIC.LOAD_SNAPSHOT (EXECUTION_ID, STARTED_AT) SELECT DISTINCT EXECUTION_ID, CURRENT_TIMESTAMP::TIMESTAMP_NTZ FROM FRAMEWORK.PUBLIC.SOURCE_TABLES"
    var stmt_insert  = snowflake.createStatement(
              {
              sqlText: cmd_insert
              }
              );
    var result1 = stmt_insert.execute();
    result1.next();
    
    return x;
    
  }

return x
$$
;

CREATE OR REPLACE PROCEDURE stproc_create_build_load_snapshot(EXECUTION_ID VARCHAR)
RETURNS string
LANGUAGE JAVASCRIPT
EXECUTE AS owner
AS
$$

 var cmd = "SELECT CASE WHEN COUNT(*) = 0 THEN FALSE ELSE TRUE END AS FLAG FROM BUILD_LOAD_SNAPSHOT WHERE EXECUTION_ID = :1";
 var stmt = snowflake.createStatement(
          {
          sqlText: cmd,
          binds: [EXECUTION_ID]
          }
          );
 var result1 = stmt.execute();
 result1.next();

  if (result1.getColumnValue(1)==true) {

    var x = true    
    return x

  } 
  else {
    
    var x = false

    var cmd = "INSERT INTO FRAMEWORK.PUBLIC.BUILD_LOAD_SNAPSHOT (EXECUTION_ID, SNAPSHOT_TIMESTAMP,TABLE_NAME,TABLE_CATALOG,ENVIRONMENT,ACTION,STATEMENT_ID,STATEMENT,ESCAPED_STATEMENT,SEQUENCE,MASTER_GROUP,IS_ACTIVE) SELECT EXECUTION_ID, CURRENT_TIMESTAMP::TIMESTAMP_NTZ, c.TABLE_NAME,c.TABLE_CATALOG,c.ENVIRONMENT,c.ACTION,c.STATEMENT_ID,c.STATEMENT,C.ESCAPED_STATEMENT,c.SEQUENCE,c.MASTER_GROUP, E.IS_ACTIVE FROM FRAMEWORK.PUBLIC.CONTROL_TABLE_METADATA C INNER JOIN ( SELECT EXECUTION_ID, MASTER_GROUP,ENVIRONMENT, MIN(IS_LOADED) AS IS_ACTIVE FROM FRAMEWORK.PUBLIC.CONTROL_TABLE_METADATA C INNER JOIN ( SELECT D.TABLE_NAME_DEPENDENCY ,S.EXECUTION_ID ,S.TABLE_NAME , S.TABLE_CATALOG, MIN(S.IS_LOADED) AS IS_LOADED FROM FRAMEWORK.PUBLIC.SOURCE_TABLES_DEPENDENCIES D INNER JOIN FRAMEWORK.PUBLIC.SOURCE_TABLES S ON D.TABLE_NAME_DEPENDENCY = S.TABLE_NAME WHERE S.EXECUTION_ID = :1 GROUP BY 1,2,3,4 ORDER BY 4 )D ON D.TABLE_NAME = C.TABLE_NAME AND D.TABLE_CATALOG = C.TABLE_CATALOG WHERE C.ENVIRONMENT = 'PRODUCTION' GROUP BY MASTER_GROUP,ENVIRONMENT, EXECUTION_ID ) E ON E.MASTER_GROUP = C.MASTER_GROUP AND E.ENVIRONMENT = C.ENVIRONMENT;";
    var stmt = snowflake.createStatement(
              {
              sqlText: cmd,
              binds: [EXECUTION_ID]
              }
              );
    var result1 = stmt.execute();
    result1.next();
  
    return x;
    
  }

$$
;

CREATE OR REPLACE PROCEDURE stproc_execute_build_load()
RETURNS string
LANGUAGE JAVASCRIPT
EXECUTE AS owner
AS
$$
var cmd = "SELECT DISTINCT T.EXECUTION_ID , T.ENVIRONMENT , T.SEQUENCE, T.STATEMENT_ID, T.ESCAPED_STATEMENT, T.STATEMENT, T.MASTER_GROUP::INT ,M.ID FROM FRAMEWORK.PUBLIC.BUILD_LOAD_SNAPSHOT T INNER JOIN LOAD_SNAPSHOT S ON T.EXECUTION_ID = S.EXECUTION_ID INNER JOIN FRAMEWORK.PUBLIC.CONTROL_TABLE_METADATA M ON T.ENVIRONMENT = M.ENVIRONMENT AND T.SEQUENCE = M.SEQUENCE WHERE COMPLETED_AT IS NULL AND T.IS_ACTIVE = TRUE ORDER BY ID;";
var stmt = snowflake.createStatement(
          {
          sqlText: cmd
          }
          );
var result_set1 = stmt.execute();

while (result_set1.next())
{

  var exe_id = result_set1.getColumnValue(1);
  var env = result_set1.getColumnValue(2);
  var seq_id = result_set1.getColumnValue(3);
  var stmt_id = result_set1.getColumnValue(4);
  var esc_stmt = result_set1.getColumnValue(5);
  var sql_stmt = result_set1.getColumnValue(6);
  
  var stmt_resultset = snowflake.createStatement(
            {
            sqlText: sql_stmt
            }
            );
  
  var exec_stmt = stmt_resultset.execute();
  
  var updt_cmd = `UPDATE BUILD_LOAD_SNAPSHOT x SET x.IS_ACTIVE = 'FALSE', x.EXECUTED_AT = CURRENT_TIMESTAMP::TIMESTAMP_NTZ, x.QUERY_ID = d.QUERY_ID FROM ( SELECT TABLE_NAME ,EXECUTION_ID , ENVIRONMENT ,  SEQUENCE , STATEMENT_ID, LAST_QUERY_ID() as QUERY_ID FROM BUILD_LOAD_SNAPSHOT WHERE IS_ACTIVE = 'TRUE' AND EXECUTION_ID = '` + exe_id + `' AND ENVIRONMENT = '` + env + `' AND  SEQUENCE = '` + seq_id + `' AND STATEMENT_ID = '` + stmt_id + `') D WHERE x.EXECUTION_ID = d.EXECUTION_ID AND  x.ENVIRONMENT = d.ENVIRONMENT AND x.SEQUENCE = d.SEQUENCE AND x.STATEMENT_ID = d.STATEMENT_ID`
  var updt_stmt_resultset = snowflake.createStatement(
            {
            sqlText: updt_cmd
            }
            );
                        
  var exec_build_log = updt_stmt_resultset.execute();
  
  exec_stmt.next();  
  
}

$$
;


CREATE OR REPLACE PROCEDURE stproc_update_load_snapshot()
RETURNS string
LANGUAGE JAVASCRIPT
EXECUTE AS owner
AS
$$

 var cmd = "SELECT SUM(IS_ACTIVE) AS BUILD_LOAD_ACTIVE FROM (SELECT CASE WHEN COUNT(T.IS_ACTIVE) > 1 THEN 1 ELSE 0 END AS IS_ACTIVE FROM FRAMEWORK.PUBLIC.BUILD_LOAD_SNAPSHOT T INNER JOIN LOAD_SNAPSHOT S ON T.EXECUTION_ID = S.EXECUTION_ID  WHERE COMPLETED_AT IS NULL AND T.IS_ACTIVE = FALSE GROUP BY T.EXECUTION_ID UNION ALL SELECT 0::INT)";
 var stmt = snowflake.createStatement(
          {
          sqlText: cmd
          }
          );
 var result1 = stmt.execute();
 result1.next();

  if (result1.getColumnValue(1)==true) {

    var x = true    
    var upt_cmd = "UPDATE LOAD_SNAPSHOT SET COMPLETED_AT = CURRENT_TIMESTAMP::TIMESTAMP_NTZ WHERE COMPLETED_AT IS NULL;"
    var updt_stmt = snowflake.createStatement(
          {
          sqlText: upt_cmd
          }
          );
    var result1 = updt_stmt.execute();
    result1.next();
    return x;

  } 
  else {
    
    var x = false  
    return x;
    
  }

$$
;



