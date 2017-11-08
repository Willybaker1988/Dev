--List all databases on instance

SELECT 
		@@SERVERNAME AS Server ,
        name AS DBName ,
        recovery_model_Desc AS RecoveryModel ,
        Compatibility_level AS CompatiblityLevel ,
        create_date ,
        state_desc
FROM    sys.databases
ORDER BY Name; 

--List all objects on instance

SELECT * 
FROM sys.objects --WHERE type_desc 


--List all tables 

SELECT  @@Servername AS ServerName ,
	    TABLE_CATALOG ,
	    TABLE_SCHEMA ,
	    TABLE_NAME,
		TABLE_TYPE
FROM    INFORMATION_SCHEMA.TABLES
WHERE   TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME ;




IF OBJECT_ID('dbo.Scores', 'U') IS NOT NULL 
  --DROP TABLE dbo.Scores; 

SELECT CASE WHEN OBJECT_ID('[Stage].[GPAddress]', 'U') IS NOT NULL THEN 1 ELSE 0 END 

--DMV to pull out all sys processes.

SELECT
	DatabaseName = SD.name
	,sp.spid
	,SP.lastwaittype
	,t.*
FROM sys.sysprocesses SP
INNER JOIN sys.databases SD ON SP.DBID = SD.database_id
INNER JOIN sys.dm_exec_requests R ON R.session_id = SP.spid
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE
	SD.name = 'nhs'

--All executing requests and the sql being executed

SELECT *
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE session_id = 52 -- modify this value with your actual spid