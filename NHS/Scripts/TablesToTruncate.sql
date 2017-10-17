use NHS

--For a clean test of the NHS solution  all the tables below need truncating

TRUNCATE TABLE [Transform].[DimGeneralPracticeAddress]
print '...Truncated table [Transform].[DimGeneralPracticeAddress]'
TRUNCATE TABLE [Mirror].[DimGeneralPracticeAddress]
print '...Truncated table [Mirror].[DimGeneralPracticeAddress]'
TRUNCATE TABLE [Mirror].[DimProduct]
print '...Truncated table [Mirror].[DimProduct]'
TRUNCATE TABLE [Datawarehouse].[DimGeneralPracticeAddress]
print '...Truncated table [Datawarehouse].[DimGeneralPracticeAddress]'
TRUNCATE TABLE [Datawarehouse].[DimProductType]
print '...Truncated table [Datawarehouse].[DimProductType]'
TRUNCATE TABLE [Datawarehouse].[DimProduct]
print '...Truncated table [Datawarehouse].[DimProduct]'
TRUNCATE TABLE [Stage].[ChemicalSubstance]
print '...Truncated table [Stage].[ChemicalSubstance]'
TRUNCATE TABLE [Stage].[GPAddress]
print '...Truncated table [Stage].[GPAddress]'
TRUNCATE TABLE [Stage].[Prescription]
print '...Truncated table [Stage].[Prescription]'
TRUNCATE TABLE [DW_Framework].[NHS].[FileLoadLog]
print '...Truncated table [DW_Framework].[NHS].[FileLoadLog]'
TRUNCATE TABLE [DW_Framework].[NHS].[SSISExecutionLog]
print '...Truncated table [DW_Framework].[NHS].[SSISExecutionLog]'