USE SSISDB

DECLARE @Environment_Name	NVARCHAR(50)	= 'CentralConfig'
DECLARE @Environment_ID		INT				=  (SELECT environment_id 
												FROM [internal].[environments]
												WHERE environment_name = @Environment_Name )


SELECT @Environment_ID,  @Environment_Name


SELECT 
	@@SERVERNAME as ServerInstance,
	E.environment_id,
	E.environment_name,
	EV.variable_id,
	EV.name as VariableName,
	EV.value as VariableValue,
	EV.type,
	EV.sensitive,
	EV.sensitive_value,
	EV.base_data_type
FROM 
	[internal].[environments] E
INNER JOIN
	internal.environment_variables EV ON EV.environment_id = E.environment_id
WHERE 
	E.environment_id = @Environment_ID

