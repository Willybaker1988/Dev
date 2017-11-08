--Checking for practices which have fallen under multiple PCTs and if there is only returning the latest record for that practice

SELECT distinct
	[Practice]	=	pr.[Practice] ,
	[Pct]		=	COALESCE(f.[PCT],pr.[PCT])
FROM 
	[NHS].[Stage].[Prescription] pr
LEFT JOIN
	(
		SELECT 
			pr.[Practice] ,
			[PCT]
		FROM 
			[NHS].[Stage].[Prescription] pr
		INNER JOIN 
		(
			SELECT
				P.Practice,
				[EarliestFileLogId]	=	MIN(FileLogId)
			FROM [NHS].[Stage].[Prescription] p
			INNER JOIN
				(
				SELECT
					[Practice],
					[PCTs]		=	count( distinct PCT)
				FROM [NHS].[Stage].[Prescription] 
				group by
					Practice
				having 
					count( distinct PCT) > 1
				) f ON P.PRACTICE = F.PRACTICE
			GROUP BY
				 P.PRACTICE
		)d 
		on pr.PRACTICE = d.PRACTICE and pr.FileLogId  = d.[EarliestFileLogId]
	)f
	on pr.PRACTICE = f.PRACTICE --and pr.PCT = f.PCT
order by
	f.[PCT]

 

SELECT * FROM 
[NHS].[Stage].[Prescription] 
WHERE sha = 'XXX'


--Insert 2 test records to check duplicate PCT and practivces logic above
 
INSERT INTO [NHS].[Stage].[Prescription] 



SELECT 
'XXX',	
'TES',	
'TEST',
'TEST',
'TEST'     ,    
1	,
CAST( 6.66 AS DECIMAL(11,9))	,
CAST( 6.66 AS DECIMAL(11,9)),	
8,	
201608,	
3
UNION ALL
SELECT 'XXX',	'TE1',	'TEST','TEST',	'TEST'     ,    1	,6.66	,6.18,	8,	201608,	4







--SELECT DISTINCT
--	[Practice],
--	[PCT], 
--	[FileLogId],
--	ROW_NUMBER() OVER (PARTITION BY [FileLogId] ORDER BY  [Practice] , [PCT])
--FROM [NHS].[Stage].[Prescription] 

	