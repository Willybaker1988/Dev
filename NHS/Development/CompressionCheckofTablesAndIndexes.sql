/*
The type column indicates the type of the index. 
1 is for clustered indexes. 2 means a non-clustered index. 0 (not shown in this example) is a heap.
 Recall that a table is either a heap or a clustered index.
 https://www.sqlshack.com/use-sql-server-data-compression-save-space/
*/
use NHS;
go

SELECT DISTINCT
    s.name,
    t.name,
    i.name,
    i.type,
    i.index_id,
    p.partition_number,
    p.rows
FROM sys.tables t
LEFT JOIN sys.indexes i
ON t.object_id = i.object_id
JOIN sys.schemas s
ON t.schema_id = s.schema_id
LEFT JOIN sys.partitions p
ON i.index_id = p.index_id
    AND t.object_id = p.object_id
WHERE t.type = 'U' 
  AND p.data_compression_desc = 'NONE'
ORDER BY p.rows desc 

SELECT name,
    s.used / 128.0                  AS SpaceUsedInMB,
    size / 128.0 - s.used / 128.0   AS AvailableSpaceInMB
FROM sys.database_files
CROSS APPLY 
    (SELECT CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)) 
s(used)
WHERE FILEPROPERTY(name, 'SpaceUsed') IS NOT NULL;



EXEC sp_estimate_data_compression_savings 
    @schema_name = 'Datawarehouse', 
    @object_name = 'FactPrescription', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'ROW'
 
EXEC sp_estimate_data_compression_savings 
    @schema_name = 'Datawarehouse', 
    @object_name = 'FactPrescription', 
    @index_id = NULL, 
    @partition_number = NULL, 
    @data_compression = 'PAGE'