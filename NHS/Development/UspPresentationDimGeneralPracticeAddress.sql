DECLARE @DateActiveFrom datetime = getdate();
DECLARE @DateActiveTo	datetime = CAST('9999-12-31 00:00:00.000' AS DATETIME);
DECLARE @IsActive BIT = 1;

MERGE INTO [NHS].[Datawarehouse].[DimGeneralPracticeAddress] AS TGT
USING [NHS].[Mirror].[DimGeneralPracticeAddress] AS SRC 
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
					 tgt.[IsActive]			=	0
					,tgt.[DateActiveTo]		=	@DateActiveFrom
				--)
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


MERGE INTO [NHS].[Datawarehouse].[DimGeneralPracticeAddress] AS TGT
USING [NHS].[Mirror].[DimGeneralPracticeAddress] AS SRC 
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
					 tgt.[IsActive]			=	0
					,tgt.[DateActiveTo]		=	@DateActiveFrom
				--)
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
	



