--SourceSystem Dependencies
SELECT 
	SS.SourceSystemTableName, D.DependentSourceSystemTableId, SSD.SourceSystemTableName, D.DependsOnSourceSystemTableId
FROM	
	[datawarehouse].[SourceSystemTableDependency] D
INNER JOIN
	[datawarehouse].[SourceSystemTable] SS ON D.DependentSourceSystemTableId = SS.SourceSystemTableId
INNER JOIN
	[datawarehouse].[SourceSystemTable] SSD ON D.DependSoNSourceSystemTableId = SSD.SourceSystemTableId