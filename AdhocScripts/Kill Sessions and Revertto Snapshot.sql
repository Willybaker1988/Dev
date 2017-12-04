
--Kills all open sessions on the database (Kicks every user out)
ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE

--Restores the database back to the snapshot
RESTORE DATABASE Datawarehouse FROM DATABASE_SNAPSHOT = 'DataWarehouse_Snapshot_Baseline'
