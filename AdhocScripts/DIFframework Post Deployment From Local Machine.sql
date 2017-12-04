/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

PRINT 'Deploying to ' + DB_NAME(DB_ID()) + ' on ' + @@SERVERNAME;
GO
--:r C:\Users\william.baker\Desktop\C\Populate_ExtractTables.sql
--GO
/* Add References to your Pre-Deployment scripts here. No T-SQL in this file, please. */
--:r C:\Users\william.baker\Desktop\C\Populate_SourceSystem.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_SourceSystemTables.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_SourceSystemTableDependency.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_DataWarehouseTable.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_ConfigurationOption.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_DataWarehouseTableSourceSystemTable.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_PostPublishTaskTable.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_SourceSystemTableDeltaLoadConfigurationOption.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_DataWarehouseTableProcessingGroup.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_ExtractProcessingGroup.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_SourceSystemTableUniqueConstraint.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_DataWarehouseTableUniqueConstraint.sql
--GO
--:r C:\Users\william.baker\Desktop\C\DeprecatingIWTAutomatedAdviceTables.sql
--GO
--:r C:\Users\william.baker\Desktop\C\Populate_ExtractMasterConfig.sql
--GO
--:r C:\Users\william.baker\Desktop\C\ETLPatternAmendment_DimProductStyleAttribute.sql
GO
:r C:\Users\william.baker\Desktop\C\"Create SSIS Environment Variables and Bindings for ETL".sql
GO
:r C:\Users\william.baker\Desktop\C\"Create SSIS Environment Variables and Bindings for Extracts".sql
GO
:r C:\Users\william.baker\Desktop\C\"Create SSIS Environment Variables and Bindings for FileTransfer".sql
GO
:r C:\Users\william.baker\Desktop\C\RemoveFromSystemTablesIWTtablesNoLongerInUse.sql
GO