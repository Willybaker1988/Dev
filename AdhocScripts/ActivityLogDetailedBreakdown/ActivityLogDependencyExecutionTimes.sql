DECLARE @STARTTIME DATETIME = '2017-05-16 02:00:00.000' -- ETLStartTime
DECLARE @ENDTIME DATETIME = '2017-05-16 07:27:21.847'	-- ETLEndTime

--SELECT 
--	Phase,
--	Phase, 
--	sum(ExecutionDuration) as SS
--FROM [datawarehouse].[vwActivityLog] 
--WHERE 
--	LogCreatedDateTime > @STARTTIME
--AND
--	LogCreatedDateTime <= @ENDTIME
--AND
--	Phase = 'ToTransform'
--GROUP BY
--	Phase
--UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 0' AND Phase = 'Staging' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 1' AND Phase = 'Staging' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 2' AND Phase = 'Staging' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 3' AND Phase = 'Staging' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 4' AND Phase = 'Staging' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 0' AND Phase = 'ToTransform' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 1' AND Phase = 'ToTransform' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 0' AND Phase = 'ToMirror' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 1' AND Phase = 'ToMirror' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 0' AND Phase = 'Publish' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 1' AND Phase = 'Publish' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 0' AND Phase = 'PostPublish' AND  STEP = 'Succeeded'
UNION ALL
SELECT 
	Object, 
	Phase, 
	ExecutionDuration as SS
FROM [datawarehouse].[vwActivityLog] 
WHERE 
	LogCreatedDateTime > @STARTTIME
AND
	LogCreatedDateTime <= @ENDTIME
AND
	Object = 'Dependency level 1' AND Phase = 'PostPublish' AND  STEP = 'Succeeded'

