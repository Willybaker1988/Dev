set nocount on;

USE master;

GO
	IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'NHS')
	DROP DATABASE [NHS];
GO

PRINT '...Dropped database [NHS] on instance '+ @@servername+'.' 

GO
	IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'NHS')
	CREATE DATABASE [NHS];
GO

PRINT '...Created database [NHS] on instance '+ @@servername+'.'

GO
	USE [NHS];
GO

PRINT 
'



****************...Starting creation of all NHS database objects......*******************




'

PRINT '...Creating schemas'
GO
	CREATE SCHEMA [Stage]
GO
PRINT '...Created schema [Stage]'
GO
	CREATE SCHEMA [Datawarehouse]
GO
PRINT '...Created schema [Datawarehouse]'
GO
	CREATE SCHEMA [Transform]
GO
PRINT '...Created schema [Transform]'
GO
	CREATE SCHEMA [Mirror]
GO
PRINT '...Created schema [Mirror]'
GO
PRINT '...Finished Schemas'



PRINT '...Creating Staging Tables...'

go

CREATE TABLE [Stage].[Prescription](
	[SHA] [varchar](3) NULL,
	[PCT] [varchar](3) NULL,
	[PRACTICE] [varchar](6) NULL,
	[BNFCODE] [varchar](15) NULL,
	[BNFNAME] [varchar](40) NULL,
	[ITEMS] [int] NULL,
	[NIC] [decimal](11, 2) NULL,
	[ACTCOST] [decimal](11, 2) NULL,
	[QUANTITY] [int] NULL,
	[PERIOD] [int] NULL,
	[FileLogId] [int] NULL
) ON [PRIMARY]
GO

PRINT '...Created [Stage].[Prescription]...'

GO

CREATE TABLE [Stage].[GPAddress](
	[PERIOD] [int] NULL,
	[GPId] [varchar](6) NULL,
	[GPSurgeryName] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[Address3] [varchar](50) NULL,
	[PostCode] [varchar](10) NULL,
	[FileLogId] [int] NULL
) ON [PRIMARY]

GO

PRINT '...Created [Stage].[GPAddress]...'

GO

CREATE TABLE [Stage].[ChemicalSubstance](
	[CHEMSUBId] [varchar](9) NULL,
	[CHEMSUBNAME] [varchar](150) NULL,
	[PERIOD] [int] NULL,
	[FileLogId] [int] NULL
) ON [PRIMARY]
GO


PRINT '...Created [Stage].[ChemicalSubstance]...'

PRINT '...Creating Transform Tables...'


GO

CREATE TABLE [Transform].[FactPrescription](
	[SHAId] [varchar](3) NULL,
	[PCTId] [varchar](3) NULL,
	[GPId] [varchar](6) NULL,
	[BNFId] [varchar](15) NULL,
	[MedicineName] [varchar](40) NULL,
	[Units] [int] NULL,
	[NIC] [decimal](11, 2) NULL,
	[ActCost] [decimal](11, 2) NULL,
	[Qty] [int] NULL,
	[PeriodId] [int] NULL,
	[FileLogId] [int] NULL
) ON [PRIMARY]
GO


PRINT '...Created [Transform].[FactPrescription]...'

GO

CREATE TABLE [Transform].[DimGeneralPracticeAddress](
	[GPId] [varchar](6) NULL,
	[GeneralPracticePrimarySurgeryName] [varchar](50) NULL,
	[GeneralPracticeSecondarySurgeryName] [varchar](50) NULL,
	[AddressLine1] [varchar](50) NULL,
	[AddressLine2] [varchar](50) NULL,
	[AddressLine3] [varchar](50) NULL,
	[PostCode] [varchar](10) NULL,
	[FileLogId] [int] NULL
) ON [PRIMARY]


GO

PRINT '...Created [Transform].[DimGeneralPracticeAddress]...'

GO

CREATE TABLE [Transform].[LookupPCTToGeneralPractice](
	[GPId] [varchar](6) NULL,
	[PrimaryTrustId] [varchar](3) NULL
) ON [PRIMARY]
GO


PRINT '...Created [Transform].[LookupPCTToGeneralPractice]...'


PRINT '...Creating Mirror Tables...'

GO

