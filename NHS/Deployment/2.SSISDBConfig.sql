use ssisdb

/*
Pre-requisites to running the SSIDB script.

1. The account running the scipt has:
	Membership to the ssis_admin database role
	OR
	Membership to the sysadmin server role

2. The NHS_Prescription project needs deploying before running the 
*/

DECLARE  @Folder_Name				NVARCHAR(25) = 'NHS'
		,@Environment_Name			NVARCHAR(25) = 'CentralConfig'
		,@Project_Name				NVARCHAR(25) = 'NHS_Prescription'
		,@FolderID					BIGINT 
		,@Environment_Id			NVARCHAR(10)
		,@Reference_Id				NVARCHAR(10)
		,@Server_Instance			NVARCHAR(30) =  @@SERVERNAME



/* Check for Folder and Create */
SET @FolderID = (SELECT MAX(folder_id)+1 FROM [SSISDB].[internal].[folders])
IF NOT EXISTS (SELECT [Name] FROM [SSISDB].[internal].[folders] WHERE [Name] = @Folder_Name)
		EXEC [SSISDB].[catalog].[create_folder] @folder_name = @Folder_Name ,@folder_id = @FolderID OUTPUT

/* Create Environment */
SET	@Environment_Id	= (SELECT environment_id FROM ssisdb.internal.environments	WHERE Environment_Name = @Environment_Name)
IF @Environment_Id IS NULL
	EXEC [SSISDB].[catalog].[create_environment] @Environment_Name = @Environment_Name, @Environment_Description = N'', @Folder_Name = @Folder_Name
SET @Environment_Id = (SELECT environment_id FROM ssisdb.internal.environments	WHERE Environment_Name = @Environment_Name)

/* Create a reference to the Central Config Environment in the Project */
SET @Reference_Id	=	(SELECT reference_id from [SSISDB].[internal].[environment_references] WHERE Environment_Name = @Environment_Name AND Environment_Folder_name = @Folder_Name)
IF @Reference_Id IS NULL
	EXEC [SSISDB].[catalog].[create_environment_reference] @Environment_Name = @Environment_Name, @Environment_Folder_Name = @Folder_Name, @reference_id = @reference_id OUTPUT, @Project_Name = @Project_Name, @Folder_Name = @Folder_Name, @Reference_Type=A
SET @Reference_Id = (SELECT reference_id from [SSISDB].[internal].[environment_references] WHERE Environment_Name = @Environment_Name AND Environment_Folder_name = @Folder_Name)

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
	('NHS_Prescription',	20,	'NHS',	'NHS',	cast('Data Source='+@Server_Instance+';Initial Catalog=NHS;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;'as nvarchar(150)),		0, 'String'),
	('DW_Framework',	20,	'DW_Framework',	'DW_Framework',	cast('Data Source='+@Server_Instance+';Initial Catalog=DW_Framework;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;'as nvarchar(150)),		0, 'String'),
	('Received',	20,	'Received',	'Received',	'C:\Users\william.baker\Documents\NHS\Received',		0, 'String'),
	('Archived',	20,	'Archived',	'Archived',	'C:\Users\william.baker\Documents\NHS\Archived',		0, 'String')

DECLARE	 @EnvironmentVariableIdMAX		INT				= (SELECT MAX(EnvironmentVariableId) FROM @EnvironmentVariables)
		,@EnvironmentVariableIdCurrent	INT				= 1
		,@Variable_Name					SYSNAME
		,@Parameter_Value				SQL_VARIANT
		,@Object_Name					NVARCHAR(500)
		,@Object_Type					NVARCHAR(500)
		,@Parameter_Name				NVARCHAR(500)
		,@IsSensitive					BIT
		,@Base_Data_Type				NVARCHAR(50)


--SELECT * FROM  @EnvironmentVariables

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
	--SELECT Variable_Name = @Variable_Name , IsSensitive = @IsSensitive, Description= N'', Environment_Name = @Environment_Name,  Folder_Name = @Folder_Name,  Parameter_Value = @Parameter_Value,  Base_Data_Type = @Base_Data_Type

	IF EXISTS(SELECT * from [SSISDB].[internal].[environment_variables] WHERE Environment_Id = @Environment_Id AND Name = @Variable_Name)
		EXEC	[SSISDB].[catalog].[delete_environment_variable]	@Folder_Name = @Folder_Name, @Environment_Name = @Environment_Name, @Variable_Name = @Variable_Name
		EXEC	[SSISDB].[catalog].[create_environment_variable]	@Variable_Name = @Variable_Name, @Sensitive=@IsSensitive, @Description=N'', @Environment_Name = @Environment_Name, @Folder_Name = @Folder_Name, @Value = @Parameter_Value, @data_type=@Base_Data_Type
	/* Now Bind SSIS Environment Variables to the Project Parameters */
	EXEC	[SSISDB].[catalog].[set_object_Parameter_Value]		@Object_Type = @Object_Type, @Parameter_Name = @Parameter_Name, @Parameter_Value = @Variable_Name, @Object_Name = @Object_Name, @Folder_Name = @Folder_Name, @Project_Name = @Project_Name, @Value_Type=R
SET		@EnvironmentVariableIdCurrent = @EnvironmentVariableIdCurrent + 1
END
