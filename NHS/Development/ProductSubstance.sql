use NHS

--BNF_ProductSubstance

SELECT 
--CHEMSUBNAME,
max(LEN([CHEMSUBId])) , min(LEN([CHEMSUBId]))
FROM [NHS].[Stage].[ChemicalSubstance]
GROUP BY LEN([CHEMSUBId])

SELECT top 1
[CHEMSUBId], CHEMSUBNAME
FROM [NHS].[Stage].[ChemicalSubstance]
WHERE LEN([CHEMSUBId]) = 4

SELECT top 1
[CHEMSUBId], CHEMSUBNAME
FROM [NHS].[Stage].[ChemicalSubstance]
WHERE LEN([CHEMSUBId]) = 9

--SELECT LEN([BNFCODE])
--FROM [Stage].[Prescription]
--GROUP BY LEN([BNFCODE])

SELECT top 1 [BNFCODE], BNFNAME
FROM [Stage].[Prescription]
WHERE LEN([BNFCODE]) = 11

SELECT top 1 [BNFCODE], BNFNAME
FROM [Stage].[Prescription]
WHERE LEN([BNFCODE]) = 15



--Checking relationships between potentially DimProduct and DimProductType
SELECT 
	F.ProductName,
	[Types]		=	COUNT(DISTINCT ProductType)
FROM
(
	SELECT DISTINCT
		 [BNFCode]	   = [BNFCODE]
		,[ProductName] = [BNFNAME]
		,[ChemicalSubstanceId]		=	CASE
											WHEN   LEN([BNFCODE]) = 11 THEN LEFT([BNFCODE], 4) 
											WHEN   LEN([BNFCODE]) = 15 THEN LEFT([BNFCODE], 9)
										ELSE [BNFCODE] 
										END
		,[ProductType]	= D.[CHEMSUBNAME]
		,[MedicalTreatmentTye]= NULL
	FROM [Stage].[Prescription] F
	LEFT OUTER JOIN [NHS].[Stage].[ChemicalSubstance] D ON D.CHEMSUBId = CASE
																		WHEN   LEN([BNFCODE]) = 11 THEN LEFT([BNFCODE], 4) 
																		WHEN   LEN([BNFCODE]) = 15 THEN LEFT([BNFCODE], 9)
																ELSE [BNFCODE] END
)
F
	group by F.ProductName
	having COUNT(DISTINCT ProductType) > 1



SELECT DISTINCT
	 [ProductName] = LTRIM(RTRIM([BNFNAME]))
	,[ProductType]	= D.[CHEMSUBNAME]
	,[MedicalTreatmentTye]= NULL
	,[ChemicalSubstanceId]		=	CASE
										WHEN   LEN([BNFCODE]) = 11 THEN LEFT([BNFCODE], 4) 
										WHEN   LEN([BNFCODE]) = 15 THEN LEFT([BNFCODE], 9)
									ELSE [BNFCODE] 
									END

FROM [Stage].[Prescription] F
LEFT OUTER JOIN [NHS].[Stage].[ChemicalSubstance] D ON D.CHEMSUBId = CASE
																		WHEN   LEN([BNFCODE]) = 11 THEN LEFT([BNFCODE], 4) 
																		WHEN   LEN([BNFCODE]) = 15 THEN LEFT([BNFCODE], 9)
																		ELSE   [BNFCODE] 
																	END
WHERE
	[BNFNAME] in ('Coloplast_Assura Insp Maxi Closed Bag De')	

