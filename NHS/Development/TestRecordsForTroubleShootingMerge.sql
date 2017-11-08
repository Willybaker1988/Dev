--All results are stored in the spreadsheet

--DELETE FROM [NHS].[Transform].[DimGeneralPracticeAddress] WHERE GPId = 'xx999'
--DELETE FROM [NHS].[Mirror].[DimGeneralPracticeAddress] WHERE GPId = 'xx999'

--QUERYTEST1
	--1. Intial new TestRecord [NHS].[Transform].[DimGeneralPracticeAddress] for New GP (Mirror DimGeneralPracticeAddress)
	--RESULT: PASS

	INSERT INTO [NHS].[Transform].[DimGeneralPracticeAddress] 
	select 'xx999','TEST','TEST','TEST','TEST','TEST','XXX 999',999
	--[NHS].[Transform].[DimGeneralPracticeAddress] 

	/*

	GPId                                                                                                                             varchar                                                                                                                          no                                  6                       yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	GeneralPracticePrimarySurgeryName                                                                                                varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	GeneralPracticeSecondarySurgeryName                                                                                              varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	AddressLine1                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	AddressLine2                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	AddressLine3                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	PostCode                                                                                                                         varchar                                                                                                                          no                                  10                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	FileLogId																														 int

	*/    

	--2. Intial new TestRecord [NHS].[Transform].[DimGeneralPracticeAddress] for New GP (Mirror DimGeneralPracticeAddress)
	--RESULT: PASS 
	--The record has been updated in the [Mirror].[DimGeneralPracticeAddress]

	INSERT INTO [NHS].[Transform].[DimGeneralPracticeAddress] 
	select 'xx999','WILLTEST','TEST','TEST','TEST','TEST','XXX 999',1000
	--[NHS].[Transform].[DimGeneralPracticeAddress] 

	/*

	GPId                                                                                                                             varchar                                                                                                                          no                                  6                       yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	GeneralPracticePrimarySurgeryName                                                                                                varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	GeneralPracticeSecondarySurgeryName                                                                                              varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	AddressLine1                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	AddressLine2                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	AddressLine3                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	PostCode                                                                                                                         varchar                                                                                                                          no                                  10                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
	FileLogId																														 int

	*/  


--QUERYTEST2
	--1a. Intial new TestRecord [NHS].[Transform].[DimGeneralPracticeAddress] for New GP (Mirror DimGeneralPracticeAddress)
	--b. Record should b ethen INSERTED INTO [NHS].[Datawarehouse].[DimGeneralPracticeAddress] 
	--RESULT: PASS

	INSERT INTO [NHS].[Transform].[DimGeneralPracticeAddress] 
	select 'xx999','TEST','TEST','TEST','TEST','TEST','XXX 999',999
	--[NHS].[Transform].[DimGeneralPracticeAddress] 
                       
	
	--2. The inserted record should be updated in [NHS].[Mirror].[DimGeneralPracticeAddress] with latest record changes by QUERYTEST1
	--2b
	INSERT INTO [NHS].[Transform].[DimGeneralPracticeAddress] 
	select 'xx999','WILLTEST','TEST','TEST','TEST','TEST','XXX 898',1000
	--[NHS].[Transform].[DimGeneralPracticeAddress] 		
	--RESULT: FAILED
	
	--2. The inserted record should be updated in [NHS].[Mirror].[DimGeneralPracticeAddress] with latest record changes by QUERYTEST1
	--2b
	INSERT INTO [NHS].[Transform].[DimGeneralPracticeAddress] 
	select 'xx999','WILLTEST','TEST','TEST','TEST','TEST','XXX 801',10002
	--[NHS].[Transform].[DimGeneralPracticeAddress] 			   
					   	   
					   
					   
					                                                                                              

--TestRecord [NHS].[Mirror].[DimGeneralPracticeAddress] 
--INSERT INTO [NHS].[Mirror].[DimGeneralPracticeAddress]
--select 'xx999','Will','TEST','TEST','TEST','TEST','XXX 999',999, CAST('99991231' AS DATETIME),CAST('99991231' AS DATETIME)

--/*

--GPId                                                                                                                             varchar                                                                                                                          no                                  6                       yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
--GeneralPracticePrimarySurgeryName                                                                                                varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
--GeneralPracticeSecondarySurgeryName                                                                                              varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
--AddressLine1                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
--AddressLine2                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
--AddressLine3                                                                                                                     varchar                                                                                                                          no                                  50                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
--PostCode                                                                                                                         varchar                                                                                                                          no                                  10                      yes                                 no                                  yes                                 SQL_Latin1_General_CP1_CI_AS
--FileLogId                                                                                                                        int                                                                                                                              no                                  4           10    0     yes                                 (n/a)                               (n/a)                               NULL
--DateCreated                                                                                                                      datetime                                                                                                                         no                                  8                       yes                                 (n/a)                               (n/a)                               NULL
--DateModified                                                                                                                     datetime                 

--*/          
