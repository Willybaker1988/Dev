CREATE OR REPLACE TABLE SAPRAW_TABLES AS 
SELECT
    TableName,
    TableDDL
FROM
(
 SELECT
      TableName,
      CreateTableName,  
      LISTAGG(Column_Metadata, ',') AS TableColumns,
      --CONCAT(CreateTableName,LISTAGG(Column_Metadata, ','),')') AS TableDDL,
      --CONCAT(CreateTableName,LISTAGG(Column_Metadata, ','),
      --       CONCAT('constraint PK_', LISTAGG(PrimaryKey, '_'), 'primary key' ,'(', LISTAGG(PrimaryKey, ','), ')')
      --       ,')') AS TableDDLPK,
      CONCAT(CreateTableName,LISTAGG(Column_Metadata, ','),
        CASE 
          WHEN LISTAGG(PrimaryKey) IS NULL THEN ')'
          ELSE CONCAT(', constraint PK_', LISTAGG(PrimaryKey, '_'), ' primary key' ,'(', LISTAGG(PrimaryKey, ','), ')', ')')
        END)
      AS TableDDL
      --CONCAT('constraint PK_', LISTAGG(PrimaryKey, '_'), 'primary key' ,'(', LISTAGG(PrimaryKey, ','), ')',',') AS TestPK
  FROM
  (
  SELECT 
         t.$1 AS TableName
       , CONCAT('CREATE OR REPLACE TABLE ', t.$1 , ' (') AS CreateTableName
       , t.$2 AS TablePosition
       , t.$3 AS FieldName
       , t.$4 AS KeyField
       , t.$5 AS DataType
       , t.$6 AS ABAPType
       , t.$7 AS Characters
       , CASE 
              WHEN t.$6 = 'C' THEN 'VARCHAR'
              WHEN t.$6 = 'D' THEN 'DATE'
         ELSE 'NEEDS MAPPING'
         END AS Snowflake_Mapping
       , CONCAT(t.$3 ,' ',    
                CASE 
                  WHEN t.$6 = 'C' THEN  CONCAT('VARCHAR', '(',t.$7,')') 
                  WHEN t.$6 = 'D' THEN 'DATE'
                ELSE 'NEEDS MAPPING'
                END)
          AS Column_Metadata
       , CASE WHEN t.$4 = 'X' THEN t.$3 ELSE NULL END AS PrimaryKey   
    FROM
      @MY_AZURE_DL_OBJECT_STAGE/TableDefinitions.csv (file_format => my_csv_format) t
  )
  GROUP BY 1,2
)
;