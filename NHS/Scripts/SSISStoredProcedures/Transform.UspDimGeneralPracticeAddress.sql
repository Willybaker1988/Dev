USE [NHS]
GO

/****** Object:  StoredProcedure [Transform].[uspDimGeneralPracticeAddress]    Script Date: 14/01/2018 14:13:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Transform].[UspDimGeneralPracticeAddress]
AS
BEGIN
/*
	Convert BLANKS in attributes to NULLs for Transformation from Staging to Datwarehouse
*/

DECLARE @Updatecounter INT

UPDATE [NHS].[Stage].[GPAddress]
SET Address1 = NULL
WHERE Address1 = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS Address1


UPDATE [NHS].[Stage].[GPAddress]
SET Address2 = NULL
WHERE Address2 = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS Address2


UPDATE [NHS].[Stage].[GPAddress]
SET Address3 = NULL
WHERE Address3 = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS Address3

UPDATE [NHS].[Stage].[GPAddress]
SET name = NULL
WHERE name = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS name

UPDATE [NHS].[Stage].[GPAddress]
SET gpsurgeryname = NULL
WHERE gpsurgeryname = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS gpsurgeryname

UPDATE [NHS].[Stage].[GPAddress]
SET postcode = NULL
WHERE postcode = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS postcode


insert into [Transform].[DimGeneralPracticeAddress]
(
		 [GPId]								
		,[GeneralPracticePrimarySurgeryName]	
		,[GeneralPracticeSecondarySurgeryName]
		,[AddressLine1]						
		,[AddressLine2]						
		,[AddressLine3]						
		,[PostCode]		
		,FileLogId						
)
SELECT 
	   COALESCE(GP.[GPId]			,   T.[GPId]									 )
      ,COALESCE(GP.[GPSurgeryName]  , T.[GeneralPracticePrimarySurgeryName]			 )
      ,COALESCE(GP.[Name]			,   T.[GeneralPracticeSecondarySurgeryName]	     )
      ,COALESCE(GP.[Address1]		,   T.[AddressLine1]							 )
      ,COALESCE(GP.[Address2]		,   T.[AddressLine2]							 )
      ,COALESCE(GP.[Address3]		,   T.[AddressLine3]							 )
      ,COALESCE(GP.[PostCode]		,   T.[PostCode]								 )
      ,[FileLogId]

  FROM
	 [NHS].[Stage].[GPAddress] GP
  cross join
	 [Transform].[udfTemplateDimGeneralPracticeAddress]() T
  --Will only pull through new staged records into the Tranform table
  WHERE 
	 [FileLogId] NOT IN (SELECT DISTINCT [FileLogId] FROM  [NHS].[Transform].[DimGeneralPracticeAddress])

END
GO


