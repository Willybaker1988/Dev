CREATE OR REPLACE TABLE SAPRAW_TABLES AS 
SELECT
    TableName,
    TableDDL,
    Insert_Statement_Parquet,
    Insert_Statement_Csv
FROM
(
SELECT
      TableName,
      CreateTableName,  
      InsertTableName,
      LISTAGG(Column_Metadata, ',') AS TableColumns,
      CONCAT(CreateTableName,LISTAGG(Column_Metadata, ','),
        CASE 
          WHEN LISTAGG(PrimaryKey) = '' THEN ')'
          ELSE CONCAT(', constraint PK_', LISTAGG(PrimaryKey, '_'), ' primary key' ,'(', LISTAGG(PrimaryKey, ','), ')', ')')
        END)
      AS TableDDL,
      CONCAT(InsertTableName,LISTAGG(Column_Parquet, ','),' FROM ') AS Insert_Statement_Parquet,
      CONCAT(InsertTableName,LISTAGG(Column_CSV, ','),' FROM ') AS Insert_Statement_Csv
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
       , CASE 
              WHEN t.$6 = 'C' THEN 'VARCHAR'
              WHEN t.$6 = 'D' THEN 'DATE'
              WHEN t.$6 = 'N' THEN 'FLOAT'  
         ELSE 'NEEDS MAPPING'
         END AS Snowflake_Mapping
       , CONCAT(t.$3 ,' ',    
                CASE 
                  WHEN t.$6 = 'C' THEN  CONCAT('VARCHAR', '(',t.$7,')') 
                  WHEN t.$6 = 'D' THEN 'DATE'
                  WHEN t.$6 = 'N' THEN 'DECIMAL(15,2)'  
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
                      ELSE 'NEEDS MAPPING'
                      END, ' AS ', t.$3
                    )
            END
            AS Column_Parquet
       , CASE WHEN t.$4 = 'X' THEN t.$3 ELSE NULL END AS PrimaryKey   
    FROM
      @MY_AZURE_DL_OBJECT_STAGE/TableFinal.csv (file_format => my_csv_format) t
  )
  --WHERE
  --  TABLENAME = '0COSTELMNT_ATTR'
  GROUP BY 1,2,3
)
;
