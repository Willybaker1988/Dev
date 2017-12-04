IF OBJECT_ID('[Scratch].[dbo].[ActivityLogHistory]', 'U') IS NOT NULL 
  DROP TABLE [Scratch].[dbo].[ActivityLogHistory]
ELSE
	CREATE TABLE [Scratch].[dbo].[ActivityLogHistory]
	(
	 [LoadDate]												DATE
	,[PhaseLevel]											NVARCHAR(250)
	,[PhaseFullLoadExecutionTimeSS]							INT
	,[PhaseObjssofInterestTotalLoadExecutionTimeSS]			INT
	,[PhaseExecutionDuration]								INT
	,[PhaseObjectLevel]										NVARCHAR(250)
	,[PhaseObjectFullLoadExecutionTimeSS]					INT
	,[PhaseObjectObjssofInterestTotalLoadExecutionTimeSS]	INT
	,[PhaseObjectExecutionDuration]							INT
	,[ObjectLevel]											NVARCHAR(250)								
	,[ObjectFullLoadExecutionTimeSS]						INT				
	,[ObjectObjssofInterestTotalLoadExecutionTimeSS]		INT
	,[ObjectExecutionDuration]								INT	
	,[StartPosition]										INT
	,[ActivityLogId]										INT                         
	,[Phase]												NVARCHAR(250)	
	,[Object]												NVARCHAR(250)	
	,[LogCreatedDateTime]									DATETIME
	,[FullLoadExecutionTimeSS]								INT
	,[ObjssofInterestTotalLoadExecutionTimeSS]				INT
	,[ExecutionDuration]									INT
	)

DECLARE @ETLLoadDates TABLE 
(
	 [Load_ID]				INT
	,[LoadDate]				DATE
	,[StartLoadDateTime]	DATETIME
	,[EndLoadDateTime]		DATETIME
)	
--Recurise CTE to generate ETLLoadDates, Configure @StartTime/@EndTime and @LoadDays accoridngly
DECLARE @StartTime	TIME = '02:00:00.000'
DECLARE @EndTime	TIME = '05:00:00.000'
DECLARE @LoadDate	DATE =  getdate()
DECLARE @LoadDays	INT  =  -14

; WITH [GenerateETLLoadDates] AS 
( 
  SELECT 
	 [LoadDays]					=	@LoadDays
	,[LoadDate]					=	@LoadDate
	,[StartLoadDateTime]		=	CAST(@LoadDate AS datetime) + CAST(@StartTime AS datetime) 
	,[EndLoadDateTime]			=	CAST(@LoadDate AS datetime) + CAST(@EndTime	  AS datetime) 
  UNION ALL 
  SELECT 
	 [LoadDays] +1 
	,[LoadDate]					=	CAST(DATEADD(DD,-1,CAST([LoadDate] AS datetime)) AS DATE)
	,[StartLoadDateTime]		=	DATEADD(DD,-1,CAST([LoadDate] AS datetime)) + CAST(@StartTime AS datetime) 
	,[EndLoadDateTime]			=	DATEADD(DD,-1,CAST([LoadDate] AS datetime)) + CAST(@EndTime AS datetime) 
	 
  FROM [GenerateETLLoadDates] 
  WHERE [LoadDays] <= 0

) 

INSERT INTO @ETLLoadDates ([Load_ID],[LoadDate],[StartLoadDateTime],[EndLoadDateTime])
SELECT 	[LoadDays], [LoadDate], [StartLoadDateTime]	,[EndLoadDateTime]	   			
FROM [GenerateETLLoadDates] 	   
WHERE [LoadDays] <= 0			   	


DECLARE @FrameworkObjectsofInterest TABLE 
(
	 [Object]	nvarchar (250)
	,[Grouping] nvarchar (250)
)			 
--List Objects Interested in monitoring in Load to the below INSERT INTO statement

------*******Add Objects Here*********----------- 

INSERT INTO @FrameworkObjectsofInterest

SELECT 'MetapackTrackingDelivery', 'MetapackStaging'
UNION ALL 
SELECT 'StagingMetaPackTrackingDelivery', 'MetapackStaging'
UNION ALL
SELECT 'FactParcelDeliveryTracking' , 'FactParcelDeliveryTracking'


------*******Add Objects Here*********----------- 


------*******Build Activity History Execution Times From @ETLLoadDates table**********--------
--DECLARE @Counter					INT			=	0

--SELECT 
--	MIN([Load_ID]) ,
--	CASE
--		WHEN MIN([Load_ID])  >= @Counter 
--		THEN 1 
--		ELSE 0 
--	END
--FROM @ETLLoadDates

DECLARE @Counter					INT			=	0
DECLARE @StartDateBoundary			DATETIME
DECLARE @EndDateBoundary			DATETIME

