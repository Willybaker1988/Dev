DECLARE @DateCreated datetime = GETDATE()
DECLARE @DateModified datetime = @DateCreated

MERGE INTO [NHS].[Mirror].[DimGeneralPracticeAddress] AS TGT
USING 
(
	--Loads the latest and unique list of GeneralPracticeAddress using the latestFileLogId
	SELECT
		 GPId
		,GeneralPracticePrimarySurgeryName
		,GeneralPracticeSecondarySurgeryName
		,AddressLine1
		,AddressLine2
		,AddressLine3
		,PostCode
		,FileLogId
		,DateCreated
		,DateModified
	FROM 
	(
		SELECT DISTINCT
			 GPId
			,GeneralPracticePrimarySurgeryName
			,GeneralPracticeSecondarySurgeryName
			,AddressLine1
			,AddressLine2
			,AddressLine3
			,PostCode
			,FileLogId
			,[ROW]			=	ROW_NUMBER() OVER (PARTITION BY GPID ORDER BY FILELOGID DESC)
			,[DateCreated]	=	@DateCreated
			,[DateModified]	=	@DateModified
		FROM  [NHS].[Transform].[DimGeneralPracticeAddress] 
	)
	D
	WHERE D.ROW = 1
) AS SRC 
ON TGT.[GPId] = SRC.[GPId]
--WHEN NOT MATCHED THEN NEW GPS FOUND IN TRANSFORM, THEREFORE INSERT NEW RECORDS INTO THE MIRROR TABLE.
WHEN NOT MATCHED THEN 
INSERT
(
     [GPId]
    ,[GeneralPracticePrimarySurgeryName]
    ,[GeneralPracticeSecondarySurgeryName]
    ,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
    ,[PostCode]
	,[FileLogId]
	,[DateCreated]
	,[DateModified]
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
	,SRC.[FileLogId]
	,SRC.[DateCreated]
	,SRC.[DateModified]
)
--WHEN A RECORD HAS BEEN MODIFIED IN TRANSFORM THEN UPDATE RECORD IN THE MIRROR TABLE.
WHEN MATCHED
			AND (
							tgt.[GeneralPracticePrimarySurgeryName] <> src.[GeneralPracticePrimarySurgeryName]
						OR	tgt.[GeneralPracticeSecondarySurgeryName] <> src.[GeneralPracticeSecondarySurgeryName]
						OR	tgt.[AddressLine1] <> src.[AddressLine1]
						OR	tgt.[AddressLine2] <> src.[AddressLine2]
						OR	tgt.[AddressLine3] <> src.[AddressLine3]
						OR	tgt.[PostCode] <> src.[PostCode]
						--Removed Reference to [FileLogId], Not needed as records which persit in earlier files will always trigger an update.
				)
				THEN UPDATE SET
							tgt.[GeneralPracticePrimarySurgeryName] = src.[GeneralPracticePrimarySurgeryName]
						,	tgt.[GeneralPracticeSecondarySurgeryName] = src.[GeneralPracticeSecondarySurgeryName]
						,	tgt.[AddressLine1] = src.[AddressLine1]
						,	tgt.[AddressLine2] = src.[AddressLine2]
						,	tgt.[AddressLine3] = src.[AddressLine3]
						,	tgt.[PostCode] = src.[PostCode]
						,  	tgt.[FileLogId] = src.[FileLogId] --Only Update the Mirror table records if an existing record has changed location details. FileLogId will identify these records
						,	tgt.[DateModified] = src.[DateModified] --Update the record in the mirror
OUTPUT
	 SRC.[GPId]
	,SRC.[GeneralPracticePrimarySurgeryName]
	,SRC.[GeneralPracticeSecondarySurgeryName]
	,SRC.[AddressLine1]
	,SRC.[AddressLine2]
	,SRC.[AddressLine3]
	,SRC.[PostCode]
	,SRC.[FileLogId]
	,SRC.[DateCreated]
	,SRC.[DateModified]
	,$Action AS [MergeAction];
	
