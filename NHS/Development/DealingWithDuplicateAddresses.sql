--Loads the latest GeneralPracticeAddress using the latestFileLogId
SELECT
	 GPId
	,GeneralPracticePrimarySurgeryName
	,GeneralPracticeSecondarySurgeryName
	,AddressLine1
	,AddressLine2
	,AddressLine3
	,PostCode
	--,FileLogId
FROM 
(
	SELECT DISTINCT
		 GPId
		,GeneralPracticePrimarySurgeryName
		,GeneralPracticeSecondarySurgeryName
		,AddressLine1
		,AddressLine2
		,AddressLine3
		,PostCode
		,FileLogId
		,[ROW] = ROW_NUMBER() OVER (PARTITION BY GPID ORDER BY FILELOGID DESC)
	FROM  [NHS].[Mirror].[DimGeneralPracticeAddress] 
)
D
WHERE D.ROW = 1