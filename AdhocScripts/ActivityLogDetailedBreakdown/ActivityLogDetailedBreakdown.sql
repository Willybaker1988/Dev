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

;With CTE_Load_Activity
	AS
(
	SELECT 
		 [StartPosistion]
		,[ActivityLogId]                                     
		,[Phase]
		,[Object]										
		,[LogCreatedDateTime]
		,[FullLoadExecutionTimeSS]						=	DATEDIFF(SS,[PreviousLogCreatedDateTime],[LogCreatedDateTime])
		,[ObjssofInterestTotalLoadExecutionTimeSS]		=	DATEDIFF(SS,[ObjectsofInterestPreviousLogCreatedDateTime],[LogCreatedDateTime])
	FROM
	(
		SELECT 
			 [StartPosistion]				 =	 ROW_NUMBER() OVER (ORDER BY [ActivityLogId])
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
		FROM 
			DIFramework.datawarehouse.vwActivityLog A
		LEFT JOIN
			@FrameworkObjectsofInterest Ob ON A.[Object] = OB.[Object]
		WHERE
			ActivityLogId >= 2026816
		--and
		--	ActivityLogId < 1918823
		--and
		--	phase = 'staging'
		--order by
		--	ActivityLogId 
			--a.object = 'MetapackTrackingDelivery'
	)
	D
),

CTE_Aggregate_Object_Level
AS
(
	SELECT                                    
		 [ObjectLevel]											=	[Object]									
		,[PhaseObjectFullLoadExecutionTimeSS]					=	sum([FullLoadExecutionTimeSS])						
		,[PhaseObjectObjssofInterestTotalLoadExecutionTimeSS]	=	sum([ObjssofInterestTotalLoadExecutionTimeSS])		
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
	FROM
		 CTE_Load_Activity
	GROUP BY
		 [Phase]	
)


SELECT 
	 PH.*
	,PO.[PhaseObjectLevel]
	,PO.[PhaseObjectFullLoadExecutionTimeSS]
	,PO.[PhaseObjectObjssofInterestTotalLoadExecutionTimeSS]
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
ORDER BY
	A.ActivityLogId