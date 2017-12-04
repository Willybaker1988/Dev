declare @DBRoleName varchar(40) = 'AdobeEDWETLUser'
--declare @SQL varchar(1000)
--declare @Counter int = 1

SELECT 
	ROW_NUMBER() OVER (ORDER BY dbprm.permission_name, OBJECT_SCHEMA_NAME(major_id)) AS ID,
	'GRANT ' + dbprm.permission_name + ' ON ' + OBJECT_SCHEMA_NAME(major_id) + '.' + OBJECT_NAME(major_id) + ' TO ' + dbrol.name + char(13) COLLATE Latin1_General_CI_AS AS [Permissions]
--INTO 
--	Scratch.dbo.AdobeEDWETLUserPermissions
from 
	sys.database_permissions dbprm

join 
	sys.database_principals dbrol on dbprm.grantee_principal_id = dbrol.principal_id
where 
	dbrol.name = @DBRoleName
and 
	class <> 0


