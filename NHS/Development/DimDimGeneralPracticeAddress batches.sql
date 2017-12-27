/*
 Start logging and cxpature all Inserted DimGeneralPracticeAddress records
*/ 

DECLARE @InsertCount INT = NULL, @ActivityLogDateTimeCreated DATETIME = GETDATE(), @Comment nvarchar(250) = 'Checking for new [Datawarehouse].[DimGeneralPracticeAddress]  records'

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = 'TEST'
  ,@UserName		= 'TEST'   
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type         = 'TEST'   
  ,@Status       = 'Started'
  ,@Comment      = @Comment


/*
Check for a Day0Load by checking if there are any records in the [Datawarehouse].[DimGeneralPracticeAddress] table
*/

DECLARE @Day0Check INT = (SELECT ISNULL(D.Day0Check,0) FROM(SELECT Day0Check =  count (*) FROM [NHS].[Datawarehouse].[DimGeneralPracticeAddress])D)
DECLARE @LoadComment NVARCHAR(250)
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


IF(@Day0Check = 0) 
	BEGIN
		SET @LoadComment = 'Day 0 load'
		INSERT INTO @DimGeneralPracticeAddress

		/*
		Day0 load logic for multiple files to preserve history of GP locations.

		The current logic will only process the most recent GP record from the latest FileLoadLog, 
		so if we have mutiple files at a day 0 we want to make sure these records are all processed in batches else we may miss the records

		The logic below identfies Gpids which have more than one postcode associated to them ib the Transform phase,
		we then pull these records back to ensure we process earliest to latest in the [datawarehouse].[DimGeneralPracticeAddress]
		ensuring we preserve history
		*/


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
				GROUP BY  GPId
				HAVING COUNT(DISTINCT PostCode) > 1
		)d
		on d.GPId = t.GPId
		UNION ALL
		SELECT
			[GPId] ,
			[GeneralPracticePrimarySurgeryName] ,
			[GeneralPracticeSecondarySurgeryName],
			[AddressLine1] ,
			[AddressLine2] ,
			[AddressLine3] ,
			[PostCode] ,
			[FileLogId]
		FROM NHS.Mirror.DimGeneralPracticeAddress 

	END
  IF(@Day0Check <> 0) 
	BEGIN
		/*
		if the load is not a day 0 then load then pull the latest record from the Mirror table.
		*/
		 SET @LoadComment =  'Loading'

		 INSERT INTO @DimGeneralPracticeAddress

		 SELECT
			[GPId] ,
			[GeneralPracticePrimarySurgeryName] ,
			[GeneralPracticeSecondarySurgeryName],
			[AddressLine1] ,
			[AddressLine2] ,
			[AddressLine3] ,
			[PostCode] ,
			[FileLogId]
		FROM NHS.Mirror.DimGeneralPracticeAddress 
	
	END

/*
Create Batches to process into the [NHS].[Datawarehouse].[DimGeneralPracticeAddress]
*/

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


WHILE @Batch <= @TotalBatches
BEGIN
	SET @Comment = @LoadComment + ', processing Batch ' + CAST(@Batch as nvarchar(100))+ ' of ' + CAST(@TotalBatches as nvarchar(100))+ '.'

	PRINT @comment

	EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
	   @PackageName      = 'TEST'
	  ,@UserName		= 'TEST'   
	  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
	  ,@Type       = 'TEST'   
	  ,@Status       = 'InProgress'
	  ,@Comment      =  @Comment
	  --''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimGeneralPracticeAddress]'''+


	SET @FileLoadLogId = (SELECT [FileLogId] from @Batches where @Batch = BatchId)
		BEGIN TRANSACTION;
			MERGE INTO [NHS].[Datawarehouse].[DimGeneralPracticeAddress] AS TGT
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
					 ,tgt.[DateActiveTo]	= @DateActiveFrom;
					 SET @InsertCount		= @@ROWCOUNT;
   
			DECLARE @InsertComment NVARCHAR(250)   = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimGeneralPracticeAddress] for Batch ' + CAST(@Batch as nvarchar(10))+'.'
			SET @ActivityLogDateTimeCreated		   = GETDATE()

					/*
					 Log new records inserted into DimGeneralPracticeAddress.
					*/

					 EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
					   @PackageName      = 'TEST'
					  ,@UserName		= 'TEST'   
					  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
					  ,@Type		 = 'TEST'   
					  ,@Status       = 'InProgress'
					  ,@Comment      = @InsertComment


			MERGE INTO [NHS].[Datawarehouse].[DimGeneralPracticeAddress] AS TGT
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
				 ,tgt.[DateActiveTo]  = @DateActiveFrom;
				 SET @InsertCount = @@ROWCOUNT;
			
			
			/*
			 Log new records inserted into DimGeneralPracticeAddress.
			*/

				SET @InsertComment  = ''+CAST(@InsertCount as nvarchar(100))+' records flagged IsActive = 0 for Batch ' + CAST(@Batch as nvarchar(10))+'.'
				SET @ActivityLogDateTimeCreated  = GETDATE() 

 
				 EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
					   @PackageName      = 'TEST'
					  ,@UserName		= 'TEST'   
					  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
					  ,@Type		 = 'TEST'   
					  ,@Status       = 'InProgress'
					  ,@Comment      = @InsertComment

		COMMIT TRANSACTION;
	SET @Batch = @Batch + 1
	print @batch
END

/*
 Finish logging 
*/ 

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
	   @PackageName      = 'TEST'
	  ,@UserName		= 'TEST'   
	  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
	  ,@Type		 = 'TEST'   
	  ,@Status       = 'Succeeded'
	  ,@Comment      = 'Finished populating'