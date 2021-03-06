--1. Shrink NHS Database  

USE [NHS]
GO
DBCC SHRINKDATABASE(N'NHS' )
GO



--To truncate the NHS database log file set the recovery model to SIMPLE.
--Automatically truncates transaction logs each time the database reaches a transaction checkpoint

--IF EXISTS ( SELECT  
--SELECT name, recovery_model_desc  FROM sys.databases WHERE NAME = 'NHS'
ALTER DATABASE [NHS] SET RECOVERY SIMPLE

USE [NHS]
GO
DBCC SHRINKFILE (N'NHS_log')
GO

ALTER DATABASE [NHS] SET RECOVERY FULL
--SELECT name, recovery_model_desc  FROM sys.databases WHERE NAME = 'NHS'

/*


SELECT *  FROM sys.sysdatabases WHERE NAME = 'NHS'

SELECT name, recovery_model_desc  FROM sys.databases WHERE NAME = 'NHS'

use NHS;

SELECT * FROM sys.sysfiles WHERE NAME = 'NHS_LOG'

SELECT * FROM sys.database_files


USE nhs;  
GO  
SELECT compatibility_level  
FROM sys.databases WHERE name = 'nhs';  
GO  
*/