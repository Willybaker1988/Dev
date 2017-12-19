/*
 Start logging and cxpature all Inserted ProductTypes records
*/ 

DECLARE @InsertCount INT = NULL, @ActivityLogDateTimeCreated DATETIME = GETDATE()

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = ?
  ,@UserName      = ?    
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = ?
  ,@Status       = 'Started'
  ,@Comment       = 'Checking for new [Datawarehouse].[DimProduct] records'
  

MERGE INTO [Datawarehouse].[DimProduct] AS T
USING (  
 SELECT 
  P.[ProductId]
    ,P.[BNFCode]
    ,P.[ProductName]
    ,P.[BNFName]
    ,PT.[DimProductTypeSkey]
    ,PT.[ProductType]
    ,PT.[ChemicalSubstanceId]
    ,[DateActiveFrom] = GETDATE()
 FROM [Mirror].[DimProduct] P
 LEFT OUTER JOIN [Datawarehouse].[DimProductType] PT ON PT.[ChemicalSubstanceId] = P.[ChemicalSubstanceId]
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
 WHEN MATCHED
	AND T.[ProductName] <> S.[ProductName]
    THEN UPDATE	[ProductId] = T.[ProductId]

 ;
SET @InsertCount    = @@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)  = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimProduct]'
SET @ActivityLogDateTimeCreated  = GETDATE()
/*
 Finish logging and cxpature all Inserted ProductTypes records
*/

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = ?
  ,@UserName      = ?    
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = ?
  ,@Status       = 'Succeeded'
  ,@Comment       = @Comment