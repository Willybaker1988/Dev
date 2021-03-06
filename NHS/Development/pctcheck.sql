/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	[Type] = CASE WHEN [PrimaryCareTrustName] LIKE '%ccg%' THEN 'CCG' ELSE [PrimaryCareTrustName] END
	,SUM(1)
FROM
(

	SELECT 
	TOP (1000) [DimPrimaryCareTrustSkey]
		  ,[PrimaryTrustId]
		  ,[PrimaryCareTrustName] = COALESCE(SC.CCGName,'UNKNOWN')
		  ,[DateActiveFrom]
		  ,[DimHealthAuthroritySkey]
		  --,SC.*
	  FROM [NHS].[Datawarehouse].[DimPrimaryCareTrust] F
	  LEFT OUTER JOIN  [Development].[dbo].[CCGCodesAndCCGNames] SC ON F.PrimaryTrustId = SC.CCGCODE

)
D
GROUP BY CASE WHEN [PrimaryCareTrustName] LIKE '%ccg%' THEN 'CCG' ELSE [PrimaryCareTrustName] END
