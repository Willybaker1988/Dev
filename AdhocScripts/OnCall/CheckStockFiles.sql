SELECT TOP 12 
      Convert(Date,FileDate) As FileDate, 
	  FC.[WarehouseReference],
      CASE 
      WHEN SourceFile LIKE '%RP%' THEN 'FC01' 
      WHEN SourceFile LIKE 'FC01_InventorySnapsho%' THEN 'FC01' 
      WHEN SourceFile LIKE '%FC04%' THEN 'FC04' 
      WHEN SourceFile LIKE '%FC03%' THEN 'FC03' 
	  WHEN SourceFile LIKE '%RC%' THEN 'RC42'
	  WHEN SourceFile LIKE '%IWT%' THEN 'FC00'
      ELSE 'UnknownFC' 
      END As Warehouse, 
      [RecordCount]	=	SUM(RecordCount) 
FROM 
      DIFramework.datawarehouse.FileLoadLog FL
INNER JOIN
	  [DataWarehouse].[datawarehouse].[DimFulfilmentCentre] FC ON CASE 
																		  WHEN SourceFile LIKE '%RP%' THEN 'FC01' 
																		  WHEN SourceFile LIKE 'FC01_InventorySnapsho%' THEN 'FC01' 
																		  WHEN SourceFile LIKE '%FC04%' THEN 'FC04' 
																		  WHEN SourceFile LIKE '%FC03%' THEN 'FC03' 
																		  WHEN SourceFile LIKE '%RC%' THEN 'RC42' 
																		  WHEN SourceFile LIKE '%IWT%' THEN 'FC00'
																		  ELSE 'UnknownFC' 
																		  END = FC.ExternalWarehouseId

WHERE 
     ( SourceFile LIKE '%rp%' 
          or 
      SourceFile LIKE 'FC01_InventorySnapsho%' 
      OR 
		SourceFile LIKE '%FC0%'
	  or
		SourceFile LIKE '%RC%' 
	  or
		SourceFile LIKE '%IWT%' 
	  ) 
      AND FileDate <> '1900-01-01' 
      AND SourceFile NOT LIKE '%Receipt%' 
GROUP BY
      Convert(Date,FileDate) , 
	  FC.[WarehouseReference],
      CASE 
      WHEN SourceFile LIKE '%RP%' THEN 'FC01' 
      WHEN SourceFile LIKE 'FC01_InventorySnapsho%' THEN 'FC01' 
      WHEN SourceFile LIKE '%FC04%' THEN 'FC04' 
      WHEN SourceFile LIKE '%FC03%' THEN 'FC03' 
	  WHEN SourceFile LIKE '%RC%' THEN 'RC42' 
	  WHEN SourceFile LIKE '%IWT%' THEN 'FC00'
      ELSE 'UnknownFC' 
      END
ORDER BY 
      Convert(Date,FileDate) desc,  SUM(RecordCount) desc  


	  --SELECT CAST(FILEDATE AS DATE), SourceFile FROM 
   --   DIFramework.datawarehouse.FileLoadLog  WHERE CAST(FILEDATE AS DATE) < CAST(GETDATE()-7 AS DATE) AND SourceFile LIKE '%iwt%' order by CAST(FILEDATE AS DATE) desc