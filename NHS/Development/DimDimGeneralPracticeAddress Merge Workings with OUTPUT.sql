DECLARE @DUPS AS TABLE
(
gpid nvarchar(10)
)

INSERT INTO @DUPS 

SELECT GPId
FROM
(
	SELECT 
		[GPId], 
		MIN([IsActive]) AS [0],
		MAX([IsActive]) AS [1]
	FROM
	(

		SELECT 
			   [GPId]
			  ,[IsActive]  =  case when IsActive = 0 then 0 else 1 end
		  FROM [NHS].[Datawarehouse].[DimGeneralPracticeAddress]
	)D
	GROUP BY 
		[GPId]
)
D
WHERE
D.[1] = 0 and GPId =  'A83019'


DECLARE @DimGeneralPracticeAddress AS TABLE (
	[GPId] [varchar](6)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	[GeneralPracticePrimarySurgeryName] [varchar](50) NULL,
	[GeneralPracticeSecondarySurgeryName] [varchar](50) NULL,
	[AddressLine1] [varchar](50) NULL,
	[AddressLine2] [varchar](50) NULL,
	[AddressLine3] [varchar](50) NULL,
	[PostCode] [varchar](10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
	[FileLogId] [int] NULL
) 


INSERT INTO @DimGeneralPracticeAddress


SELECT
	[GPId] = T.[GPId],
	[GeneralPracticePrimarySurgeryName] = T.GeneralPracticePrimarySurgeryName,
	[GeneralPracticeSecondarySurgeryName]= T.GeneralPracticeSecondarySurgeryName,
	[AddressLine1] = T.AddressLine1,
	[AddressLine2] = T.AddressLine2,
	[AddressLine3] = T.AddressLine3,
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
	WHERE GPId IN (SELECT GPID FROM @DUPS)
	GROUP BY  GPId
	HAVING COUNT(DISTINCT PostCode) > 1
)d
on d.GPId = t.GPId
UNION ALL
SELECT
	M.[GPId] ,
	[GeneralPracticePrimarySurgeryName] ,
	[GeneralPracticeSecondarySurgeryName],
	[AddressLine1] ,
	[AddressLine2] ,
	[AddressLine3] ,
	[PostCode] ,
	[FileLogId]
FROM NHS.Mirror.DimGeneralPracticeAddress M
INNER JOIN @DUPS D ON M.GPId = D.gpid

DECLARE @Batches AS TABLE
(
[BatchId]	INT IDENTITY(1,1),
[FileLogId]	INT
)

INSERT INTO @Batches

SELECT DISTINCT
	[FileLogId]
FROM 
	@DimGeneralPracticeAddress ORDER BY 1


DECLARE @DateActiveFrom datetime = getdate() 
DECLARE @DateActiveTo datetime = CAST('9999-12-31 00:00:00.000' AS DATETIME)
DECLARE @IsActive BIT = 1
DECLARE @Batch INT = 1
DECLARE @TotalBatches INT = (SELECT MAX([BatchId]) from @Batches)
DECLARE @FileLoadLogId INT
DECLARE @InsertCount INT = NULL
DECLARE @ActivityLogDateTimeCreated DATETIME = GETDATE()
DECLARE @LoadComment NVARCHAR(250) = 'Day 0 load'
DECLARE @Comment NVARCHAR(250)