WHILE @Counter >= (SELECT MIN([Load_ID]) FROM @ETLLoadDates)


	BEGIN

	SET @StartDateBoundary	= (SELECT [StartLoadDateTime] FROM @ETLLoadDates WHERE [Load_ID] = @Counter)
	SET @EndDateBoundary	= (SELECT [EndLoadDateTime] FROM @ETLLoadDates WHERE [Load_ID] = @Counter)
	SET @LoadDate			= (SELECT [LoadDate] FROM @ETLLoadDates WHERE [Load_ID] = @Counter)
	PRINT @Counter
	PRINT @StartDateBoundary	
	PRINT @EndDateBoundary	
	PRINT @LoadDate			

		;With CTE_Load_Activity
			AS
		(
			SELECT 
				 [StartPosition]
				,[ActivityLogId]                                     
				,[Phase]
				,[Object]										
				,[LogCreatedDateTime]
				,[FullLoadExecutionTimeSS]						=	DATEDIFF(SS,[PreviousLogCreatedDateTime],[LogCreatedDateTime])
				,[ObjssofInterestTotalLoadExecutionTimeSS]		=	DATEDIFF(SS,[ObjectsofInterestPreviousLogCreatedDateTime],[LogCreatedDateTime])
				,[ExecutionDuration]
			FROM
			(
				SELECT 
					 [StartPosition]				 =	 ROW_NUMBER() OVER (ORDER BY [ActivityLogId])
					,[ActivityLogId]
					,[Phase]
					,[Object]										 =	 A.[Object]
					,[LogCreatedDateTime]
					,[PreviousLogCreatedDateTime]					 =	 CASE
																			WHEN LAG(LogCreatedDateTime,1,0) OVER (ORDER BY [ActivityLogId]) = '1900-01-01 00:00:00.000' THEN LogCreatedDateTime
																			ELSE LAG(LogCreatedDateTime,1,0) OVER (ORDER BY [ActivityLogId])
																		 END
					,[ObjectsofInterestPreviousLogCreatedDateTime]	 =	 CASE
																			WHEN OB.[Object] = '' THEN LogCreatedDateTime
																			WHEN OB.[Object] = A.[Object] AND LAG(LogCreatedDateTime,1,0) OVER (PARTITION BY OB.[Grouping] ORDER BY [ActivityLogId]) = '1900-01-01 00:00:00.000'  THEN LAG(LogCreatedDateTime,1,0) OVER (ORDER BY [ActivityLogId])
																			WHEN OB.[Object] = A.[Object] THEN LAG(LogCreatedDateTime,1,0) OVER (PARTITION BY OB.[Grouping] ORDER BY [ActivityLogId])
																			ELSE LogCreatedDateTime
																		 END
					,[ExecutionDuration]							 =	 CASE
																			WHEN A.[Step] = 'Succeeded'	or A.[Step] = 'Failed' THEN [ExecutionDuration]
																			ELSE 0
																		 END
																				
				FROM 
					DIFramework.datawarehouse.vwActivityLog A
				LEFT JOIN
					@FrameworkObjectsofInterest Ob ON A.[Object] = OB.[Object]
				WHERE 
					LogCreatedDateTime > @StartDateBoundary
				AND
					LogCreatedDateTime <= @EndDateBoundary

			)
			D
		),

		CTE_Aggregate_Object_Level
		AS
		(
			SELECT                                    
				 [ObjectLevel]											=	[Object]									
				,[ObjectFullLoadExecutionTimeSS]					=	sum([FullLoadExecutionTimeSS])						
				,[ObjectObjssofInterestTotalLoadExecutionTimeSS]	=	sum([ObjssofInterestTotalLoadExecutionTimeSS])		
				,[ObjectExecutionDuration]							=	SUM([ExecutionDuration])
			FROM
				 CTE_Load_Activity
			GROUP BY
				 [Object]	
		),

		CTE_Aggregate_PhaseObject_Level
		AS
		(
			SELECT                                    
				 [PhaseObjectLevel]										=	[Phase]	+' | '+[Object]								
				,[Phase]
				,[Object]
				,[PhaseObjectFullLoadExecutionTimeSS]					=	sum([FullLoadExecutionTimeSS])						
				,[PhaseObjectObjssofInterestTotalLoadExecutionTimeSS]	=	sum([ObjssofInterestTotalLoadExecutionTimeSS])		
				,[PhaseObjectExecutionDuration]							=	SUM([ExecutionDuration])
			FROM
				 CTE_Load_Activity
			GROUP BY
				 [Phase]
				,[Object]	
		),

		CTE_Aggregate_Phase_Level
		AS
		(
			SELECT                                    
				 [PhaseLevel]											=	[Phase]										
				,[PhaseFullLoadExecutionTimeSS]							=	sum([FullLoadExecutionTimeSS])						
				,[PhaseObjssofInterestTotalLoadExecutionTimeSS]			=	sum([ObjssofInterestTotalLoadExecutionTimeSS])	
				,[PhaseExecutionDuration]								=	SUM([ExecutionDuration])	
			FROM
				 CTE_Load_Activity
			GROUP BY
				 [Phase]	
		)
			
		INSERT INTO  [Scratch].[dbo].[ActivityLogHistory]					
		SELECT 
			 [LoadDate]	=	@LoadDate
			,PH.*
			,PO.[PhaseObjectLevel]
			,PO.[PhaseObjectFullLoadExecutionTimeSS]
			,PO.[PhaseObjectObjssofInterestTotalLoadExecutionTimeSS]
			,PO.[PhaseObjectExecutionDuration]
			,OL.*
			,A.*
		FROM
			CTE_Load_Activity A
		INNER JOIN
			CTE_Aggregate_Object_Level OL ON OL.[ObjectLevel] = A.[Object]
		INNER JOIN
			CTE_Aggregate_PhaseObject_Level PO ON PO.[Object] = A.[Object] AND PO.[Phase] = A.[Phase]
		INNER JOIN
			CTE_Aggregate_Phase_Level PH ON PH.[PhaseLevel] = A.[Phase]
		
		SET @Counter = @Counter -1

	END
