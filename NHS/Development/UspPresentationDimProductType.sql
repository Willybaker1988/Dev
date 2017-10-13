--TRUNCATE TABLE [NHS].[Datawarehouse].[DimProductType]

/*
	Start logging and cxpature all Inserted ProductTypes records
*/


DECLARE 
  @PackageName nvarchar(150)					= 'TEST'
, @UserName nvarchar(150)						= current_user 
, @ActivityLogDateTimeCreated datetime			= getdate()
, @Type nvarchar(25)							= 'Datawarehouse'					
, @Status nvarchar(25)							= 'Starting'
, @Comment nvarchar(255)						= 'Starting data load of new ProductTypes to [Datawarehouse].[DimProductType]'

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName
  ,@UserName
  ,@ActivityLogDateTimeCreated
  ,@Type
  ,@Status
  ,@Comment
GO

SELECT TOP 1 * FROM [DW_Framework].[NHS].[SSISExecutionLog] ORDER BY ActivityLogDateTimeCreated DESC

DECLARE @InsertCount INT = NULL

	MERGE INTO 
		[NHS].[Datawarehouse].[DimProductType] AS T
	USING 
	(
		SELECT 
			 [CHEMSUBID]
			,[CHEMSUBNAME] 
			,[DateCreated] = GETDATE()
		FROM [NHS].[Stage].[ChemicalSubstance]

	) AS S
	ON
		T.ChemicalSubstanceId = S.CHEMSUBID
	WHEN NOT MATCHED THEN INSERT (ChemicalSubstanceId, ProductType, DateActiveFrom)  VALUES (S.[CHEMSUBID], S.[CHEMSUBNAME], S.[DateCreated]);
	SET @InsertCount	= @@ROWCOUNT;

/*
	Finish logging and cxpature all Inserted ProductTypes records
*/

DECLARE 
  @PackageName nvarchar(150)			= 'TEST'
, @UserName nvarchar(150)				= current_user 
, @ActivityLogDateTimeCreated datetime	= getdate()
, @Type nvarchar(25)					= 'datawarehouse'
, @Status nvarchar(25)					= 'Finishing'
, @comment nvarchar(250)				= 'Finished data load of new ProductTypes to [Datawarehouse].[DimProductType] inserting '+CAST(@InsertCount as nvarchar(100))+''

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName
  ,@UserName
  ,@ActivityLogDateTimeCreated
  ,@Type
  ,@Status
  ,@Comment
GO

--SELECT TOP 1 * FROM [DW_Framework].[NHS].[SSISExecutionLog] ORDER BY ActivityLogDateTimeCreated DESC