CREATE TABLE [Mirror].[DimGeneralPracticeAddress](
	[GPId] [varchar](6) NULL,
	[GeneralPracticePrimarySurgeryName] [varchar](50) NULL,
	[GeneralPracticeSecondarySurgeryName] [varchar](50) NULL,
	[AddressLine1] [varchar](50) NULL,
	[AddressLine2] [varchar](50) NULL,
	[AddressLine3] [varchar](50) NULL,
	[PostCode] [varchar](10) NULL,
	[FileLogId] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL
) ON [PRIMARY]
GO

PRINT '...Created [Mirror].[DimGeneralPracticeAddress]...'

GO

CREATE TABLE [Mirror].[FactPrescription]
(
	[PrescriptionRecordId] INT IDENTITY  (1,1)  ,
	[SHA] [varchar](3) NULL,
	[PCT] [varchar](3) NULL,
	[GPId] [varchar](6) NULL,
	[BNFCode] [varchar](15) NULL,
	[ChemicalSubstanceId] [VARCHAR](9) NULL,
	[Items] [int] NULL,
	[NIC] [decimal](11, 2) NULL,
	[ActCost] [decimal](11, 2) NULL,
	[Qty] [int] NULL,
	[PeriodId] [int] NULL
)
GO

PRINT '...Created [Mirror].[FactPrescription]...'

GO

CREATE TABLE [Mirror].[DimProduct](
	[ProductId] [varchar](15) NULL,
	[BNFCode] [varchar](15) NULL,
	[ProductName] [varchar](40) NULL,
	[BNFName] [varchar](40) NULL,
	[ChemicalSubstanceId] [varchar](9) NULL
) ON [PRIMARY]
GO

PRINT '...Created[Mirror].[DimProduct]...'



PRINT '...Creating Datawarehouse Tables...'

GO

CREATE TABLE [Datawarehouse].[DimGeneralPracticeAddress](
	[DimGeneralPracticeSKey] [int] IDENTITY(1,1) NOT NULL,
	[GPId] [varchar](6) NOT NULL,
	[GeneralPracticePrimarySurgeryName] [varchar](50) NOT NULL,
	[GeneralPracticeSecondarySurgeryName] [varchar](50) NOT NULL,
	[AddressLine1] [varchar](50) NOT NULL,
	[AddressLine2] [varchar](50) NOT NULL,
	[AddressLine3] [varchar](50) NOT NULL,
	[PostCode] [varchar](10) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DateActiveFrom] [datetime] NOT NULL,
	[DateActiveTo] [datetime] NOT NULL
) ON [PRIMARY]
GO

PRINT '...Created [Datawarehouse].[DimGeneralPracticeAddress]...'


GO

CREATE TABLE [Datawarehouse].[DimProductType](
	[DimProductTypeSkey] [int] IDENTITY(1,1) NOT NULL,
	[ProductType] [varchar](150) NULL,
	[ChemicalSubstanceId] [varchar](9) NULL,
	[DateActiveFrom] [datetime] NULL
) ON [PRIMARY]
GO

PRINT '...Created [Datawarehouse].[DimProductType]...'

GO

CREATE TABLE [Datawarehouse].[DimProduct](
	[DimProductSkey] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [varchar](15) NULL,
	[BNFCode] [varchar](15) NULL,
	[ProductName] [varchar](40) NULL,
	[BNFName] [varchar](40) NULL,
	[DimProductTypeSkey] [int] NULL,
	[ProductType] [varchar](150) NULL,
	[ChemicalSubstanceId] [varchar](9) NULL,
	[DateActiveFrom] [datetime] NULL
) ON [PRIMARY]
GO

PRINT '...Created [Datawarehouse].[DimProduct]...'

GO

CREATE TABLE [Datawarehouse].[DimHealthAuthority]
(
	[DimHealthAuthroritySkey] INT IDENTITY(1,1),
	[HealthAuthorityId]	varchar(3),
	[HealthAuthorityName] varchar(150) NULL,
	[DateActiveFrom] DATETIME

)

GO

PRINT '...Created [Datawarehouse].[DimHealthAuthority]...'


GO

CREATE TABLE [Datawarehouse].[DimPrimaryCareTrust]
(
	[DimPrimaryCareTrustSkey]	INT IDENTITY(1,1),
	[PrimaryTrustId]			varchar(3),
	[PrimaryCareTrustName]		varchar(150) NULL,
	[CareType]					varchar(20),
	[DateActiveFrom]			DATETIME,
	[DimHealthAuthroritySkey]	INT

)
GO

