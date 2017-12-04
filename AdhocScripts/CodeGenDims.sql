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
and		name like ''

-- DoCodeGenerationFlag

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''DoCodeGenerationFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- CreateInferredMembers

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''CreateInferredMembers'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- WarehouseTableType

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''WarehouseTableType'', @value = N''Dimension'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- DoETL

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''DoETL'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- IsSurrogateKey

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N'''+name+'SKey'', @name = N''IsSurrogateKey'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO'
from	#tablelist

-- IsNaturalKey

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N'''+replace(name,'dim','')+'Id'+''', @name = N''IsNaturalKey'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO'
from	#tablelist

-- GenerateValue

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N'''+name+'SKey'', @name = N''GenerateValue'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO'
from	#tablelist

-- GenerateUpdateStatsFlag

select	
'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GenerateUpdateStatsFlag'', @value = ''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist

-- IsLineage

select	'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N''IsCurrent'', @name = N''IsLineage'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO
EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N''SCDValidFrom'', @name = N''IsLineage'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO
EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N''SCDValidTo'', @name = N''IsLineage'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO
EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N''CreatedByLogID'', @name = N''IsLineage'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO
EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @level2name = N''LastModifiedByLogID'', @name = N''IsLineage'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'', @level2type = N''COLUMN'';
GO'
from	#tablelist

-- GeneratePresentationViewFlag

select	
'EXEC sys.sp_addextendedproperty @level1name = N'''+name+''', @name = N''GeneratePresentationViewFlag'', @value = N''1'', @level0type = N''SCHEMA'', @level0name = N''datawarehouse'', @level1type = N''TABLE'';
GO'
from	#tablelist