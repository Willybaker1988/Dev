USE [NHS]
GO

/****** Object:  StoredProcedure [Mirror].[uspFactPrescription]    Script Date: 14/01/2018 14:11:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Mirror].[UspFactPrescription]
@PackageName NVARCHAR(100),
@UserName	 NVARCHAR(100),
@Type		 NVARCHAR(100)
AS
BEGIN

/*
 Start logging and cxpature all Inserted HealthAuthorities records
*/ 

DECLARE @InsertCount INT = NULL, 
		@ActivityLogDateTimeCreated DATETIME = GETDATE(),
		@vPackageName NVARCHAR(100),
		@vUserName	  NVARCHAR(100),
		@vType		  NVARCHAR(100)

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = @vPackageName
  ,@UserName		 = @vUserName    
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type		  = @vType
  ,@Status       = 'Started'
  ,@Comment      = 'Inserting new records into [Mirror].[FactPrescription] '

INSERT INTO [Mirror].[FactPrescription] 
(
		 SHA
		,PCT
		,GPId
		,BNFCode
		,ChemicalSubstanceId
		,Items
		,NIC
		,ActCost
		,Qty
		,PeriodId
)

SELECT DISTINCT  
	   [SHA]
	  ,[PCT]
	  ,[GPId]					=	A.GPId
	  ,[BNFCODE]				=	f.[BNFCODE]
	  ,[ChemicalSubstanceId]	=	c.ChemicalSubstanceId
	  ,[ITEMS]
	  ,[NIC]
	  ,[ACTCOST]
	  ,[QUANTITY]
	  ,[PERIOD]
  FROM 
	[NHS].[Stage].[Prescription] F
  INNER JOIN  
	[NHS].[Mirror].[DimProduct] C ON c.BNFCode = f.BNFCODE 
  INNER JOIN 
	[NHS].[Mirror].[DimGeneralPracticeAddress] A ON A.GPId = F.PRACTICE 
  WHERE
	[PERIOD] NOT IN (SELECT DISTINCT PeriodId FROM  [NHS].[Mirror].[FactPrescription]) 
	--Needs to be changed to a MTVF as this will execute row by row and will take forever

 SET @InsertCount    = @@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)  = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Mirror].[FactPrescription]'
SET @ActivityLogDateTimeCreated  = GETDATE()
/*
 Finish logging and cxpature all Inserted HealthAuthorities records
*/

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = @vPackageName
  ,@UserName		 = @vUserName    
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type			 = @vType
  ,@Status			= 'Succeeded'
  ,@Comment			= @Comment


END 
GO


