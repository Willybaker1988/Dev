USE master
/* Pre-Requisites: ETL Project Deployed */

DECLARE  @DWH_Server				NVARCHAR(500) = CONVERT(VARCHAR(400), SERVERPROPERTY('MachineName')) + '\DWH'
		,@DWH_Server_Fileshare_Path NVARCHAR(500) = '\\' + CONVERT(VARCHAR(400), SERVERPROPERTY('MachineName')) + '.ASOS.LOCAL\'
	    ,@DBMailProfileName		    NVARCHAR(500) = 'BI SQL Server Notifications – UAT' --BI SQL Server Notifications � UAT 
		,@EmailRecipients			NVARCHAR(500) = 'william.baker@asos.com'
		,@EmailCopyRecipients		NVARCHAR(500) = 'william.baker@asos.com'
		,@Snapshot_Suffix			NVARCHAR(500) = 'SnapshotForDWH_DEV' + REPLACE(SUBString(CONVERT(VARCHAR(400), SERVERPROPERTY('MachineName')), 13, 3), '-', '')
		,@Environment_Id			NVARCHAR(10)
		,@Environment_Name			NVARCHAR(500) = 'MarketPlaceConfig'
		,@Reference_Id				NVARCHAR(10)
		,@Project_Name				NVARCHAR(500) =	'MarketPlace'
		,@Folder_Name				NVARCHAR(500) = 'MarketPlace'
		,@FileAgeLimitValue			NVARCHAR(500) =	'-7'
		,@FilePatternValue			NVARCHAR(500) = '.txt'
	

/* Create Environment */
SET	@Environment_Id	= (SELECT environment_id FROM ssisdb.internal.environments	WHERE Environment_Name = @Environment_Name)
IF @Environment_Id IS NULL
	EXEC [SSISDB].[catalog].[create_environment] @Environment_Name = @Environment_Name, @Environment_Description = N'', @Folder_Name = @Folder_Name

/* Create a reference to the Central Config Environment in the Project */
SET @Reference_Id	=	(SELECT reference_id from [SSISDB].[internal].[environment_references] WHERE Environment_Name = @Environment_Name AND Environment_Folder_name = @Folder_Name)
IF @Reference_Id IS NULL
	EXEC [SSISDB].[catalog].[create_environment_reference] @Environment_Name = @Environment_Name, @Environment_Folder_Name = @Folder_Name, @reference_id = @reference_id OUTPUT, @Project_Name = @Project_Name, @Folder_Name = @Folder_Name, @Reference_Type=A


DECLARE @EnvironmentVariables TABLE

	(
	 [EnvironmentVariableId]	INT				IDENTITY(1,1)
	,[Object_Name]				NVARCHAR(1000)
	,[Object_Type]				INT
	,[Parameter_Name]			NVARCHAR(1000)
	,[Variable_Name]			NVARCHAR(1000)
	,[Parameter_Value]			SQL_VARIANT
	,[IsSensitive]				BIT
	,[Base_Data_Type]			NVARCHAR(50)
	)

INSERT INTO
	@EnvironmentVariables
	(
	 [Object_Name]
	,[Object_Type]
	,[Parameter_Name]
	,[Variable_Name]
	,[Parameter_Value]
	,[IsSensitive]
	,[Base_Data_Type]
	)


