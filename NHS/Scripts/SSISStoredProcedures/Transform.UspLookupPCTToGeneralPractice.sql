USE [NHS]
GO

/****** Object:  StoredProcedure [Transform].[uspLookupPCTToGeneralPractice]    Script Date: 14/01/2018 14:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Transform].[UspLookupPCTToGeneralPractice]
AS
BEGIN

--Checking for practices which have fallen under multiple PCTs and if there is only returning the latest record for that practice
--This is to enforce a 1-to-M relationship between [Datawarehouse].[DimPrimaryCareTrust] and [Datawarehouse].[DimGeneralPracticeAddress]
--Then only insert new records WHERE NOT EXIST in current [LookupPCTToGeneralPractice]


IF EXISTS 
	(select * from tempdb.SYS.objects where name like '%temp%' )
DROP TABLE #temp
CREATE TABLE  #temp 
(
	PrimaryTrustId VARCHAR (6),
	GPID VARCHAR (3)
)

INSERT INTO #temp

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
	on pr.PRACTICE = f.PRACTICE

INSERT INTO [Transform].[LookupPCTToGeneralPractice]

select 
	 PrimaryTrustId
	,GPID
from #temp
where 
		 NOT EXISTS 
		 (
			SELECT
				 PrimaryTrustId
				,GPID
			FROM 
				[Transform].[LookupPCTToGeneralPractice]
		 )



end
GO


