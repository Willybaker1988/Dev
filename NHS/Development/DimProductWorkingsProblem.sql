SELECT DISTINCT 
	   [PrescriptionRecordId]
	  ,[DimPeriodSKey]					=	D.[DimPeriodSKey]
	  ,[DimHealthAuthroritySkey]		=	SHA.DimHealthAuthroritySkey
	  ,[DimPrimaryCareTrustSkey]		=	pct.DimPrimaryCareTrustSkey
	  ,[DimGeneralPracticeSKey]			=	GP.DimGeneralPracticeSKey
	  ,[DimProductSkey]					=	P.DimProductSkey
	  ,[DimProductTypeSkey]				=	PT.DimProductTypeSkey
      ,[Items]
      ,[NIC]
      ,[ActCost]
      ,[Qty]
      
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
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[vwDimDate] D ON F.[PeriodId] = D.[PeriodId]

 
 SELECT TOP 100 *
 FROM 
 	[NHS].[Datawarehouse].[DimProduct] P
  LEFT OUTER JOIN
	[NHS].[Datawarehouse].[DimProductType] PT ON P.[ChemicalSubstanceId] = PT.[ChemicalSubstanceId]


 SELECT TOP 100 *
 FROM 
 	[NHS].[Datawarehouse].[DimProduct]






 SELECT COUNT(*) FROM [NHS].[Datawarehouse].[DimProduct]
 SELECT COUNT(*) FROM [NHS].[Datawarehouse].[DimProductType] 
 SELECT COUNT(*) FROM [NHS].[Datawarehouse].[DimGeneralPracticeAddress] 
 SELECT COUNT(*) FROM [NHS].[Transform].[LookupPCTToGeneralPractice] 
 SELECT COUNT(*) FROM [NHS].[Datawarehouse].[DimPrimaryCareTrust] 
 SELECT COUNT(*) FROM [NHS].[Datawarehouse].[DimHealthAuthority]
 SELECT COUNT(*) FROM [NHS].[Datawarehouse].[vwDimDate]
 SELECT COUNT(*) FROM [NHS].[Mirror].[FactPrescription]
 SELECT COUNT(*) FROM [NHS].[Datawarehouse].[FactPrescription] 

 select 40175298 - 39984843
 select 50115445 - 50101233



 --SELECT TOP 100
 SELECT TOP 100 * FROM [NHS].[Mirror].[FactPrescription] ORDER BY 1 
 SELECT TOP 100 * FROM [NHS].[Datawarehouse].[FactPrescription] ORDER BY 1  

 SELECT * FROM [NHS].[Mirror].[FactPrescription] WHERE PrescriptionRecordId = 48773751
 SELECT * FROM [NHS].[Datawarehouse].[FactPrescription] WHERE PrescriptionRecordId = 48773751 

 select * from nhs.Datawarehouse.DimProduct where DimProductSkey = 4168
 select * from nhs.Datawarehouse.DimProductType where DimProductTypeSkey in (518, 3356)


  --SELECT * FROM [NHS].[Mirror].[FactPrescription] --WHERE PrescriptionRecordId = 7920540
 SELECT PrescriptionRecordId, count(PrescriptionRecordId) 
 FROM [NHS].[Datawarehouse].[FactPrescription] 
 group by PrescriptionRecordId
 having count(PrescriptionRecordId)  > 1--WHERE PrescriptionRecordId = 7920540 


 --use below to pull out list of DimProducts which have changed there name since first load into the Dimension tabke.
 SELECT * FROM NHS.Datawarehouse.DimProduct WHERE DimProductSkey IN (8908,23)

 DELETE  
 FROM  NHS.Datawarehouse.DimProduct 
 WHERE  BNFCODE IN
 (
	 
	 SELECT f.BNFCODE
	 FROM  NHS.Datawarehouse.DimProduct F
	 INNER JOIN (
	 SELECT bnfcode,  COUNT(DimProductSkey) AS [COUNT] FROM NHS.Datawarehouse.DimProduct 
	 group by bnfcode
	 having  COUNT(DimProductSkey)  > 1) D ON D.BNFCode = F.BNFCode
 )
 D ON D.BNFCode = F.BNFCode
 

 SELECT PrescriptionRecordId,
 count(PrescriptionRecordId) 
 from
  [NHS].[Datawarehouse].[FactPrescription]
  group by PrescriptionRecordId
  having  count(PrescriptionRecordId) > 1
  ORDER BY  count(PrescriptionRecordId) DESC