PRINT '...Created [Datawarehouse].[DimPrimaryCareTrust]...'

GO

DECLARE @StartDate DATE = '20000101', @NumberOfYears INT = 30;

-- prevent set or regional settings from interfering with 
-- interpretation of dates / literals

SET DATEFIRST 7;
SET DATEFORMAT mdy;
SET LANGUAGE US_ENGLISH;

DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);

-- this is just a holding table for intermediate calculations:

CREATE TABLE [Datawarehouse].[DimDate]
(
  [date]       DATE PRIMARY KEY, 
  [day]        AS DATEPART(DAY,      [date]),
  [month]      AS DATEPART(MONTH,    [date]),
  FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),
  [MonthName]  AS DATENAME(MONTH,    [date]),
  [week]       AS DATEPART(WEEK,     [date]),
  [ISOweek]    AS DATEPART(ISO_WEEK, [date]),
  [DayOfWeek]  AS DATEPART(WEEKDAY,  [date]),
  [quarter]    AS DATEPART(QUARTER,  [date]),
  [year]       AS DATEPART(YEAR,     [date]),
  FirstOfYear  AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [date]), 0)),
  Style112     AS CONVERT(CHAR(8),   [date], 112),
  Style101     AS CONVERT(CHAR(10),  [date], 101)
);

-- use the catalog views to generate as many rows as we need

INSERT [NHS].[Datawarehouse].[DimDate]([date]) 
SELECT d
FROM
(
  SELECT d = DATEADD(DAY, rn - 1, @StartDate)
  FROM 
  (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate)) 
      rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    -- on my system this would support > 5 million days
    ORDER BY s1.[object_id]
  ) AS x
) AS y;

PRINT '...Created [Datawarehouse].[DimDate]...'

PRINT '...Created all [Datawarehouse] Tables..'

PRINT '...Creating Functions'

GO

CREATE FUNCTION [Transform].[udfTemplateDimGeneralPracticeAddress]
(	
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		[GPId]									=	CAST('-1' AS varchar(6))
		,[GeneralPracticePrimarySurgeryName]	=	CAST('UNKNOWN' AS VARCHAR(50))
		,[GeneralPracticeSecondarySurgeryName]	=	CAST('UNKNOWN' AS VARCHAR(50))
		,[AddressLine1]							=	CAST('UNKNOWN' AS VARCHAR(50)) 
		,[AddressLine2]							=	CAST('UNKNOWN' AS VARCHAR(50))		 
		,[AddressLine3]							=	CAST('UNKNOWN' AS VARCHAR(50))
		,[PostCode]								=	CAST('XXXX9999' AS VARCHAR(10))			

);


GO

PRINT '...Created [Transform].[udfTemplateDimGeneralPracticeAddress]..';

PRINT
'
 


****************...Finished creation of all NHS database objects......*******************



'

GO
USE master;
GO

GO
	IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DW_Framework')
	DROP DATABASE [DW_Framework];
GO

PRINT '...Dropped database [DW_Framework] on instance '+ @@servername+'.' 

GO
	IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DW_Framework')
	CREATE DATABASE [DW_Framework];
GO

PRINT '...Created database [DW_Framework] on instance '+ @@servername+'.' 

PRINT 
'



****************...Starting creation of all DW_Framework database objects......*******************


'

GO
	USE [DW_Framework];
GO


PRINT '...Creating schemas'
GO
	CREATE SCHEMA [NHS]
GO
PRINT '...Created schema [NHS]'
GO
PRINT '...Finished schemas'


PRINT '...Creating DW_Framework table objects'

GO

CREATE TABLE [NHS].[FileLoadLog](
	[FileLogId] [int] IDENTITY(1,1) NOT NULL,
	[PackageName] [nvarchar](100) NULL,
	[FileName] [nvarchar](100) NULL,
	[Period] [int] NULL,
	[SourcePath] [nvarchar](100) NULL,
	[DestinationPath] [nvarchar](100) NULL,
	[FileType] [nvarchar](1) NULL,
	[RecordCount] [int] NULL,
	[IsActive] [bit] NULL,
	[FileLoadedDate] [datetime] NULL,
	[IsZipped] [bit] NOT NULL
) ON [PRIMARY]
GO


