
--EXEC [SSISDB].[catalog].[create_environment] @Environment_Name = 'MarketPlaceConfig', @Environment_Description = N'', @Folder_Name = 'MarketPlace'


DECLARE @FOLDER_NAME NVARCHAR(500) = 'MarketPlace'
DECLARE @ENVIRONMENT_NAME NVARCHAR(500) = 'MarketPlaceConfig'
DECLARE @PROJECT_NAME  NVARCHAR(500) = 'MarketPlace'
		,@var SQL_VARIANT

SET @var = CONVERT(SQL_VARIANT, N'\\ASD-SQL-INT-72.ASOS.LOCAL\CDWSourceFiles04\MKT\Feeds\Archive');
EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'ArchiveFolder', @sensitive=False, @description=N'ArchiveFolder', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'


--SET @var = CONVERT(SQL_VARIANT, N'\\ASD-SQL-INT-72.ASOS.LOCAL\CDWSourceFiles04\MKT\Feeds\Rejected');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'RejectedFolder', @sensitive=False, @description=N'RejectedFolder', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'

--SET @var = CONVERT(SQL_VARIANT, N'\\ASD-SQL-INT-72.ASOS.LOCAL\CDWSourceFiles04\MKT\Feeds\Received');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'ReceivedFolder', @sensitive=False, @description=N'ReceivedFolder', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'


--SET @var = CONVERT(SQL_VARIANT, N'Data Source=ASGLH-WL-10427\WILLLOCAL;Initial Catalog=Development;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'Local', @sensitive=False, @description=N'', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'


--SET @var = CONVERT(SQL_VARIANT, N'Data Source=ASD-SQL-INT-72.ASOS.LOCAL\TEST04DWH;Initial Catalog=DataWarehouse;Integrated Security=SSPI;Auto Translate=False;');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'Test04_Datawarehouse', @sensitive=False, @description=N'', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'

--SET @var = CONVERT(SQL_VARIANT, N'Data Source=ASD-SQL-INT-72.ASOS.LOCAL\TEST04DWH;Initial Catalog=ASOS_Logging;Integrated Security=SSPI;Auto Translate=False;');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'ASOS_Logging', @sensitive=False, @description=N'', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'

--SET @var = CONVERT(SQL_VARIANT, N'BI SQL Server Notifications - UAT');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'DBMailProfileName', @sensitive=False, @description=N'', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'

--SET @var = CONVERT(SQL_VARIANT, N'dayo.oyegbesan@asos.com');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'EmailCopyRecipients', @sensitive=False, @description=N'', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'

--SET @var = CONVERT(SQL_VARIANT, N'william.baker@asos.com');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'EmailRecipients', @sensitive=False, @description=N'', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'

--SET @var = CONVERT(SQL_VARIANT, N'\\ASD-SQL-INT-72.ASOS.LOCAL\CDWSourceFiles04\MKT');
--EXEC [SSISDB].[catalog].[create_environment_variable] @variable_name=N'RootFolder', @sensitive=False, @description=N'', @environment_name=@ENVIRONMENT_NAME, @folder_name=@FOLDER_NAME, @value=@var, @data_type=N'String'

--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ReceivedFolder', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'ReceivedFolder'
EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ArchiveFolder', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'ArchiveFolder'

--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'RejectedFolder', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'RejectedFolder'
--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'Test04_Datawarehouse', @object_name=N'Test 04 to Local', @folder_name=@FOLDER_NAME, @project_name=N'Test04 to Local', @value_type=R, @parameter_value=N'Test04_Datawarehouse'
--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'ASOS_Logging', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'ASOS_Logging'
--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'DBMailProfileName', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'DBMailProfileName'
--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'EmailCopyRecipients', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'EmailCopyRecipients'
--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'EmailRecipients', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'EmailRecipients'
--EXEC [SSISDB].[catalog].[set_object_parameter_value] @object_type=20, @parameter_name=N'RootFolder', @object_name=N'MarketPlace', @folder_name=@FOLDER_NAME, @project_name=N'MarketPlace', @value_type=R, @parameter_value=N'RootFolder'
