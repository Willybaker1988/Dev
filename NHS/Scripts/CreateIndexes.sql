--Create Indexes

USE NHS;

IF NOT EXISTS (SELECT [Name] FROM sys.sysindexes WHERE [Name] = 'iX_Stage_Prescription_Period_Product_Practice')
	CREATE CLUSTERED INDEX iX_Stage_Prescription_Period_Product_Practice on [NHS].[Stage].[Prescription] ([PERIOD], [BNFCode], [PRACTICE])
	PRINT '...Created CLUSTERED INDEX iX_Stage_Prescription_Period_Product_Practice'

IF NOT EXISTS (SELECT [Name] FROM sys.sysindexes WHERE [Name] = 'iX_Stage_ChemicalSubstance_Period_ChemSubId')
	CREATE CLUSTERED INDEX iX_Stage_ChemicalSubstance_Period_ChemSubId on [NHS].[Stage].[ChemicalSubstance] ([PERIOD], CHEMSUBId)
	PRINT '...Created CLUSTERED INDEX iX_Stage_ChemicalSubstance_Period_ChemSubId'

IF NOT EXISTS (SELECT [Name] FROM sys.sysindexes WHERE [Name] = 'iX_Mirror_FactPrescription_PeriodId')
	CREATE CLUSTERED INDEX iX_Mirror_FactPrescription_PeriodId on [NHS].[Stage].[ChemicalSubstance] ([PERIOD], CHEMSUBId)
	PRINT '...Created CLUSTERED INDEX iX_Mirror_FactPrescription_PeriodId'

IF NOT EXISTS (SELECT [Name] FROM sys.sysindexes WHERE [Name] = 'iX_Mirror_DimGeneralPracticeAddress')
	CREATE CLUSTERED INDEX iX_Mirror_FactPrescription_PeriodId on [NHS].[Stage].[ChemicalSubstance] ([PERIOD], CHEMSUBId)
	PRINT '...Created CLUSTERED INDEX iX_Mirror_DimGeneralPracticeAddress'

IF NOT EXISTS (SELECT [Name] FROM sys.sysindexes WHERE [Name] = 'iX_Mirror_DimProduct_Period')
	CREATE CLUSTERED INDEX iX_Mirror_DimProduct_Period on [NHS].[Mirror].[DimProduct] (BNFCODE)
	PRINT '...Created CLUSTERED INDEX iX_Mirror_DimProduct_Period'




