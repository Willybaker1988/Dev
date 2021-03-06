use SSISDB

SELECT TOP (1000) [environment_id]
      ,[environment_name]
      ,[folder_id]
      ,[description]
      ,[created_by_sid]
      ,[created_by_name]
      ,[created_time]
  FROM [SSISDB].[internal].[environments] 
  
  SELECT * FROM [internal].[projects] WHERE [name] LIKE '%NHS%'

  SELECT * FROM [internal].[environment_references] WHERE environment_name = 'CentralConfig'
  
  SELECT * FROM [internal].[object_parameters] 
  WHERE project_id IN
					(SELECT  project_id FROM [internal].[environment_references] WHERE environment_name = 'CentralConfig')

 --A mapping table of SSIS data types to SQL data types - use this as a proxy when converting project parameters (@EnvironmentVariables)
  SELECT *  FROM [internal].[data_type_mapping] order by mapping_id asc
  --SELECT [ssis_data_type] FROM [internal].[data_type_mapping]
					
					
  SELECT * FROM [internal].[execution_parameter_values]
  SELECT * FROM [internal].[object_parameters]

