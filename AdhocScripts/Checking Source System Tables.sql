use diframework

DECLARE @SourceSystem NVARCHAR(250) = 'Metapack'

--SELECT * FROM [datawarehouse].[SourceSystem]

SELECT 
	 ss.SourceSystemName
	,ST.SourceSystemTableId
	,ST.SourceSystemTableName
	,DW.DataWarehouseTableId
	,DW.DataWarehouseTableName
	,SSTD.DependsOnSourceSystemTableId
	,STDT.SourceSystemTableName as DependantSourceSystemTableName
	,st.DoETL 
	,dw.DoETL
	--,UC.DatawarehouseTableUniqueConstraintId
	--,UC.DatawarehouseTableColumnName
FROM 
	[datawarehouse].[SourceSystemTable] ST
INNER JOIN
	[datawarehouse].[SourceSystem] SS ON SS.SourceSystemId = St.SourceSystemId
INNER JOIN
	[datawarehouse].[DataWarehouseTableSourceSystemTable] dtss ON  dtss.SourceSystemTableId = st.[SourceSystemTableid]
INNER JOIN
	[datawarehouse].[DataWarehouseTable] DW ON DW.DataWarehouseTableId = dtss.DataWarehouseTableId
LEFT JOIN
	[datawarehouse].[SourceSystemTableDependency] SSTD ON SSTD.DependentSourceSystemTableId = ST.SourceSystemTableId
LEFT JOIN
	[datawarehouse].[SourceSystemTable] STDT ON SSTD.DependsOnSourceSystemTableId = STDT.SourceSystemTableId
--To view all unique constraints on Datawarehouse tables, uncomment join.
--LEFT JOIN
--	[datawarehouse].[DataWarehouseTableUniqueConstraint] UC ON UC.DatawarehouseTableId = DW.DatawarehouseTableId
WHERE
	SS.SourceSystemName =  @SourceSystem


SELECT 
	 ss.SourceSystemName
	,ST.SourceSystemTableId
	,ST.SourceSystemTableName
	,HT.*
FROM 
	[datawarehouse].[SourceSystemTable] ST
INNER JOIN
	[datawarehouse].[SourceSystem] SS ON SS.SourceSystemId = St.SourceSystemId
INNER JOIN
	[datawarehouse].[SourceSystemTableDeltaLoadHistory] HT ON HT.SourceSystemTableId = ST.SourceSystemTableId
WHERE
	SS.SourceSystemName =  @SourceSystem
	

