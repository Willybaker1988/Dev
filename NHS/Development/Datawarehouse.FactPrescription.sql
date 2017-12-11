/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT TOP 100 [PrescriptionRecordId]
      ,[SHA]
      ,[PCT]
      ,F.[GPId]
	  ,GP.DimGeneralPracticeSKey
      ,[BNFCode]		=	f.[BNFCode]
	  ,[DimProductSkey]	=	P.DimProductSkey
      ,f.[ChemicalSubstanceId]
	  ,P.DimProductTypeSkey
	  ,PT.DimProductTypeSkey
      ,[Items]
      ,[NIC]
      ,[ActCost]
      ,[Qty]
      ,[PeriodId]
  FROM
	[NHS].[Mirror].[FactPrescription] F
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[DimProduct] P ON F.[BNFCode] = P.[BNFCode]
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[DimProductType] PT ON P.[ChemicalSubstanceId] = PT.[ChemicalSubstanceId]
  LEFT OUTER JOIN 
	[NHS].[Datawarehouse].[DimGeneralPracticeAddress] GP ON F.[GPId] = GP.[GPId] 
  LEFT OUTER JOIN
	[NHS].[Transform].[LookupPCTToGeneralPractice] LKP ON GP.[GPId] = LKP.[GPId]
  LEFT OUTER JOIN 
	[NHS].[Datawarehouse].[DimPrimaryCareTrust] PCT ON PCT.[PrimaryTrustId] = LKP.[PrimaryTrustId]
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[DimHealthAuthority] SHA ON SHA.[DimHealthAuthroritySkey] = PCT.[DimHealthAuthroritySkey] --Should be changed to Bkeys rather than Skeys

