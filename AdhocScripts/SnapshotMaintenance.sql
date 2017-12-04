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

BEGIN TRY 

	RAISERROR('Placing DataWarehouse in Single User...', 10, 1) WITH NOWAIT;

	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE

	RAISERROR('Reverting DataWarehouse to Pre-Release Snapshot...', 10, 1) WITH NOWAIT;

	RESTORE DATABASE DataWarehouse FROM DATABASE_SNAPSHOT = 'DataWarehouse_Snapshot_Baseline';

	RAISERROR('Setting DataWarehouse to Multi-User...', 10, 1) WITH NOWAIT;

	ALTER DATABASE DataWarehouse SET MULTI_USER

	RAISERROR('Database DataWarehouse reverted to Baseline Snapshot.', 10, 1) WITH NOWAIT;	

	IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'DataWarehouse_Snapshot_Baseline')
	DROP DATABASE DataWarehouse_Snapshot_Baseline

	RAISERROR('Snapshot DataWarehouse_Snapshot_Baseline dropped...', 10, 1) WITH NOWAIT;	

END TRY
BEGIN CATCH
	SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage;
    
	ALTER DATABASE DataWarehouse SET MULTI_USER	
END CATCH	
GO
/* Put it back on the target DB or it will interfere with SSDT deployment */
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

USE master;
GO
/* ATTN: will kick everyone out and rollback */
/* Make sure that no snapshots other than the BASELINE snapshots exist */

BEGIN TRY 

	RAISERROR('Placing Transform in Single User...', 10, 1) WITH NOWAIT;

	ALTER DATABASE Transform SET SINGLE_USER WITH ROLLBACK IMMEDIATE

	RAISERROR('Reverting Transform to Pre-Release Snapshot...', 10, 1) WITH NOWAIT;

	RESTORE DATABASE Transform FROM DATABASE_SNAPSHOT = 'Transform_Snapshot_Baseline';

	RAISERROR('Setting Transform to Multi-User...', 10, 1) WITH NOWAIT;

	ALTER DATABASE Transform SET MULTI_USER

	RAISERROR('Database Transform reverted to Baseline Snapshot.', 10, 1) WITH NOWAIT;	

	IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'Transform_Snapshot_Baseline')
	DROP DATABASE Transform_Snapshot_Baseline

	RAISERROR('Snapshot Transform_Snapshot_Baseline dropped...', 10, 1) WITH NOWAIT;
END TRY
BEGIN CATCH
	SELECT
    ERROR_NUMBER() AS ErrorNumber
    ,ERROR_SEVERITY() AS ErrorSeverity
    ,ERROR_STATE() AS ErrorState
    ,ERROR_PROCEDURE() AS ErrorProcedure
    ,ERROR_LINE() AS ErrorLine
    ,ERROR_MESSAGE() AS ErrorMessage;
    
	ALTER DATABASE Transform SET MULTI_USER	
END CATCH	
GO
/* Put it back on the target DB or it will interfere with SSDT deployment */
USE Transform;
GO
/* ********************************************************************** */

RAISERROR('All Databases reverted to Baseline Snapshot.', 10, 1) WITH NOWAIT;	

GO

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
SET @FileName1 = @BasePath + 'DataWarehouse_Baseline.mdf.snapshot'
SET @FileName2 = @BasePath + 'DataWarehouse_ARCHIVE_Archive1_Baseline.ndf.snapshot'
SET @FileName3 = @BasePath + 'DataWarehouse_USER_User1_Baseline.ndf.snapshot'

RAISERROR('Creating Snapshot for DataWarehouse...', 10, 1) WITH NOWAIT;

EXEC ('CREATE DATABASE [DataWarehouse_Snapshot_Baseline] ON 
( NAME = N''Primary'', FILENAME = N''' + @FileName1 + ''' ), 
( NAME = N''Archive1'', FILENAME = N''' + @FileName2 + ''' ), 
( NAME = N''User1'', FILENAME = N''' + @FileName3 + ''' ) AS SNAPSHOT OF [DataWarehouse]');

/* *************************************************************************************************** */
SET @FileName1 = @BasePath + 'Transform_Baseline.mdf.snapshot'
SET @FileName2 = @BasePath + 'Transform_USER_User1_Baseline.ndf.snapshot'

RAISERROR('Creating Snapshot for Transform...', 10, 1) WITH NOWAIT;

EXEC ('CREATE DATABASE [Transform_Snapshot_Baseline] ON
( NAME = N''Primary'', FILENAME = N''' + @FileName1 + ''' ),
( NAME = N''User1'', FILENAME = N''' + @FileName2 + ''' )
AS SNAPSHOT OF [Transform]');


--/* ************************************************************************************************* */

RAISERROR('All Baseline snapshots created...', 10, 1) WITH NOWAIT;



