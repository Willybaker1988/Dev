USE WAREHOUSE LOAD_WH; 
USE ROLE SYSADMIN;
USE DATABASE SOURCE_SYSTEM_TEST;
USE SCHEMA SAPRAW;



CREATE OR REPLACE VIEW VW_0COSTCENTER_0101_HIER AS

WITH CTE AS
( 
SELECT  
    * 
    ,CAST(parentId AS VARCHAR(1000))  || ',' || CAST(CAST(nodeid AS VARCHAR(1000)) AS VARCHAR(1000)) AS IdListTopDown
    ,CAST(nodeName AS varchar(1000)) AS NameList          
FROM 
    "0COSTCENTER_0101_HIER"
WHERE 
    parentId = '00000000'
UNION ALL
SELECT 
    t.* 
   ,CAST(c.IdListTopDown AS VARCHAR(1000)) || ',' || CAST(CAST(t.nodeid AS VARCHAR(1000)) AS VARCHAR(1000))
   ,CAST(c.NameList || ' | ' || t.nodename AS varchar(1000))      
FROM 
  "0COSTCENTER_0101_HIER" T
JOIN 
  CTE c ON c.nodeid = t.parentId
)

SELECT DISTINCT
    * 
FROM 
(
  SELECT 
      nodename,
      split_part(namelist, '|', 1) as key1, 
      split_part(namelist, '|', 2) as key2,
      split_part(namelist, '|', 3) as key3,
      split_part(namelist, '|', 4) as key4, 
      split_part(namelist, '|', 5) as key5,
      split_part(namelist, '|', 6) as key6,
      split_part(namelist, '|', 7) as key7, 
      split_part(namelist, '|', 8) as key8,
      split_part(namelist, '|', 9) as key9,
      split_part(namelist, '|', 10) as key10,
      split_part(namelist, '|', 11) as key11,
      split_part(namelist, '|', 12) as key12,
      split_part(namelist, '|', 13) as key13,
      split_part(namelist, '|', 14) as key14,
      split_part(namelist, '|', 15) as key15
  FROM 
  (
    SELECT  
      CTE.*
    FROM  
      CTE
    WHERE 
      NOT EXISTS(SELECT * FROM "0COSTCENTER_0101_HIER" WHERE parentId=CTE.nodeid)
    ORDER BY 
      CTE.IdListTopDown
  )
)a
left outer join 
    ( select TXTMD as level1, nodename as nodename1 from "0COSTCENTER_0101_HIER") m1 on  m1.nodename1 = trim(a.key1)
left outer join  
    ( select TXTMD as level2, nodename as nodename2 from "0COSTCENTER_0101_HIER") m2 on  m2.nodename2 = trim(a.key2)
left outer join  
    ( select TXTMD as level3, nodename as nodename3 from "0COSTCENTER_0101_HIER") m3 on  m3.nodename3 = trim(a.key3)
left outer join  
    ( select TXTMD as level4, nodename as nodename4 from "0COSTCENTER_0101_HIER") m4 on  m4.nodename4 = trim(a.key4)
left outer join  
    ( select TXTMD as level5, nodename as nodename5 from "0COSTCENTER_0101_HIER") m5 on  m5.nodename5 = trim(a.key5)
left outer join  
    ( select TXTMD as level6, nodename as nodename6 from "0COSTCENTER_0101_HIER") m6 on  m6.nodename6 = trim(a.key6)
left outer join  
    ( select TXTMD as level7, nodename as nodename7 from "0COSTCENTER_0101_HIER") m7 on  m7.nodename7 = trim(a.key7)
left outer join  
    ( select TXTMD as level8, nodename as nodename8 from "0COSTCENTER_0101_HIER") m8 on  m8.nodename8 = trim(a.key8)
left outer join  
    ( select TXTMD as level9, nodename as nodename9 from "0COSTCENTER_0101_HIER") m9 on  m9.nodename9 = trim(a.key9)
  left outer join  
    ( select TXTMD as level10, nodename as nodename10 from "0COSTCENTER_0101_HIER") m10 on  m10.nodename10 = trim(a.key10)
left outer join  
    ( select TXTMD as level11, nodename as nodename11 from "0COSTCENTER_0101_HIER") m11 on  m11.nodename11 = trim(a.key11)
left outer join  
    ( select TXTMD as level12, nodename as nodename12 from "0COSTCENTER_0101_HIER") m12 on  m12.nodename12 = trim(a.key12)
left outer join  
    ( select TXTMD as level13, nodename as nodename13 from "0COSTCENTER_0101_HIER") m13 on  m13.nodename13 = trim(a.key13)
left outer join  
    ( select TXTMD as level14, nodename as nodename14 from "0COSTCENTER_0101_HIER") m14 on  m14.nodename14 = trim(a.key14)
left outer join  
    ( select TXTMD as level15, nodename as nodename15 from "0COSTCENTER_0101_HIER") m15 on  m15.nodename15 = trim(a.key15);
                                                                                                                 
                                                                                                                 
