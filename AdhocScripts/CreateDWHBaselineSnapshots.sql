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

-- Create snapshots
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
--SET @FileName1 = @BasePath + 'DataWarehouse_Baseline.mdf.snapshot'
--SET @FileName2 = @BasePath + 'DataWarehouse_ARCHIVE_Archive1_Baseline.ndf.snapshot'
--SET @FileName3 = @BasePath + 'DataWarehouse_USER_User1_Baseline.ndf.snapshot'

--RAISERROR('Creating Snapshot for DataWarehouse...', 10, 1) WITH NOWAIT;

--EXEC ('CREATE DATABASE [DataWarehouse_Snapshot_Baseline] ON 
--( NAME = N''Primary'', FILENAME = N''' + @FileName1 + ''' ), 
--( NAME = N''Archive1'', FILENAME = N''' + @FileName2 + ''' ), 
--( NAME = N''User1'', FILENAME = N''' + @FileName3 + ''' ) AS SNAPSHOT OF [DataWarehouse]');

--/* *************************************************************************************************** */
--SET @FileName1 = @BasePath + 'Transform_Baseline.mdf.snapshot'
--SET @FileName2 = @BasePath + 'Transform_USER_User1_Baseline.ndf.snapshot'

--RAISERROR('Creating Snapshot for Transform...', 10, 1) WITH NOWAIT;

--EXEC ('CREATE DATABASE [Transform_Snapshot_Baseline] ON
--( NAME = N''Primary'', FILENAME = N''' + @FileName1 + ''' ),
--( NAME = N''User1'', FILENAME = N''' + @FileName2 + ''' )
--AS SNAPSHOT OF [Transform]');


----/* ************************************************************************************************* */

--RAISERROR('All Baseline snapshots created...', 10, 1) WITH NOWAIT;