WHILE @Batch <= @TotalBatches
BEGIN
	SET @Comment = @LoadComment + ', processing Batch ' + CAST(@Batch as nvarchar(100))+ ' of ' + CAST(@TotalBatches as nvarchar(100))+ '.'

	PRINT @comment

	EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
	   @PackageName     = 'test'
	  ,@UserName		= 'test'
	  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
	  ,@Type			= 'test'
	  ,@Status			= 'Start'
	  ,@Comment			=  'test'
	  --''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimGeneralPracticeAddress]'''+


	SET @FileLoadLogId = (SELECT [FileLogId] from @Batches where @Batch = BatchId)
		BEGIN TRANSACTION;
			MERGE INTO [NHS].[Datawarehouse].[DimGeneralPracticeAddressDevelopment] AS TGT
				USING 
				(SELECT DISTINCT 
					[GPId] ,
					[GeneralPracticePrimarySurgeryName] ,
					[GeneralPracticeSecondarySurgeryName],
					[AddressLine1] ,
					[AddressLine2] ,
					[AddressLine3] ,
					[PostCode] ,
					[FileLogId]
				 FROM 
					@DimGeneralPracticeAddress 
				 WHERE 
					@FileLoadLogId = [FileLogId]
				) AS SRC 
				 ON TGT.[GPId] = SRC.[GPId] 
				 AND TGT.[PostCode] = SRC.[PostCode]
				WHEN NOT MATCHED THEN --WHEN NOT MATCHED THEN INSERT NEW GP PRACTICES WITH NEW POSTCODES FOUND IN MIRROR (NEW GP RECORDS).
				INSERT
				(
					 [GPId]
					,[GeneralPracticePrimarySurgeryName]
					,[GeneralPracticeSecondarySurgeryName]
					,[AddressLine1]
					,[AddressLine2]
					,[AddressLine3]
					,[PostCode]
				 ,[IsActive]
				 ,[DateActiveFrom]
				 ,[DateActiveTo]
				)
				VALUES
				(
					 SRC.[GPId]
					,SRC.[GeneralPracticePrimarySurgeryName]
					,SRC.[GeneralPracticeSecondarySurgeryName]
					,SRC.[AddressLine1]
					,SRC.[AddressLine2]
					,SRC.[AddressLine3]
					,SRC.[PostCode]
				 ,@IsActive
				 ,@DateActiveFrom
				 ,@DateActiveto
				)
				WHEN MATCHED -- FAKE CONDITION (WILL NEVER BE TRUE).
				   AND (
					 TGT.[PostCode] <> SRC.[PostCode]
					)
				 THEN UPDATE SET
					  tgt.[IsActive]		 = 0
					 ,tgt.[DateActiveTo]	= @DateActiveFrom
					 output $action, inserted.*, deleted.*;
					 SET @InsertCount		= @@ROWCOUNT;
		
   
			DECLARE @InsertComment NVARCHAR(250)   = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimGeneralPracticeAddress] for Batch ' + CAST(@Batch as nvarchar(10))+'.'
			SET @ActivityLogDateTimeCreated		   = GETDATE()

					/*
					 Log new records inserted into DimGeneralPracticeAddress.
					*/

					 EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
					   @PackageName  = 'test'
					  ,@UserName	 = 'test'
					  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
					  ,@Type		 = 'test'
					  ,@Status       = 'InProgress Insert New Records'
					  ,@Comment      = 'test'


			MERGE INTO [NHS].[Datawarehouse].[DimGeneralPracticeAddressDevelopment] AS TGT
			USING (
					SELECT DISTINCT 
					[GPId] ,
					[GeneralPracticePrimarySurgeryName] ,
					[GeneralPracticeSecondarySurgeryName],
					[AddressLine1] ,
					[AddressLine2] ,
					[AddressLine3] ,
					[PostCode] ,
					[FileLogId]
				 FROM 
					@DimGeneralPracticeAddress 
				 WHERE 
					@FileLoadLogId = [FileLogId]
				) AS SRC 
			 ON TGT.[GPId] = SRC.[GPId] 
			WHEN NOT MATCHED THEN --WHEN NOT MATCHED THEN INSERT NEW GPS FOUND IN MIRROR (NEW GP RECORDS).
			INSERT
			(
				 [GPId]
				,[GeneralPracticePrimarySurgeryName]
				,[GeneralPracticeSecondarySurgeryName]
				,[AddressLine1]
				,[AddressLine2]
				,[AddressLine3]
				,[PostCode]
			 ,[IsActive]
			 ,[DateActiveFrom]
			 ,[DateActiveTo]
			)
			VALUES
			(
				 SRC.[GPId]
				,SRC.[GeneralPracticePrimarySurgeryName]
				,SRC.[GeneralPracticeSecondarySurgeryName]
				,SRC.[AddressLine1]
				,SRC.[AddressLine2]
				,SRC.[AddressLine3]
				,SRC.[PostCode]
			 ,@IsActive
			 ,@DateActiveFrom
			 ,@DateActiveto
			)
			WHEN MATCHED -- FOR TYPE 2 RECORDS, UPDATE SCD RECORDS FOR EXISTING RECORDS IN THE DATAWAREHOUSE TABLE WHERE THE ADDRESS HS CHANGED BY UPDATING [IsActive] AND DateActiveTo.
			   AND (
				 TGT.[PostCode] <> SRC.[PostCode]
				)
			 THEN UPDATE SET
				  tgt.[IsActive]   = 0
				 ,tgt.[DateActiveTo]  = @DateActiveFrom
				 output $action, inserted.*, deleted.*;
				 SET @InsertCount = @@ROWCOUNT;
			
			
			/*
			 Log new records inserted into DimGeneralPracticeAddress.
			*/

				SET @InsertComment  = ''+CAST(@InsertCount as nvarchar(100))+' records flagged IsActive = 0 for Batch ' + CAST(@Batch as nvarchar(10))+'.'
				SET @ActivityLogDateTimeCreated  = GETDATE() 

 
				 EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
					   @PackageName  = 'test'
					  ,@UserName	 = 'test'
					  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
					  ,@Type		 = 'test'
					  ,@Status       = 'InProgress Update InactiveRecords'
					  ,@Comment      = 'test'

		COMMIT TRANSACTION;
	SET @Batch = @Batch + 1
	print @batch
END

/*
 Finish logging 
*/ 

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
	   @PackageName  = 'test'
	  ,@UserName	 = 'test'  
	  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
	  ,@Type		 = 'test'
	  ,@Status       = 'Succeeded'
	  ,@Comment      = 'Finished populating'