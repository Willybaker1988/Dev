SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO
:on error exit
:setvar BasePath F:\Database\DWH\Data\
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END

USE master;
GO
/* ATTN: will kick everyone out and rollback */
/* Make sure that no snapshots other than the BASELINE snapshots exist */

USE DataWarehouse;
GO
/* ********************************************************************** */

USE master;
GO
/* ATTN: will kick everyone out and rollback */
/* Make sure that no snapshots other than the BASELINE snapshots exist */

BEGIN TRY 

	RAISERROR('Placing DIFramework in Single User...', 10, 1) WITH NOWAIT;

	ALTER DATABASE DIFramework SET SINGLE_USER WITH ROLLBACK IMMEDIATE

	RAISERROR('Reverting DIFramework to Pre-Release Snapshot...', 10, 1) WITH NOWAIT;

	RESTORE DATABASE DIFramework FROM DATABASE_SNAPSHOT = 'DIFramework_Snapshot_Baseline';

	RAISERROR('Setting DIFramework to Multi-User...', 10, 1) WITH NOWAIT;

	ALTER DATABASE DIFramework SET MULTI_USER

	RAISERROR('Database DIFramework reverted to Baseline Snapshot.', 10, 1) WITH NOWAIT;	
	
	IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'DIFramework_Snapshot_Baseline')
	DROP DATABASE DIFramework_Snapshot_Baseline

	RAISERROR('Snapshot DIFramework_Snapshot_Baseline dropped...', 10, 1) WITH NOWAIT;	
END TRY
BEGIN CATCH
	SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage;
    
	ALTER DATABASE DIFramework SET MULTI_USER	
END CATCH	
GO
/* Put it back on the target DB or it will interfere with SSDT deployment */
USE DIFramework;
GO
/* ********************************************************************** */

-- Recreate snapshots
USE master
DECLARE @BasePath VARCHAR(4000);
DECLARE @FileName1 VARCHAR(4000);
DECLARE @FileName2 VARCHAR(4000);
DECLARE @FileName3 VARCHAR(4000);

SET @BasePath = N'$(BasePath)';

RAISERROR('Base Path is: %s', 10, 0, @BasePath)

--/* ** First Database ****************************************************************************** */
SET @FileName1 = @BasePath + 'DIFramework_Baseline.mdf.snapshot';
SET @FileName2 = @BasePath + 'DIFramework_USER_User1_Baseline.ndf.snapshot';

RAISERROR('Creating Snapshot for DIFramework...', 10, 1) WITH NOWAIT;
    
EXEC ('CREATE DATABASE [DIFramework_Snapshot_Baseline] ON 
( NAME = N''Primary'', FILENAME = ''' + @FileName1 + ''' ), 
( NAME = N''User1'', FILENAME = ''' + @FileName2 + ''' ) AS SNAPSHOT OF [DIFramework]');

/* *************************************************************************************************** */

/* *************************************************************************************************** */


--/* ************************************************************************************************* */

RAISERROR('All Baseline snapshots created...', 10, 1) WITH NOWAIT;



