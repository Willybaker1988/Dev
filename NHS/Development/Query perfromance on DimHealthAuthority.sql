create  TABLE [Datawarehouse].[DimHealthAuthority]
(
	[DimHealthAuthroritySkey] INT IDENTITY(1,1),
	[HealthAuthorityId]	varchar(3),
	[HealthAuthorityName] varchar(150) NULL,
	[DateActiveFrom] DATETIME

)


	MERGE INTO 
		[NHS].[Datawarehouse].[DimHealthAuthority] AS T
	USING 
	(
		SELECT   
			[SHA]			= UPPER([sha]),
			[DateCreated]	= CAST(GETDATE() AS DATE)
		FROM [NHS].[Stage].[Prescription]
		GROUP BY
			[SHA]			
		--For future reference will need to add in a lookup file of all the SHA names and join that table here.
	) AS S
	ON
		T.[HealthAuthorityId] = S.[SHA]
	WHEN NOT MATCHED THEN INSERT ([HealthAuthorityId], DateActiveFrom)  VALUES (S.[SHA] , S.[DateCreated]);

	/*
	Optimising query - group by more efficient
	*/
		SELECT   
			[SHA]			= UPPER([sha]),
			[DateCreated]	= CAST(GETDATE() AS DATE)
		FROM [NHS].[Stage].[Prescription]
		GROUP BY
			[SHA]			
			--,CAST(GETDATE() AS DATE)
			option (recompile); 

		SELECT  distinct  
			[SHA]			= UPPER([sha]),
			[DateCreated]	= CAST(GETDATE() AS DATE)
		FROM [NHS].[Stage].[Prescription]
	     option (recompile); 