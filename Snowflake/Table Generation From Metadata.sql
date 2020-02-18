CREATE OR REPLACE TABLE SAPRAW_TABLES AS 
SELECT
    TableName,
    TableDDL,
    Insert_Statement_Parquet,
    Insert_Statement_Csv,
    Create_Pipe,
    FileName,
    SnowpipeName
FROM
(
SELECT
      TableName,
      CreateTableName,  
      InsertTableName,
      CreatePipe,
      FileName,
      SnowpipeName,
      LISTAGG(Column_Metadata, ',') AS TableColumns,
      CONCAT(CreateTableName,LISTAGG(Column_Metadata, ','),
        CASE 
          WHEN LISTAGG(PrimaryKey) = '' THEN ')'
          ELSE CONCAT(', constraint PK_', LISTAGG(PrimaryKey, '_'), ' primary key' ,'(', LISTAGG(PrimaryKey, ','), ')', ')')
        END)
      AS TableDDL,
      CONCAT(InsertTableName,LISTAGG(Column_Parquet, ','),' FROM ') AS Insert_Statement_Parquet,
      CONCAT(InsertTableName,LISTAGG(Column_CSV, ','),' FROM ') AS Insert_Statement_Csv,
      CONCAT(CreatePipe, 
LISTAGG(Column_Parquet, ' 
,'),' 
FROM 
    @SE_DATALAKE_STAGE/ 
) ') AS Create_Pipe
  FROM
  (
  SELECT 
        t.$1 AS TableName
       , CONCAT('CREATE OR REPLACE TABLE ','"', t.$1 ,'"', ' (') AS CreateTableName
       , CONCAT('INSERT INTO ','"', t.$1 ,'"', ' SELECT ') AS InsertTableName
       , t.$2 AS TablePosition
       , t.$3 AS FieldName
       , t.$4 AS KeyField
       , t.$5 AS DataType
       , t.$6 AS ABAPType
       , t.$7 AS Characters
       , t.$8 AS FileName
       , CONCAT('"SNOWPIPE_', t.$1 ,'"') AS SnowpipeName
       , CONCAT(
'CREATE OR REPLACE PIPE "SNOWPIPE_', t.$1 ,'"','
  auto_ingest = true
  integration = ''SNOWPIPE_NOTIFICATION'' 
AS
COPY INTO  SOURCE_SYSTEM_TEST.SAPRAW.', '"', t.$1, '"',
'FROM 
( 
SELECT ') AS CreatePipe
       , CASE 
              WHEN t.$6 = 'C' THEN 'VARCHAR'
              WHEN t.$6 = 'D' THEN 'DATE'
              WHEN t.$6 = 'N' THEN 'FLOAT'  
              WHEN t.$6 = 'T' THEN 'TIME'
              WHEN t.$6 = 'I' THEN 'INT'
         ELSE 'NEEDS MAPPING'
         END AS Snowflake_Mapping
       , CONCAT(t.$3 ,' ',    
                CASE 
                  WHEN t.$6 = 'C' THEN  CONCAT('VARCHAR', '(',t.$7,')') 
                  WHEN t.$6 = 'D' THEN 'DATE'
                  WHEN t.$6 = 'N' THEN 'DECIMAL(15,2)'  
                  WHEN t.$6 = 'T' THEN 'TIME'
                  WHEN t.$6 = 'I' THEN 'INT'
                ELSE 'NEEDS MAPPING'
                END)
          AS Column_Metadata
        , CONCAT('T.',t.$2,' AS ',t.$3) AS Column_CSV
        , CASE 
            WHEN t.$6 = 'D' THEN REPLACE(  
                CONCAT('$1:',t.$3,'::', 
                     CASE 
                      WHEN t.$6 = 'C' THEN  CONCAT('VARCHAR', '(',t.$7,')') 
                      WHEN t.$6 = 'D' THEN  CONCAT('TO_DATE(TO_TIMESTAMP($1:',t.$3,'))') 
                      WHEN t.$6 = 'N' THEN 'DECIMAL(15,2)'  
                      WHEN t.$6 = 'T' THEN 'TIME'
                      WHEN t.$6 = 'I' THEN 'INT'
                    ELSE 'NEEDS MAPPING'
                    END, ' AS ', t.$3
                    )
                ,CONCAT('$1:',t.$3,'::')) 
              ELSE
                CONCAT('$1:',t.$3,'::', 
                     CASE 
                      WHEN t.$6 = 'C' THEN  CONCAT('VARCHAR', '(',t.$7,')') 
                      WHEN t.$6 = 'D' THEN  CONCAT('TO_DATE(TO_TIMESTAMP($1:',t.$3,'))') 
                      WHEN t.$6 = 'N' THEN 'DECIMAL(15,2)'  
                      WHEN t.$6 = 'T' THEN 'TIME'
                      WHEN t.$6 = 'I' THEN 'INT'
                      ELSE 'NEEDS MAPPING'
                      END, ' AS ', t.$3
                    )
            END
            AS Column_Parquet
       , CASE WHEN t.$4 = 'X' THEN t.$3 ELSE NULL END AS PrimaryKey   
    FROM
      @MY_AZURE_DL_OBJECT_STAGE/MainteinanceTables.csv (file_format => my_csv_format) t
  )
  --WHERE
  --  TABLENAME = '0COSTELMNT_ATTR'
  GROUP BY 1,2,3,4,5,6)
;
