--Examples of GP address Postcodes which have changed in latest File

SELECT * 
FROM
(
	SELECT 
		F.GPID,
		F.PostCode,
		[TransformFileLogId] = f.FileLogId,
		[MirrorPostcode] =	D.PostCode,
		[MirrorFileLogId] = d.FileLogId
	FROM [NHS].[Transform].[DimGeneralPracticeAddress] F
	INNER JOIN
	(
		select GPId, PostCode, FileLogId FROM [NHS].[Mirror].[DimGeneralPracticeAddress] where datecreated <> datemodified
	)
	D
	ON D.GPId = F.GPId
	WHERE F.GPID <> 'xx999'
)
E
where [MirrorPostcode] <> e.PostCode
order by GPId

--Check Datawarehouse table that these records are being recorded as SLCD TYPE 2.
--Should have 2 records, 
---1 record for the old address and postcode with ISACTIVE set to 0
---1 record for the new address and postcode with ISACTIVE set to 1


SELECT 
	F.* 
FROM [NHS].[Datawarehouse].[DimGeneralPracticeAddress] F
INNER JOIN
(
	SELECT * 
	FROM
	(
		SELECT 
			F.GPID,
			F.PostCode,
			[TransformFileLogId] = f.FileLogId,
			[MirrorPostcode] =	D.PostCode,
			[MirrorFileLogId] = d.FileLogId
		FROM [NHS].[Transform].[DimGeneralPracticeAddress] F
		INNER JOIN
		(
			select GPId, PostCode, FileLogId FROM [NHS].[Mirror].[DimGeneralPracticeAddress] where datecreated <> datemodified
		)
		D
		ON D.GPId = F.GPId
	)
	E
	where [MirrorPostcode] <> e.PostCode
)D
ON D.GPId = F.GPID