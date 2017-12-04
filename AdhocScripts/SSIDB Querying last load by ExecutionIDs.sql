DECLARE @Loaddate DATETIME	=	CAST(GETDATE() AS DATE)
--Have the Execution ID as a variable, as you could have instances where the load/package has been executed multiple times in one day
--E.G. failures and restarts (The ExecutionBoundaries and Earliest\Latest Identify Package Executions of the latest Load)
DECLARE @EarliestExecutionID_Boundary INT = 	(SELECT
													EarliestExecutionID_Boundary	=	MIN(EarliestExecutionID_Boundary)
												FROM
													(
													SELECT 
														MIN(execution_id) AS EarliestExecutionID_Boundary, 
														MIN(created_time) AS EarliestExecution
													FROM SSISDB.catalog.executions 
													where 
														cast(created_time as date) = @Loaddate
													AND
														(package_name IN	('BuildLoad.dtsx','DataWarehouseMaster.dtsx') AND environment_name = 'CentralConfig-ProdSources' )
													GROUP BY
														execution_id
													)
													D)
DECLARE @LatestExecutionID_Boundary INT =		(SELECT
													LatestExecutionID_Boundary		=	MAX(LatestExecutionID_Boundary)
												FROM
													(
													SELECT 
														MAX(execution_id) AS LatestExecutionID_Boundary 
														,MAX(created_time) AS LatestExecution
													FROM SSISDB.catalog.executions 
													where 
														cast(created_time as date) = @Loaddate
													AND
														(package_name IN	('BuildLoad.dtsx','DataWarehouseMaster.dtsx') AND environment_name = 'CentralConfig-ProdSources' )
													GROUP BY
														execution_id
													)
													D)




SELECT 
	 e.execution_id
	,em.event_message_id
	,CAST(em.message_time AS Datetime) as message_time
	,em.event_name
    ,em.package_name
	,em.message
	,em.package_path
	,em.execution_path

FROM 
	SSISDB.catalog.event_messages em
LEFT JOIN 
	SSISDB.catalog.executions E ON eM.operation_id = E.execution_id
LEFT JOIN	
	SSISDB.[internal].[execution_data_statistics] DS ON DS.execution_id = E.execution_id
WHERE
	e.execution_id BETWEEN @EarliestExecutionID_Boundary AND @LatestExecutionID_Boundary
ORDER BY
	EM.MESSAGE_TIME DESC

SELECT * FROM SSISDB.catalog.executions 
where cast(created_time as date) = @Loaddate
order by execution_id desc


--SELECT
--	EarliestExecutionID_Boundary	=	MIN(EarliestExecutionID_Boundary)
--FROM
--	(
--	SELECT 
--		MIN(execution_id) AS EarliestExecutionID_Boundary, 
--		MIN(created_time) AS EarliestExecution
--	FROM SSISDB.catalog.executions 
--	where 
--		cast(created_time as date) = @Loaddate
--	AND
--		(package_name IN	('BuildLoad.dtsx','DataWarehouseMaster.dtsx') AND environment_name = 'CentralConfig-ProdSources' )
--	GROUP BY
--		execution_id
--	)
--	D

--SELECT
--EarliestExecutionID_Boundary	=	MIN(EarliestExecutionID_Boundary)
----   ,LatestExecutionID_Boundary		=	MAX(LatestExecutionID_Boundary)
----FROM
--	(
--	SELECT 
--		MIN(execution_id) AS EarliestExecutionID_Boundary, 
--		MIN(created_time) AS EarliestExecution--,
--		--MAX(execution_id) AS LatestExecutionID_Boundary, 
--		--MAX(created_time) AS LatestExecution
--	FROM SSISDB.catalog.executions 
--	where 
--		cast(created_time as date) = @Loaddate
--	AND
--		(package_name IN	('BuildLoad.dtsx','DataWarehouseMaster.dtsx') AND environment_name = 'CentralConfig-ProdSources' )
--	GROUP BY
--		execution_id
--	)
--	D




----WHERE EXECUTION_ID = 20273