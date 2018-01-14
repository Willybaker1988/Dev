USE [NHS]
GO

/****** Object:  StoredProcedure [Mirror].[uspDimProduct]    Script Date: 14/01/2018 14:11:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Mirror].[UspDimProduct]
@PackageName NVARCHAR(100),
@UserName	 NVARCHAR(100),
@Type		 NVARCHAR(100)
AS
BEGIN
/*
	Start logging and cxpature all Inserted ProductTypes records
*/ 

DECLARE @InsertCount INT = NULL, 
		@ActivityLogDateTimeCreated DATETIME = GETDATE(),
		@vPackageName NVARCHAR(100),
		@vUserName	  NVARCHAR(100),
		@vType		  NVARCHAR(100)



EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName						=	@vPackageName
  ,@UserName						=	@vUserName				
  ,@ActivityLogDateTimeCreated		=	@ActivityLogDateTimeCreated
  ,@Type							=	@vType
  ,@Status							=	'Started'
  ,@Comment							=	'Checking for new [Mirror].[DimProduct] records'

INSERT INTO [Mirror].[DimProduct] 
(
	[ProductId]
   ,[BNFCode]
   ,[ProductName]
   ,[BNFName]
   ,[ChemicalSubstanceId]
)

SELECT DISTINCT
	 [ProductId]			=		UPPER([BNFCODE])
	,[BNFCode]				=		UPPER([BNFCODE])
	,[ProductName]			=		UPPER([BNFNAME])
	,[ProductName]			=		UPPER([BNFNAME])
	,[ChemicalSubstanceId]	=		UPPER([CHEMSUBId])
FROM [Stage].[Prescription] F
LEFT OUTER JOIN
	 [NHS].[Stage].[ChemicalSubstance] D ON D.CHEMSUBId = CASE
																	WHEN   LEN([BNFCODE]) = 11 THEN LEFT([BNFCODE], 4) 
																	WHEN   LEN([BNFCODE]) = 15 THEN LEFT([BNFCODE], 9)
															ELSE [BNFCODE] END
															AND
															F.PERIOD = D.PERIOD
WHERE
	BNFCODE NOT IN (SELECT BNFCODE FROM [Mirror].[DimProduct])
SET @InsertCount				=	@@ROWCOUNT;

DECLARE @Comment NVARCHAR(250)		=	''+CAST(@InsertCount as nvarchar(100))+' records inserted into [Mirror].[DimProduct]'
SET @ActivityLogDateTimeCreated		=	GETDATE()
/*
	Finish logging and cxpature all Inserted ProductTypes records
*/

EXECUTE [DW_Framework].[dbo].[UspExecutionLogActivity] 
   @PackageName						=	@vPackageName
  ,@UserName						=	@vUserName				
  ,@ActivityLogDateTimeCreated		=	@ActivityLogDateTimeCreated
  ,@Type							=	@vType
  ,@Status							=	'Succeeded'
  ,@Comment							=	@Comment

END
GO