CREATE OR REPLACE VIEW VW_CSKS AS                                                                                                                 
SELECT
     CONCAT(A.KOKRS,A.KOSTL) AS CC_ATTR_KEY_NODENAME  
    ,A.*
FROM 
    CSKS  A 
INNER JOIN  	
    (
      SELECT
         MANDT	
       , KOKRS	
       , KOSTL	
       , MAX(DATBI) AS DATBI
      FROM 
          CSKS 
      WHERE
          KOKRS = 'ENSO'
      GROUP BY
         MANDT	
       , KOKRS	
       , KOSTL	
    )
    B
     ON A.MANDT = B.MANDT
     AND A.KOKRS = B.KOKRS
     AND A.KOSTL = B.KOSTL
     AND A.DATBI = B.DATBI
;


CREATE OR REPLACE VIEW VW_CSKT AS 
SELECT
    CONCAT(A.KOKRS,A.KOSTL) AS CC_TEXT_KEY_NODENAME
  , A.*
FROM
  CSKT A
INNER JOIN
    (
      SELECT 
          MANDT	
        , SPRAS	
        , KOKRS	
        , KOSTL	
        , MAX(DATBI) AS DATBI
      FROM 
          CSKT 
      WHERE
          KOKRS = 'ENSO'
      GROUP BY
          MANDT	
        , SPRAS	
        , KOKRS	
        , KOSTL		
    ) B
     ON A.MANDT = B.MANDT
     AND A.KOKRS = B.KOKRS
     AND A.KOSTL = B.KOSTL
     AND A.DATBI = B.DATBI 
     AND A.SPRAS = B.SPRAS
;



CREATE OR REPLACE VIEW VW_0COSTELMNT_0102_HIER AS

WITH CTE AS
( 
SELECT  
    * 
    ,CAST(parentId AS VARCHAR(1000))  || ',' || CAST(CAST(nodeid AS VARCHAR(1000)) AS VARCHAR(1000)) AS IdListTopDown
    ,CAST(nodeName AS varchar(1000)) AS NameList          
FROM 
    "0COSTELMNT_0102_HIER"
WHERE
    LEAFFROM IS NULL AND LEAFTO IS NULL
AND
    parentId = '00000000'
UNION ALL
SELECT 
    t.* 
   ,CAST(c.IdListTopDown AS VARCHAR(1000)) || ',' || CAST(CAST(t.nodeid AS VARCHAR(1000)) AS VARCHAR(1000))
   ,CAST(c.NameList || ' | ' || t.nodename AS varchar(1000))      
FROM 
    "0COSTELMNT_0102_HIER" AS t
JOIN 
  CTE c ON c.nodeid = t.parentId
)

SELECT DISTINCT
    * 
FROM 
(
  SELECT 
      nodename,
      split_part(namelist, '|', 1) as key1, 
      split_part(namelist, '|', 2) as key2,
      split_part(namelist, '|', 3) as key3,
      split_part(namelist, '|', 4) as key4, 
      split_part(namelist, '|', 5) as key5,
      split_part(namelist, '|', 6) as key6,
      split_part(namelist, '|', 7) as key7, 
      split_part(namelist, '|', 8) as key8,
      split_part(namelist, '|', 9) as key9,
      split_part(namelist, '|', 10) as key10,
      split_part(namelist, '|', 11) as key11,
      split_part(namelist, '|', 12) as key12,
      split_part(namelist, '|', 13) as key13,
      split_part(namelist, '|', 14) as key14,
      split_part(namelist, '|', 15) as key15
  FROM 
  (
    SELECT  
      CTE.*
    FROM  
      CTE
    WHERE 
      NOT EXISTS(SELECT * FROM "0COSTELMNT_0102_HIER" WHERE parentId=CTE.nodeid)
    ORDER BY 
      CTE.IdListTopDown
  )
)a
left outer join 
    ( select TXTMD as level1, nodename as nodename1 from "0COSTELMNT_0102_HIER") m1 on  m1.nodename1 = trim(a.key1)
left outer join  
    ( select TXTMD as level2, nodename as nodename2 from "0COSTELMNT_0102_HIER") m2 on  m2.nodename2 = trim(a.key2)
left outer join  
    ( select TXTMD as level3, nodename as nodename3 from "0COSTELMNT_0102_HIER") m3 on  m3.nodename3 = trim(a.key3)
left outer join  
    ( select TXTMD as level4, nodename as nodename4 from "0COSTELMNT_0102_HIER") m4 on  m4.nodename4 = trim(a.key4)
left outer join  
    ( select TXTMD as level5, nodename as nodename5 from "0COSTELMNT_0102_HIER") m5 on  m5.nodename5 = trim(a.key5)
left outer join  
    ( select TXTMD as level6, nodename as nodename6 from "0COSTELMNT_0102_HIER") m6 on  m6.nodename6 = trim(a.key6)
