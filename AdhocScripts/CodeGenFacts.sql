set nocount on

-- get tables
if object_id('tempdb..#tablelist') is not null
begin
	drop table #tablelist
end

select	name
into	#tablelist
from	sys.objects
where	type = 'u'
and		name like '%'
and		name not like '%switch%'

-- DoCodeGenerationFlag
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''DoCodeGenerationFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- WarehouseTableType
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''WarehouseTableType'', @value = N''Fact'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO
EXEC sys.sp_addextendedproperty @level1name = N'''+name+'SwitchIn'', @name = N''WarehouseTableType'', @value = N''PartitionSwitch'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO
EXEC sys.sp_addextendedproperty @level1name = N'''+name+'SwitchOut'', @name = N''WarehouseTableType'', @value = N''PartitionSwitch'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- GenerateToTransformFlag
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GenerateToTransformFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- GenerateCopyToMirrorFlag
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GenerateCopyToMirrorFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- GeneratePublishFlag
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GeneratePublishFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- GenerateToMirrorFlag
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GenerateToMirrorFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- GeneratePresentationViewFlag
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GeneratePresentationViewFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- DoETL
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''DoETL'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- GenerateUpdateStatsFlag
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GenerateUpdateStatsFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- IsLineage
select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N''CreatedByLogID'', @name = N''IsLineage'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO
EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N''LastModifiedByLogID'', @name = N''IsLineage'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO'
from	#tablelist

