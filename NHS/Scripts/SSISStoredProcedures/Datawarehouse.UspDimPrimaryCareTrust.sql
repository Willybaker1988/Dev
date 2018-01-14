USE [NHS]
GO

/****** Object:  StoredProcedure [Datawarehouse].[uspDimPrimaryCareTrust]    Script Date: 14/01/2018 14:05:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Datawarehouse].[UspDimPrimaryCareTrust]
@PackageName NVARCHAR(100),
@UserName	 NVARCHAR(100),
@Type		 NVARCHAR(100)
AS
BEGIN

/*
 Start logging and cxpature all Inserted DimPrimaryCareTrust records
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
  ,@Comment       = 'Checking for new [Datawarehouse].[DimPrimaryCareTrust] records'


 MERGE INTO 
  [NHS].[Datawarehouse].[DimPrimaryCareTrust] AS T
 USING 
 (
  SELECT  
	    [PCT]					= UPPER([PCT])
	   ,[PrimaryCareTrustName]	= UPPER(COALESCE(CCG.CCGNAME, PCT.ORGANISATION, 'UNDEFINED'))
	   ,[CareType]				= CASE	
										WHEN CCG.CCGNAME IS NOT NULL THEN 'CCG'
										WHEN PCT.ORGANISATION IS NOT NULL THEN 'PCT'
										ELSE 'UNDEFINED'
								  END
	   ,[DateCreated]			= CAST(GETDATE() AS DATE)
	   ,[DimHealthAuthroritySkey] 
  FROM 
		[NHS].[Stage].[Prescription] F
  INNER JOIN
		[NHS].[Datawarehouse].[DimHealthAuthority] HA ON F.SHA = HA.[HealthAuthorityId]
  LEFT OUTER JOIN
		[NHS].[Stage].[ReferenceCCGCodesAndCCGNames] CCG ON F.[PCT] = CCG.[CCGCode]
  LEFT OUTER JOIN
		[NHS].[Stage].[ReferenceTrustCodesAndTrustNames] PCT ON F.[PCT] = PCT.Code
  GROUP BY
		[PCT], 
		[DimHealthAuthroritySkey],
		UPPER(COALESCE(CCG.CCGNAME, PCT.ORGANISATION, 'UNDEFINED')),
		CASE	
				WHEN CCG.CCGNAME IS NOT NULL THEN 'CCG'
				WHEN PCT.ORGANISATION IS NOT NULL THEN 'PCT'
				ELSE 'UNDEFINED'
		END

 ) AS S
 ON
  T.[PrimaryTrustId] = S.[PCT]
 WHEN NOT MATCHED THEN INSERT ([PrimaryTrustId],[DimHealthAuthroritySkey], [DateActiveFrom], [PrimaryCareTrustName], [CareType])  VALUES (S.[PCT] ,S.[DimHealthAuthroritySkey], S.[DateCreated], S.[PrimaryCareTrustName], s.[CareType]);
 SET @InsertCount    = @@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)  = ''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Datawarehouse].[DimPrimaryCareTrust]'
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