left outer join  
    ( select TXTMD as level7, nodename as nodename7 from "0COSTELMNT_0102_HIER") m7 on  m7.nodename7 = trim(a.key7)
left outer join  
    ( select TXTMD as level8, nodename as nodename8 from "0COSTELMNT_0102_HIER") m8 on  m8.nodename8 = trim(a.key8)
left outer join  
    ( select TXTMD as level9, nodename as nodename9 from "0COSTELMNT_0102_HIER") m9 on  m9.nodename9 = trim(a.key9)
  left outer join  
    ( select TXTMD as level10, nodename as nodename10 from "0COSTELMNT_0102_HIER") m10 on  m10.nodename10 = trim(a.key10)
left outer join  
    ( select TXTMD as level11, nodename as nodename11 from "0COSTELMNT_0102_HIER") m11 on  m11.nodename11 = trim(a.key11)
left outer join  
    ( select TXTMD as level12, nodename as nodename12 from "0COSTELMNT_0102_HIER") m12 on  m12.nodename12 = trim(a.key12)
left outer join  
    ( select TXTMD as level13, nodename as nodename13 from "0COSTELMNT_0102_HIER") m13 on  m13.nodename13 = trim(a.key13)
left outer join  
    ( select TXTMD as level14, nodename as nodename14 from "0COSTELMNT_0102_HIER") m14 on  m14.nodename14 = trim(a.key14)
left outer join  
    ( select TXTMD as level15, nodename as nodename15 from "0COSTELMNT_0102_HIER") m15 on  m15.nodename15 = trim(a.key15)
    
;

CREATE OR REPLACE VIEW "VW_0COSTELMNT_TEXT" AS
SELECT
     CONCAT(A.KOKRS,A.KSTAR) AS CE_TEXT_KEY_NODENAME  
    ,A.*
FROM 
    "0COSTELMNT_TEXT"  A 
INNER JOIN  	
    (
      SELECT
         KSTAR	
       , KOKRS	
       , LANGU	
       , MAX(DATETO) AS DATETO
      FROM 
          "0COSTELMNT_TEXT"
      WHERE
          KOKRS = 'ENSO'
      GROUP BY
         KSTAR	
       , KOKRS	
       , LANGU	
    )
    B
     ON A.KSTAR = B.KSTAR
     AND A.KOKRS = B.KOKRS
     AND A.LANGU = B.LANGU
     AND A.DATETO = B.DATETO
;

CREATE OR REPLACE VIEW "VW_0COSTELMNT_ATTR" AS
SELECT
     CONCAT(A.KOKRS,A.KSTAR) AS CE_ATTR_KEY_NODENAME  
    ,A.*
FROM 
    "0COSTELMNT_ATTR"  A 
INNER JOIN  	
    (
      SELECT
         KSTAR	
       , KOKRS		
       , MAX(DATETO) AS DATETO
      FROM 
          "0COSTELMNT_ATTR"
      WHERE
          KOKRS = 'ENSO'
      GROUP BY
         KSTAR	
       , KOKRS		
    )
    B
     ON A.KSTAR = B.KSTAR
     AND A.KOKRS = B.KOKRS
     AND A.DATETO = B.DATETO
;

CREATE OR REPLACE VIEW "VW_0PROFIT_CTR_ATTR" AS
SELECT
     CONCAT(A.KOKRS,A.PRCTR) AS PR_ATTR_KEY_NODENAME  
    ,A.*
FROM 
    "0PROFIT_CTR_ATTR"  A 
INNER JOIN  	
    (
      SELECT
         KOKRS	
       , PRCTR	
       , MAX(DATETO) AS DATETO
      FROM 
          "0PROFIT_CTR_ATTR"
      WHERE
          KOKRS = 'ENSO'
      GROUP BY
         KOKRS	
       , PRCTR		
    )
    B
     ON A.KOKRS = B.KOKRS
     AND A.PRCTR = B.PRCTR
     AND A.DATETO = B.DATETO
;   

CREATE OR REPLACE VIEW "VW_0PROFIT_CTR_TEXT" AS
SELECT
     CONCAT(A.KOKRS,A.PRCTR) AS PR_TEXT_KEY_NODENAME  
    ,A.*
FROM 
    "0PROFIT_CTR_TEXT"  A 
INNER JOIN  	
    (
      SELECT
         KOKRS	
       , PRCTR
       , LANGU
       , MAX(DATETO) AS DATETO
      FROM 
          "0PROFIT_CTR_TEXT"
      WHERE
          KOKRS = 'ENSO'
      GROUP BY
         KOKRS	
       , PRCTR	
       , LANGU
    )
    B
     ON A.KOKRS = B.KOKRS
     AND A.PRCTR = B.PRCTR
     AND A.LANGU = B.LANGU
     AND A.DATETO = B.DATETO
;   
