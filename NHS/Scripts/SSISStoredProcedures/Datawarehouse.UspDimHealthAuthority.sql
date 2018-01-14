USE [NHS]
GO

/****** Object:  StoredProcedure [Datawarehouse].[uspDimHealthAuthority]    Script Date: 14/01/2018 14:04:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Datawarehouse].[UspDimHealthAuthority]
@PackageName NVARCHAR(100),
@UserName	 NVARCHAR(100),
@Type		 NVARCHAR(100)
AS
BEGIN

/*
 Start logging and cxpature all Inserted HealthAuthorities records
*/ 

DECLARE @InsertCount INT = NULL, 
		@ActivityLogDateTimeCreated DATETIME = GETDATE(),
		@vPackageName NVARCHAR(100),
		@vUserName	  NVARCHAR(100),
		@vType		  NVARCHAR(100)


EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = @vPackageName
  ,@UserName      = @vUserName    
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = @vType
  ,@Status       = 'Started'
  ,@Comment       = 'Checking for new [Datawarehouse].[DimHealthAuthority]  records'

 MERGE INTO 
  [NHS].[Datawarehouse].[DimHealthAuthority] AS T
 USING 
 (
  SELECT   
    [SHA]					= UPPER([sha])
   ,[HealthAuthorityName]	= ISNULL(D.SHANAME,'UNDEFINED')
   ,[DateCreated]			= CAST(GETDATE() AS DATE)
  FROM 
	[NHS].[Stage].[Prescription] F
  LEFT OUTER JOIN
	[Transform].[vwStrategicHealthAuthorityStaticList] D ON F.SHA = D.SHACODE
  GROUP BY
   [SHA]
   ,ISNULL(D.SHANAME,'UNDEFINED')   
  --For future reference will need to add in a lookup file of all the SHA names and join that table here.
 ) AS S
 ON
  T.[HealthAuthorityId] = S.[SHA]
 WHEN NOT MATCHED THEN INSERT ([HealthAuthorityId], [DateActiveFrom],[HealthAuthorityName])  VALUES (S.[SHA] , S.[DateCreated], S.[HealthAuthorityName]);
 SET @InsertCount    = @@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)  = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimHealthAuthority]'
SET @ActivityLogDateTimeCreated  = GETDATE()
/*
 Finish logging and cxpature all Inserted HealthAuthorities records
*/

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName      = @vPackageName
  ,@UserName      = @vUserName   
  ,@ActivityLogDateTimeCreated  = @ActivityLogDateTimeCreated
  ,@Type       = @vType
  ,@Status       = 'Succeeded'
  ,@Comment       = @Comment

END
GO


