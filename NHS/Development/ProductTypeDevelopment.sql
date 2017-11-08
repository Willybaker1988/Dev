--Identify new records ProductTypes available in the prescription data set which we do not currently have.

--test record 
--INSERT INTO [NHS].[STAGE].[ChemicalSubstance]
--SELECT 99999, 'TESTDRUG', 999999, 99


INSERT INTO [NHS].[Datawarehouse].[DimProductType]
(
	 [ChemicalSubstanceId]
	,[ProductType]
	,[DateActiveFrom]

)

SELECT DISTINCT 
	 [ChemicalSubstanceId]	=	COALESCE(s.CHEMSUBId, p.[ChemicalSubstanceId])
	,[ProductType]			=	COALESCE(s.CHEMSUBNAME,  P.ProductType)
	,[DateActiveFrom]		=	GETDATE()
FROM [NHS].[Stage].[ChemicalSubstance] s
LEFT JOIN  [NHS].[Datawarehouse].[vwDimProductType] p on s.CHEMSUBId = p.[ChemicalSubstanceId]
WHERE
	S.CHEMSUBId IS NULL


--DROP TABLE [NHS].[Datawarehouse].[DimProductType]


CREATE TABLE [NHS].[Datawarehouse].[DimProductType]
(
	DimProductTypeSkey	INT IDENTITY (1,1),
	ProductType			varchar(150),
	ChemicalSubstanceId varchar(9),
	DateActiveFrom		datetime

)

CREATE VIEW [Datawarehouse].[vwDimProductType] AS 
SELECT 
	 ProductType			
	,ChemicalSubstanceId 		
FROM [NHS].[Datawarehouse].[DimProductType]




--DELETE 
--FROM [NHS].[Mirror].[ChemicalSubstance] WHERE CHEMSUBId = '99999'

--DELETE 
--FROM [NHS].[stage].[ChemicalSubstance] WHERE CHEMSUBId = '99999'

--SELECT
--	*
--into [NHS].[Mirror].[ChemicalSubstance]
--FROM
--	[NHS].[Stage].[ChemicalSubstance]

