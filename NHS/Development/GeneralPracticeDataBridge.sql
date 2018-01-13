/*
 Datawarehouse Fact Prescription
 -Transform the Fact to take all the Skeys from the relevant Dimension tables

 Capture all records inserted in trnasformation of FactPrescription

*/ 

DECLARE @InsertCount INT = NULL, @ActivityLogDateTimeCreated DATETIME = GETDATE()

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = ?
  ,@UserName      = ?    
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = ?
  ,@Status       = 'Started'
  ,@Comment      = 'Inserting new records into [Datawarehouse].[FactPrescription] '


USE tempdb;
IF EXISTS (SELECT name FROM sys.tables wHERE name like '%#tempgps%')
DROP TABLE #tempgps
CREATE TABLE #tempgps
(
	GPId		varchar(6)  COLLATE SQL_Latin1_General_CP1_CI_AS, 
	PeriodId	INT,   
	FileLogId	INT, 
	PostCode	varchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS
)
CREATE NONCLUSTERED	INDEX IX_tempgps ON #tempgps (GPId, FileLogId);

/*

The below logic is for the type 2 dimension [NHS].[Datawarehouse].[DimGeneralPracticeAddress] so we persist the correct data in the Fact.+

**	Need to add delta into loads as do not want to reinsert the same data again, could use the FileLogId	**

*/ 


INSERT INTO #tempgps
SELECT DISTINCT 
	M.GPId, 
	PeriodId, 
	FL.FileLogId, 
	PostCode
FROm
	[NHS].[Mirror].[FactPrescription] M
INNER JOIN
	[DW_Framework].[NHS].[FileLoadLog] FL ON M.PeriodId = FL.Period
INNER JOIN 	
	[DW_Framework].[NHS].[ProcessingFileTypes] T ON t.FileType = FL.FileType
INNER JOIN 
(
			SELECT
				[GPId] = T.[GPId],
				[PostCode]	   = T.PostCode,
				[FileLogId]    = T.FileLogId
			FROM
				[NHS].[Transform].[DimGeneralPracticeAddress] t
			INNER JOIN
			(
					SELECT 
						 GPId,
						 COUNT(DISTINCT PostCode) as Dups
					FROM  [NHS].[Transform].[DimGeneralPracticeAddress] 
					GROUP BY  GPId
					HAVING COUNT(DISTINCT PostCode) > 1
			)d
			on d.GPId = t.GPId
			UNION ALL
			SELECT
				[GPId] ,
				[PostCode] ,
				[FileLogId]
			FROM NHS.Mirror.DimGeneralPracticeAddress 
)
E ON 
	M.GPId = E.GPId
AND
	FL.FileLogId = E.FileLogId

INSERT INTO [NHS].[Datawarehouse].[FactPrescription]
(
	   [PrescriptionRecordId]		
	  ,[DimPeriodSKey]				
	  ,[DimHealthAuthroritySkey]	
	  ,[DimPrimaryCareTrustSkey]	
	  ,[DimGeneralPracticeSKey]		
	  ,[DimProductSkey]				
	  ,[DimProductTypeSkey]			
      ,[Items]						
      ,[NIC]						
      ,[ActCost]					
      ,[Qty]						
)

SELECT DISTINCT 
	   [PrescriptionRecordId]
	  ,[DimPeriodSKey]					=	D.[DimPeriodSKey]
	  ,[DimHealthAuthroritySkey]		=	SHA.DimHealthAuthroritySkey
	  ,[DimPrimaryCareTrustSkey]		=	pct.DimPrimaryCareTrustSkey
	  ,[DimGeneralPracticeSKey]			=	GP.DimGeneralPracticeSKey
	  ,[DimProductSkey]					=	P.DimProductSkey
	  ,[DimProductTypeSkey]				=	PT.DimProductTypeSkey
      ,[Items]
      ,[NIC]
      ,[ActCost]
      ,[Qty]
FROM
(
		select 
			[PrescriptionRecordId], 
			[SHA] ,
			[PCT] ,
			[GPId]	=	F.[GPId],
			[BNFCode] ,
			[ChemicalSubstanceId],
			[Items] ,
			[NIC] ,
			[ActCost] ,
			[Qty] ,
			[PeriodId] = F.[PeriodId],
			B.[PostCode]
		FROm
			[NHS].[Mirror].[FactPrescription] F
		INNER JOIN
			#tempgps B ON B.GPId = F.GPId AND B.PeriodId = F.PeriodId
)
F
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[DimProduct] P ON F.[BNFCode] = P.[BNFCode]
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[DimProductType] PT ON P.[ChemicalSubstanceId] = PT.[ChemicalSubstanceId]
  LEFT OUTER JOIN 
	[NHS].[Datawarehouse].[DimGeneralPracticeAddress] GP ON F.[GPId] = GP.[GPId] AND F.[PostCode] = GP.[PostCode]
  LEFT OUTER JOIN
	[NHS].[Transform].[LookupPCTToGeneralPractice] LKP ON GP.[GPId] = LKP.[GPId]
  LEFT OUTER JOIN 
	[NHS].[Datawarehouse].[DimPrimaryCareTrust] PCT ON PCT.[PrimaryTrustId] = LKP.[PrimaryTrustId]
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[DimHealthAuthority] SHA ON SHA.[DimHealthAuthroritySkey] = PCT.[DimHealthAuthroritySkey] --Should be changed to Bkeys rather than Skeys
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[vwDimDate] D ON F.[PeriodId] = D.[PeriodId]


DROP TABLE #tempgps

SET @InsertCount    = @@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)  = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[FactPrescription]'
SET @ActivityLogDateTimeCreated  = GETDATE()
/*
 Finish logging and cxpature all Inserted HealthAuthorities records
*/

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = ?
  ,@UserName      = ?    
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = ?
  ,@Status       = 'Succeeded'
  ,@Comment       = @Comment
	
