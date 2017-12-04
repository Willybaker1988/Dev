USE DIFramework

DECLARE @LatestLoadDate DATE = CAST(GETDATE() AS DATE)
--SELECT @LatestLoadDate
	
SELECT 
	 Phase 
	,MIN([LogCreatedDateTime]) AS PhaseStartTime
	,MAX([LogCreatedDateTime]) AS PhaseStartTime
	,DATEDIFF(SS,MIN([LogCreatedDateTime]),MAX([LogCreatedDateTime]))
FROM 
	[datawarehouse].[ActivityLog]
WHERE 
	CAST([LogCreatedDateTime] AS DATE) = @LatestLoadDate
GROUP BY
	Phase


SELECT 
	 Phase 
	,DATEDIFF(SS,MIN([LogCreatedDateTime]),MAX([LogCreatedDateTime]))
FROM 
	[datawarehouse].[ActivityLog]
WHERE 
	CAST([LogCreatedDateTime] AS DATE) = @LatestLoadDate
GROUP BY
	Phase


SELECT 
	 Phase 
	,MIN([LogCreatedDateTime]) AS PhaseStartTime
	,MAX([LogCreatedDateTime]) AS PhaseStartTime
	,DATEDIFF(SS,MIN([LogCreatedDateTime]),MAX([LogCreatedDateTime]))
FROM 
	[datawarehouse].[ActivityLog]
WHERE 
	CAST([LogCreatedDateTime] AS DATE) = @LatestLoadDate
GROUP BY
	Phase


SELECT 
	 Phase 
	,DATEDIFF(SS,MIN([LogCreatedDateTime]),MAX([LogCreatedDateTime]))
FROM 
	[datawarehouse].[ActivityLog]
WHERE 
	CAST([LogCreatedDateTime] AS DATE) = @LatestLoadDate
GROUP BY
	Phase



