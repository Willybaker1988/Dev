/*
	Start logging and cxpature all Inserted HealthAuthorities records
*/ 

DECLARE @InsertCount INT = NULL, @ActivityLogDateTimeCreated DATETIME = GETDATE()

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName						=	?
  ,@UserName						=	?				
  ,@ActivityLogDateTimeCreated		=	@ActivityLogDateTimeCreated
  ,@Type							=	?
  ,@Status							=	'Started'
  ,@Comment							=	'Checking for new [Datawarehouse].[DimHealthAuthority]  records'

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
	SET @InsertCount				=	@@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)		=	''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimHealthAuthority]'
SET @ActivityLogDateTimeCreated		=	GETDATE()
/*
	Finish logging and cxpature all Inserted HealthAuthorities records
*/

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName						=	?
  ,@UserName						=	?				
  ,@ActivityLogDateTimeCreated		=	@ActivityLogDateTimeCreated
  ,@Type							=	?
  ,@Status							=	'Succeeded'
  ,@Comment							=	@Comment