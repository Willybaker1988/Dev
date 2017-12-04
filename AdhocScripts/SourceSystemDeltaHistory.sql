--SourceSystemTableDeltaLoadHistory
SELECT 
	DL.PackageDeltaLoadHistoryID,
	DL.Logid,
	DL.SourceSystemTableID,
	S.SourceSystemTableName,
	DL.DeltaDateFrom,
	DL.DeltaDateTo,
	DL.ExtractRowCount,
	s.DoEtl
FROM
	[datawarehouse].[SourceSystemTableDeltaLoadHistory] DL
INNER JOIN
	[datawarehouse].[SourceSystemTable] S ON S.SourceSystemTableId = DL.SourceSystemTableId
INNER JOIN 
	[datawarehouse].[SourceSystem] SS on SS.SourceSystemId = S.SourceSystemId
WHERE
	SS.SourceSystemName LIKE '%ADOBE%'
