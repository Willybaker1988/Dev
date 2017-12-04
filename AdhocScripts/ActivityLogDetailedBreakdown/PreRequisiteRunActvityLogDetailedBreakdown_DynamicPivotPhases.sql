IF OBJECT_ID('[Scratch].[dbo].[temp]', 'U') IS NOT NULL 
	DROP TABLE [Scratch].[dbo].[temp];
ELSE
	CREATE TABLE [Scratch].[dbo].[temp]
	(
		 [LoadDate]						DATE
		,[Phase]						NVARCHAR(250)					
		,[PhaseExecutionDurationSS]		VARCHAR(8)
		,[HHMMSS]						VARCHAR(8)
		,[ETLPhaseId]					INT 
	)

;With 
	cte_CreateDatesPhases
AS
(
	  SELECT DISTINCT 
		 PhaseLevel
		,LoadDate	=	 d.LoadDate
	  FROM [Scratch].[dbo].[ActivityLogHistory] 
	  cross join 
				(
				  SELECT DISTINCT LoadDate
				  FROM 
				  [Scratch].[dbo].[ActivityLogHistory] 
				) 
				d
),

	cte_PhaseCalculations
AS
(
	SELECT 
		 [LoadDate]						=		COALESCE(AL.LoadDate,PHD.LoadDate)
		,[PhaseLevel]					=		COALESCE(AL.PhaseLevel,PHD.PhaseLevel)
		,[PhaseExecutionDuration]		=		COALESCE(AL.PhaseExecutionDuration,0)
		,[HHMMSS]						=		COALESCE(CONVERT(CHAR(8),DATEADD(SECOND,AL.PhaseExecutionDuration,0),108),CONVERT(CHAR(8),DATEADD(SECOND,0,0),108))
		,[ETLPhaseId]					=		COALESCE(EP.[ETLPhaseId],99)										
	FROM  
		cte_CreateDatesPhases PHD
	LEFT JOIN 
		[Scratch].[dbo].[ActivityLogHistory] AL ON AL.PhaseLevel = PHD.PhaseLevel AND AL.LoadDate = PHD.LoadDate
	LEFT JOIN
		[DIFramework].[datawarehouse].[ETLPhase] EP ON EP.ETLPhaseName = PHD.PhaseLevel
)
	
	INSERT INTO [Scratch].[dbo].[temp]
	SELECT
		 [LoadDate]					
		,[PhaseLevel]				
		,[PhaseExecutionDuration]	
		,[HHMMSS]					
		,[ETLPhaseId]				
	FROM 
		cte_PhaseCalculations 
	UNION ALL
	SELECT 
		 [LoadDate]
		,[PhaseLevel]				=	'TOTAL'
		,[PhaseExecutionDuration]	=	SUM([PhaseExecutionDuration])
		,[HHMMSS]					=	COALESCE(CONVERT(CHAR(8),DATEADD(SECOND,SUM([PhaseExecutionDuration]),0),108),CONVERT(CHAR(8),DATEADD(SECOND,0,0),108))
		,[ETLPhaseId]				=	0
	FROM
		cte_PhaseCalculations
	GROUP BY
		 [LoadDate]

	
DECLARE 
@COLS	AS NVARCHAR(MAX),
@QUERY  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.LoadDate) 
            FROM [Scratch].[dbo].[temp] c ORDER BY ',' + QUOTENAME(c.LoadDate) 
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = '

SELECT
	*
FROM
(
	SELECT Phase, [ETLPhaseId] ,[Type]	 = ''Seconds'', ' + @cols + ' from 
				(
					select 
						 [LoadDate]						
						,[Phase]						
						,[PhaseExecutionDurationSS]  
						,[ETLPhaseId]
					from [Scratch].[dbo].[temp] 
			   ) x
				pivot 
				(
					  max([PhaseExecutionDurationSS]) 
				 for [LoadDate]	 in (' + @cols + ')
				) p 
	UNION ALL
	SELECT Phase, [ETLPhaseId] ,[Type]	 = ''HHMMSS'', ' + @cols + ' from 
				(
					select 
						 [LoadDate]						
						,[Phase]						
						,[HHMMSS]  
						,[ETLPhaseId]
					from [Scratch].[dbo].[temp] 
			   ) x
				pivot 
				(
					  max([HHMMSS]) 
				 for [LoadDate]	 in (' + @cols + ')
				) p 
				
)
D
ORDER BY [Type],[ETLPhaseId]'

execute(@query)
drop table temp




