USE [NHS]
GO

/****** Object:  StoredProcedure [Datawarehouse].[uspDimProductType]    Script Date: 14/01/2018 14:08:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Datawarehouse].[UspDimProductType]
@PackageName NVARCHAR(100),
@UserName	 NVARCHAR(100),
@Type		 NVARCHAR(100)
AS
BEGIN

/*
 Start logging and cxpature all Inserted ProductTypes records
*/ 

DECLARE @InsertCount INT = NULL, 
		@ActivityLogDateTimeCreated DATETIME = GETDATE(),
		@vPackageName NVARCHAR(100),
		@vUserName	  NVARCHAR(100),
		@vType		  NVARCHAR(100)

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = @vPackageName
  ,@UserName      = @vUserName 
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = @vType
  ,@Status       = 'Started'
  ,@Comment       = 'Checking for new [Datawarehouse].[DimProductType] records'

 MERGE INTO 
  [NHS].[Datawarehouse].[DimProductType] AS T
 USING 
 (
 SELECT 
	  [CHEMSUBID]	 
	 ,[CHEMSUBNAME]
	 ,[DateCreated]
 FROM
 (
	  SELECT 
	  --Used to Identify a unique product with 2 names. Within the same batch we may receive a product with a different product desc - so we ned to only take 1.
		[UniqueProductTypeRow]			=	ROW_NUMBER() OVER (PARTITION BY [CHEMSUBID] ORDER BY [CHEMSUBNAME]) 
	   ,[CHEMSUBID]	  = UPPER([CHEMSUBID])
	   ,[CHEMSUBNAME] = UPPER([CHEMSUBNAME]) 
	   ,[DateCreated] = GETDATE()
	  FROM [NHS].[Stage].[ChemicalSubstance] 
  )
  D
  WHERE D.[UniqueProductTypeRow] = 1

 ) AS S
 ON
  T.ChemicalSubstanceId = S.CHEMSUBID
 WHEN NOT MATCHED THEN INSERT (ChemicalSubstanceId, ProductType, DateActiveFrom)  VALUES (S.[CHEMSUBID], S.[CHEMSUBNAME], S.[DateCreated]);
 SET @InsertCount    = @@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)  = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimProductType]'
SET @ActivityLogDateTimeCreated  = GETDATE()
/*
 Finish logging and cxpature all Inserted ProductTypes records
*/

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = @vPackageName
  ,@UserName      = @vUserName  
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = @vType
  ,@Status       = 'Succeeded'
  ,@Comment       = @Comment

  end
GO


