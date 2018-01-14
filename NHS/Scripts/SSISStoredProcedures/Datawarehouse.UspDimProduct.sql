USE [NHS]
GO

/****** Object:  StoredProcedure [Datawarehouse].[uspDimProduct]    Script Date: 14/01/2018 14:08:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Datawarehouse].[UspDimProduct]
@PackageName NVARCHAR(100),
@UserName	 NVARCHAR(100),
@Type		 NVARCHAR(100)
AS
BEGIN


/*
 Start logging and cxpature all Inserted Product records
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
  ,@Comment       = 'Checking for new [Datawarehouse].[DimProduct] records'
  

MERGE INTO [Datawarehouse].[DimProduct] AS T
USING (  
SELECT 
     [ProductId]
    ,[BNFCode]
    ,[ProductName]
    ,[BNFName]
    ,[DimProductTypeSkey]
    ,[ProductType]
    ,[ChemicalSubstanceId]
    ,[DateActiveFrom] 
FROM
(
	 SELECT
		--Used to Identify a unique product with 2 names. Within the same batch we may receive a product with a different product desc - so we ned to only take 1.
		[UniqueProductRow]			=	ROW_NUMBER() OVER (PARTITION BY P.[ProductId] ORDER BY P.[ProductName]) 
		,P.[ProductId]
		,P.[BNFCode]
		,P.[ProductName]
		,P.[BNFName]
		,PT.[DimProductTypeSkey]
		,PT.[ProductType]
		,PT.[ChemicalSubstanceId]
		,[DateActiveFrom] = GETDATE()
	 FROM [Mirror].[DimProduct] P
	 LEFT OUTER JOIN [Datawarehouse].[DimProductType] PT ON PT.[ChemicalSubstanceId] = P.[ChemicalSubstanceId]
	)
D
WHERE D.UniqueProductRow = 1
)AS S
ON 
 T.[BNFCode] = S.[BNFCode]
WHEN NOT MATCHED 
 THEN INSERT 
 (
  [ProductId], 
  [BNFCode], 
  [ProductName],
  [BNFName],
  [DimProductTypeSkey],
  [ProductType],
  [ChemicalSubstanceId],
  [DateActiveFrom]
 ) 
 VALUES 
 (
  S.[ProductId], 
  S.[BNFCode], 
  S.[ProductName],
  S.[BNFName],
  S.[DimProductTypeSkey],
  S.[ProductType],
  S.[ChemicalSubstanceId],
  S.[DateActiveFrom]
 )
 ;
SET @InsertCount    = @@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)  = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimProduct]'
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

END
GO