ALTER TABLE [NHS].[FileLoadLog] ADD  DEFAULT ((0)) FOR [IsZipped]
GO

PRINT '...Created [NHS].[FileLoadLog]'


GO

CREATE TABLE [NHS].[SSISExecutionLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[PackageName] [nvarchar](100) NULL,
	[ActivityLogDateTimeCreated] [datetime] NULL,
	[Comment] [nvarchar](255) NULL,
	[Status] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[UserName] [nvarchar](100) NULL
) ON [PRIMARY]
GO

PRINT '...Created [NHS].[SSISExecutionLog]'

GO
CREATE TABLE [NHS].[ProcessingFileTypes](
	[FileTypeName] [nvarchar](50) NULL,
	[FileTypeFormat] [nvarchar](50) NULL,
	[FileType] [nvarchar](1) NULL
) ON [PRIMARY]
GO

PRINT '...Created [NHS].[ProcessingFileTypes]'

PRINT '...Creating Stored Procedures'

GO

CREATE PROCEDURE [dbo].[UspExecutionEnd]
@PackageName	NVARCHAR(150),
@UserName		NVARCHAR(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Comment NVARCHAR(255) = 'Execution of ' +@PackageName+' finished sucessfully.'

    INSERT INTO [DW_Framework].[NHS].[SSISExecutionLog]
	(
         PackageName
        ,UserName
		,Comment
        ,ActivityLogDateTimeCreated
		,Status
    ) 
	VALUES 
	(
		 @PackageName
		,@UserName
		,@Comment
		,CONVERT(DATETIME,GETDATE())
		,'Succeeded'
    )
END

GO

PRINT '...Created [dbo].[UspExecutionEnd]'

GO

CREATE PROCEDURE [dbo].[UspExecutionLogActivity]
@PackageName					NVARCHAR(150),
@UserName						NVARCHAR(150),
@ActivityLogDateTimeCreated		DATETIME,
@Type							NVARCHAR(25),
@Status							NVARCHAR(25),
@Comment						NVARCHAR(255)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [DW_Framework].[NHS].[SSISExecutionLog]
	(
         PackageName
        ,UserName
        ,ActivityLogDateTimeCreated	
		,Type
		,Status
		,Comment
    ) 
	VALUES 
	(
		 @PackageName
		,@UserName
		,@ActivityLogDateTimeCreated
		,@Type
		,@Status
		,@Comment
    )
END

GO

PRINT '...Created [dbo].[UspExecutionLogActivity]'

GO

CREATE PROCEDURE [dbo].[UspExecutionStart]
@PackageName	NVARCHAR(150),
@UserName		NVARCHAR(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Comment NVARCHAR(255) = 'Started Intial load of ' +@PackageName+'.'

    INSERT INTO [DW_Framework].[NHS].[SSISExecutionLog]
	(
         PackageName
        ,UserName
		,Comment
        ,ActivityLogDateTimeCreated
		,Status
    ) 
	VALUES 
	(
		 @PackageName
		,@UserName
		,@Comment
		,CONVERT(DATETIME,GETDATE())
		,'Started'
    )
END

GO

PRINT '...Created [dbo].[UspExecutionStart]'

GO

CREATE PROCEDURE [dbo].[UspGetFileLoadLog]
(
	@SourceFileDirectory		VARCHAR(100),
	@DestinationFileDirectory	VARCHAR(100),
	@PackageName				VARCHAR(100)					
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FileCount INT, 
	@LoadValue INT = 0, 
	@Comment NVARCHAR(255),
	@UserName NVARCHAR(50) = (SELECT SUSER_NAME()),
	@ActivityLogDateTimeCreated DATETIME = CONVERT(DATETIME,GETDATE())

	IF OBJECT_ID('tempdb..#SourceFiles') IS NOT NULL
		DROP TABLE #SourceFiles
	
	CREATE TABLE #SourceFiles
	(
	SourceFiles NVARCHAR(100),
	Depth	int,
	[File]	int
	)

	INSERT INTO #SourceFiles (SourceFiles,Depth,[File])
	EXEC master..xp_dirtree @SourceFileDirectory, 10, 1
		
	--Check that SourceFiles about to be staged don't persist in FileLoadLog
	SET @FileCount	=   (SELECT COUNT(DISTINCT FL.Filename)
						 FROM [NHS].[FileLoadLog] FL
						 INNER JOIN #SourceFiles S ON FL.Filename = S.SourceFiles)

	DECLARE @Periods varchar(100) = STUFF((SELECT ',' + RIGHT(LEFT(SourceFiles,7),6) 
									 FROM 
										(SELECT DISTINCT SourceFiles = RIGHT(LEFT(SourceFiles,7),6)
										FROM #SourceFiles
										)D
									 ORDER BY RIGHT(LEFT(SourceFiles,7),6) 
									 FOR XML PATH('')), 
									1, 1, '')

	IF (@FileCount > @LoadValue)
	BEGIN
		--ExecuteActivityProc -- Duplicate source files
		SET @Comment =  'Load Failed! Files already loaded for period(s) '+@Periods+' remove ' +cast(@FileCount as nvarchar(4))+ ' files in the source file directory ' +@SourceFileDirectory+ ' to continue.'
		EXEC [dbo].[UspExecutionLogActivity] 
		 @PackageName					= @PackageName
		,@UserName						= @UserName
		,@ActivityLogDateTimeCreated	= @ActivityLogDateTimeCreated
		,@Type							= NULL
		,@Status						= 'FileLoad'
		,@Comment						= @Comment
	
	END 

	IF (@FileCount = @LoadValue)	
	--Check if there are any source files to load in sourcefile table.
	BEGIN
		SET @FileCount = (SELECT COUNT(DISTINCT SourceFiles) FROM #SourceFiles)
			IF (@FileCount > @LoadValue)
			BEGIN
					--Execute UspExecutionLogActivity -- Source files to stage
					--Insert Files into FileLoadLog
					INSERT INTO [NHS].[FileLoadLog](
						 FileName
						,PackageName
						,Period
						,SourcePath 
						,DestinationPath
						,FileType 
						,IsActive  
						)
					SELECT 
						 FileName			=		s.SourceFiles
						,PackageName		=		@PackageName
						,Period				=		CAST(RIGHT(LEFT(s.SourceFiles,7),6) AS INT) 
						,SourcePath			=		@SourceFileDirectory
						,DestinationPath	=		@DestinationFileDirectory
						,FileType			=		pft.[FileType]	
						,IsActive			=		1
					FROM  #SourceFiles S
					INNER JOIN [NHS].[ProcessingFileTypes] PFT ON REPLACE(s.SourceFiles,LEFT(s.SourceFiles,7),'') = PFT.FileTypeFormat
			
					SET @Comment =  'There are '+cast(@FileCount as nvarchar(4))+' source files in source file directory ' +@SourceFileDirectory+ ' ready to load for period(s) '+@Periods+'.'
					EXEC [dbo].[UspExecutionLogActivity] 
					 @PackageName					= @PackageName
					,@UserName						= @UserName
					,@ActivityLogDateTimeCreated	= @ActivityLogDateTimeCreated
					,@Type							= NULL
					,@Status						= 'FileLoad'
					,@Comment						= @Comment;
					
			END
	END

	IF (@FileCount = @LoadValue)	
	--Check if there are any source files to load in sourcefile table.
	BEGIN
		SET @FileCount = (SELECT COUNT(DISTINCT SourceFiles) FROM #SourceFiles)
			IF (@FileCount = @LoadValue)
			BEGIN
					--Execute UspExecutionLogActivity -- No new source files to stage
					SET @Comment =  'No new source files to load.'	
					EXEC [dbo].[UspExecutionLogActivity] 
					 @PackageName					= @PackageName
					,@UserName						= @UserName
					,@ActivityLogDateTimeCreated	= @ActivityLogDateTimeCreated
					,@Type							= NULL
					,@Status						= 'FileLoad'
					,@Comment						= @Comment;
			END
	END
end

GO

PRINT '...Created [dbo].[UspGetFileLoadLog]'

GO

CREATE PROCEDURE [dbo].[UspUpdateFileLoadLogDev]
(
	@SourceFileDirectory		VARCHAR(100),
	@DestinationFileDirectory	VARCHAR(100),
	@PackageName				VARCHAR(100),
	@LogType					VARCHAR(10),
	@FileLogId					INT
						
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @WhichLogType   VARCHAR(10)		= @LogType
	DECLARE @FileLoadedDate DATETIME		= CONVERT(DATETIME,GETDATE())
	DECLARE @Comment		NVARCHAR(250)
	DECLARE @UserName		NVARCHAR(50)	= (SELECT SUSER_NAME())
	DECLARE @FileType		NVARCHAR(1)		= (SELECT [FileType] FROM [NHS].[FileLoadLog] WHERE [FileLogId] = @FileLogId)

	IF (@WhichLogType = 'Zip')
	BEGIN
		SET @Comment = 'Successfully Zipped File '+cast(@FileLogId as varchar(10))+ '.'
		

		UPDATE [NHS].[FileLoadLog]
		SET IsZipped = 1
		WHERE 
			IsZipped = 0
		AND 
			@FileLogId = FileLogId
	
		EXEC [dbo].[UspExecutionLogActivity] 
		 @PackageName					= @PackageName
		,@UserName						= @UserName
		,@ActivityLogDateTimeCreated	= @FileLoadedDate
		,@Type							= NULL
		,@Status						= @WhichLogType
		,@Comment						= @Comment;

	END
	IF (@WhichLogType = 'FileLoad')
	BEGIN
		SET @Comment = 'Successfully Processed File '+cast(@FileLogId as varchar(10))+ '.'

		UPDATE [NHS].[FileLoadLog]
		SET IsActive = 0, [DestinationPath] = @DestinationFileDirectory, [FileLoadedDate] = @FileLoadedDate
		WHERE
			IsActive = 1 
		AND 
			@FileLogId = FileLogId

		EXEC [dbo].[UspExecutionLogActivity] 
		 @PackageName					= @PackageName
		,@UserName						= @UserName
		,@ActivityLogDateTimeCreated	= @FileLoadedDate
		,@Type							= @FileType
		,@Status						= @WhichLogType
		,@Comment						= @Comment;

	END
END

GO

PRINT '...Created [dbo].[UspUpdateFileLoadLogDev]'

GO

CREATE PROCEDURE [dbo].[UspUpdateFileLoadLog]
(
	@SourceFileDirectory		VARCHAR(100),
	@DestinationFileDirectory	VARCHAR(100),
	@PackageName				VARCHAR(100)					
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FileLoadedDate DATETIME = CONVERT(DATETIME,GETDATE())
	DECLARE @Comment		NVARCHAR(250) = 'FileLoadLog table updated and files processed, FileLoadedDate ('+CONVERT(VARCHAR(25),@FileLoadedDate,120)+').'
	,@UserName NVARCHAR(50) = (SELECT SUSER_NAME())

	UPDATE [NHS].[FileLoadLog]
	SET IsActive = 0, [DestinationPath] = @DestinationFileDirectory, [FileLoadedDate] = @FileLoadedDate
	WHERE IsActive = 1
	
	EXEC [dbo].[UspExecutionLogActivity] 
	 @PackageName					= @PackageName
	,@UserName						= @UserName
	,@ActivityLogDateTimeCreated	= @FileLoadedDate
	,@Type							= NULL
	,@Status						= 'FileLoad'
	,@Comment						= @Comment;

END

GO

PRINT '...Created [dbo].[UspUpdateFileLoadLog]'

PRINT '...Inserting Processing File Types records'

GO

INSERT INTO [DW_Framework].[NHS].[ProcessingFileTypes] (FileTypeName,FileTypeFormat,FileType)
VALUES
	('Address',		'ADDR+BNFT.CSV',	'A'),
	('Chemical',	'CHEM+SUBS.CSV',	'C'),
	('Prescription','PDPI+BNFT.CSV',	'P')

GO

PRINT '...Successfully Inserted Records'


PRINT 
'


****************...Finished creation of all DW_Framework database objects......*******************



';

GO
	USE [SSISDB];
GO

DECLARE  @Folder_Name				NVARCHAR(25) = 'NHS'
		,@FolderID					BIGINT 

/* Check for Folder and Create */


SET @FolderID = (SELECT MAX(folder_id)+1 FROM [SSISDB].[internal].[folders])
IF NOT EXISTS (SELECT [Name] FROM [SSISDB].[internal].[folders] WHERE [Name] = @Folder_Name)
		EXEC [SSISDB].[catalog].[create_folder] @folder_name = @Folder_Name ,@folder_id = @FolderID OUTPUT
		PRINT '..Created NHS folder in SSISDB'