VALUES
	/* * Source Folders */ 

	('MarketPlace',	20,	'ArchiveFolder',					'ArchiveFolder',						@DWH_Server_Fileshare_Path	+ cast(N'CDWSourceFiles04\MKT\Feeds\Archive' as nvarchar(50)), 0, 'String'),
	('MarketPlace',	20,	'FeedFolder',						'FeedFolder',							@DWH_Server_Fileshare_Path	+ cast(N'CDWSourceFiles04\MKT\Feeds'as nvarchar(50)), 0, 'String'),
	('MarketPlace',	20,	'ProcessFolder',					'ProcessFolder',						@DWH_Server_Fileshare_Path  + cast(N'CDWSourceFiles04\MKT\Feeds\Process'as nvarchar(50)), 0, 'String'),
	('MarketPlace',	20,	'ReceivedFolder',					'ReceivedFolder',						@DWH_Server_Fileshare_Path	+ cast(N'CDWSourceFiles04\MKT\Feeds\Received'as nvarchar(50)), 0, 'String'),
	('MarketPlace',	20,	'RejectedFolder',					'RejectedFolder',						@DWH_Server_Fileshare_Path	+ cast(N'CDWSourceFiles04\MKT\Feeds\Rejected'as nvarchar(50)), 0, 'String'),
	('MarketPlace',	20,	'SourceFolder',						'SourceFolder',							@DWH_Server_Fileshare_Path	+ cast(N'CDWSourceFiles04\MKT\'as nvarchar(50)), 0, 'String'),

	----/* * Target DBs */
	('MarketPlace',	20,	'ASOS_DW',						'ASOS_DW',							'Data Source=' + @DWH_Server	+ cast(N';Initial Catalog=ASOS_DW;Provider=SQLNCLI11;Integrated Security=SSPI;' as nvarchar(100)), 0, 'String'),
	('MarketPlace',	20,	'ASOS_Logging',					'ASOS_Logging',						'Data Source=' + @DWH_Server	+ cast(N';Initial Catalog=ASOS_Logging;Provider=SQLNCLI11;Integrated Security=SSPI;' as nvarchar(100)), 0, 'String'),
	
	----/* * Emails */

	('MarketPlace',	20,	'DBMailProfileName',				'DBMailProfileName',	@DBMailProfileName						, 0, 'String'),
	('MarketPlace',	20,	'EmailRecipients',					'EmailRecipients',		@EmailRecipients					    , 0, 'String'),
	('MarketPlace',	20,	'EmailCopyRecipients',				'EmailCopyRecipients',	@EmailCopyRecipients					, 0, 'String'),

	---/* * Clean Up Tasks */

	('MarketPlace',	20,	'FileAgeLimit',					'FileAgeLimit',		@FileAgeLimitValue					    , 0, 'Int32'),
	('MarketPlace',	20,	'FilePattern',					'FilePattern',		@FilePatternValue						, 0, 'String')
	
	
DECLARE	 @EnvironmentVariableIdMAX		INT				= (SELECT MAX(EnvironmentVariableId) FROM @EnvironmentVariables)
		,@EnvironmentVariableIdCurrent	INT				= 1
		,@Variable_Name					SYSNAME
		,@Parameter_Value				SQL_VARIANT
		,@Object_Name					NVARCHAR(500)
		,@Object_Type					NVARCHAR(500)
		,@Parameter_Name				NVARCHAR(500)
		,@IsSensitive					BIT
		,@Base_Data_Type				NVARCHAR(50)

WHILE	@EnvironmentVariableIdCurrent <= @EnvironmentVariableIdMAX

BEGIN
	SELECT
		 @Object_Name		=	[Object_Name]
		,@Object_Type		=	[Object_Type]
		,@Parameter_Name	=	[Parameter_Name]
		,@Variable_Name		=	[Variable_Name]
		,@Parameter_Value	=	[Parameter_Value]
		,@IsSensitive		=	[IsSensitive]
		,@Base_Data_Type	=	[Base_Data_Type]
	FROM 
		@EnvironmentVariables
	WHERE
		EnvironmentVariableId	=	@EnvironmentVariableIdCurrent

	SET @Parameter_Value = CASE WHEN @Base_Data_Type = 'Int32' THEN CAST(@Parameter_Value AS INT) ELSE @Parameter_Value END

	IF EXISTS(SELECT * from [SSISDB].[internal].[environment_variables] WHERE Environment_Id = @Environment_Id AND Name = @Variable_Name)
		
	EXEC	[SSISDB].[catalog].[delete_environment_variable]	@Folder_Name = @Folder_Name, @Environment_Name = @Environment_Name, @Variable_Name = @Variable_Name
	EXEC	[SSISDB].[catalog].[create_environment_variable]	@Variable_Name = @Variable_Name, @Sensitive=@IsSensitive, @Description=N'', @Environment_Name = @Environment_Name, @Folder_Name = @Folder_Name, @Value = @Parameter_Value, @data_type=@Base_Data_Type
	/* Now Bind SSIS Environment Variables to the Project Parameters */
	EXEC	[SSISDB].[catalog].[set_object_Parameter_Value]		@Object_Type = @Object_Type, @Parameter_Name = @Parameter_Name, @Parameter_Value = @Variable_Name, @Object_Name = @Object_Name, @Folder_Name = @Folder_Name, @Project_Name = @Project_Name, @Value_Type=R
	SET		@EnvironmentVariableIdCurrent = @EnvironmentVariableIdCurrent + 1
	

END

RAISERROR('All Complete',1,1) WITH NOWAIT;
