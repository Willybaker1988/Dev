declare @ReportDate datetime;
declare @MaxValidToDate datetime;
declare @LogID int;

set @LogID = ?;
set @ReportDate = ?
set @MaxValidToDate = '9999-12-31';

-- SCD 1
MERGE INTO Dim.Dim_MKT_Account AS CM
USING (SELECT ROW_NUMBER() OVER(PARTITION BY [User_ID] ORDER BY [User_ID] ) RowNo, [User_ID]	,Seller_ID	,AccountFullName	
,BuyerUserName	,SellerUserName	,EmailOptIn	,AccountType	,BoutiqueType	,AccountStatus	
,IsActive	,LatestBlogDate	,FeedbackRating	,AccountCreatedTimestamp	,Country_Key
 FROM Transient.Dim_MKT_Account  )  AS CS
ON (CM.[User_ID] = CS.[User_ID])
WHEN MATCHED AND -- Update all existing rows for Type 1 changes
 CS.RowNo =1 AND
(CM.EmailOptIn <> CS.EmailOptIn
 or CS.EmailOptIn is NULL
 or CM.EmailOptIn is NULL
 or CM.IsActive <> CS.IsActive 
 or CS.IsActive is NULL
 or CM.IsActive is NULL
 or CM.LatestBlogDate <> CS.LatestBlogDate 
 or CS.LatestBlogDate is NULL
 or CM.LatestBlogDate is NULL
 or CM.AccountCreatedTimestamp <> CS.AccountCreatedTimestamp
 or CS.AccountCreatedTimestamp is NULL
 or CM.AccountCreatedTimestamp is NULL)
THEN UPDATE SET 
    CM.EmailOptIn = CS.EmailOptIn
   ,CM.IsActive = CS.IsActive
   ,CM.LatestBlogDate = CS.LatestBlogDate
   ,CM.AccountCreatedTimestamp = CS.AccountCreatedTimestamp
   ,CM.LogId = @LogID
   ,CM.Modified_Date = getdate()
   ,CM.Modified_User = suser_name();

-- SCD 2
INSERT INTO Dim.Dim_MKT_Account
 SELECT [User_ID]
	   ,[Seller_ID]
	   ,[AccountFullName]
	   ,[BuyerUserName]
	   ,[SellerUserName]
	   ,[EmailOptIn]
	   ,[AccountType]
	   ,[BoutiqueType]
	   ,[AccountStatus]
	   ,[IsActive]
	   ,[LatestBlogDate]
	   ,[FeedbackRating]
	   ,[AccountCreatedTimestamp]	   
	   ,[SCDDateFrom]
	   ,[SCDDateTo]
	   ,[SCDIsCurrent]
	   ,[LogId]
	   ,[Modified_Date]
	   ,[Modified_User]	  
	   ,[Country_Key]
 FROM
 ( MERGE Dim.Dim_MKT_Account CM
 USING Transient.Dim_MKT_Account CS
 ON (CM.[User_ID] = CS.[User_ID])
 WHEN NOT MATCHED THEN
 INSERT VALUES (CS.[User_ID]
	           ,CS.[Seller_ID]
	           ,CS.[AccountFullName]
	           ,CS.[BuyerUserName]
	           ,CS.[SellerUserName]
	           ,CS.[EmailOptIn]
	           ,CS.[AccountType]
	           ,CS.[BoutiqueType]
	           ,CS.[AccountStatus]
	           ,CS.[IsActive]
	           ,CS.[LatestBlogDate]
	           ,CS.[FeedbackRating]
	           ,CS.[AccountCreatedTimestamp]	           
	           ,@ReportDate
	           ,@MaxValidToDate
	           ,1
	           ,@LogID
	           ,getdate()
	           ,suser_name()
	           ,CS.[Country_Key])	           
 WHEN MATCHED AND CM.[SCDIsCurrent] = 1
 AND (CM.[Seller_ID] <> CS.[Seller_ID] or (CM.[Seller_ID] is NULL and CS.[Seller_ID] is not NULL)
      or CM.[AccountFullName] <> CS.[AccountFullName]
	  or CM.[BuyerUserName] <> CS.[BuyerUserName] or (CM.[BuyerUserName] is NULL and CS.[BuyerUserName] is not NULL)
	  or CM.[SellerUserName] <> CS.[SellerUserName]	or (CM.[SellerUserName] is NULL and CS.[SellerUserName] is not NULL)
	  or CM.[AccountType] <> CS.[AccountType] or (CM.[AccountType] is NULL and CS.[AccountType] is not NULL)
	  or CM.[BoutiqueType] <> CS.[BoutiqueType] or (CM.[BoutiqueType] is NULL and CS.[BoutiqueType] is not NULL)
	  or CM.[AccountStatus] <> CS.[AccountStatus] or (CM.[AccountStatus] is NULL and CS.[AccountStatus] is not NULL)
	  or CM.[FeedbackRating] <> CS.[FeedbackRating] or (CM.[FeedbackRating] is NULL and CS.[FeedbackRating] is not NULL)
	  or CM.[Country_Key] <> CS.[Country_Key])
 THEN UPDATE SET CM.[SCDIsCurrent] = 0, CM.[SCDDateTo] = @ReportDate, CM.[LogId] = @LogID, CM.[Modified_Date] = getdate(), CM.[Modified_User] = suser_name()
 OUTPUT $Action Action_Out, CS.[User_ID]
	           ,CS.[Seller_ID]
	           ,CS.[AccountFullName]
	           ,CS.[BuyerUserName]
	           ,CS.[SellerUserName]
	           ,CS.[EmailOptIn]
	           ,CS.[AccountType]
	           ,CS.[BoutiqueType]
	           ,CS.[AccountStatus]
	           ,CS.[IsActive]
	           ,CS.[LatestBlogDate]
	           ,CS.[FeedbackRating]
	           ,CS.[AccountCreatedTimestamp]	           
	           ,@ReportDate SCDDateFrom
	           ,@MaxValidToDate SCDDateTo
	           ,1 SCDIsCurrent
	           ,@LogID LogId
	           ,getdate() Modified_Date
	           ,suser_name() Modified_User
	           ,CS.[Country_Key]
 ) AS MERGE_OUT
 WHERE MERGE_OUT.Action_Out = 'UPDATE';


--- Email Error Records

IF OBJECT_ID('tempdb..#Transient_Dim_MKT_Account') IS NOT NULL
	DROP TABLE #Transient_Dim_MKT_Account
	
select top 0 * INTO #Transient_Dim_MKT_Account  from Transient.Dim_MKT_Account 

INSERT INTO #Transient_Dim_MKT_Account
--select * from #Transient_Dim_MKT_Account
SELECT [User_ID]	,ISNULL(Seller_ID,'')	,ISNULL(AccountFullName,'')	
,BuyerUserName	,SellerUserName	,ISNULL(EmailOptIn,'')	,AccountType	,BoutiqueType	,AccountStatus	
,IsActive	,LatestBlogDate	,ISNULL(FeedbackRating,'')	,AccountCreatedTimestamp	,Country_Key
	 from Transient.Dim_MKT_Account WITH (NOLOCK) WHERE [User_ID] in (
SELECT DISTINCT [User_ID] from (
 SELECT ROW_NUMBER() OVER(PARTITION BY [User_ID] ORDER BY [User_ID] ) RowNo, [User_ID]	,Seller_ID	,AccountFullName	
,BuyerUserName	,SellerUserName	,EmailOptIn	,AccountType	,BoutiqueType	,AccountStatus	
,IsActive	,LatestBlogDate	,FeedbackRating	,AccountCreatedTimestamp	,Country_Key
 FROM Transient.Dim_MKT_Account WITH (NOLOCK)
) a
where RowNo > 1
)

DECLARE @xml NVARCHAR(MAX)
DECLARE @body NVARCHAR(MAX)


SET @xml = CAST(( SELECT [User_ID] AS 'td','',Seller_ID AS 'td','',AccountFullName AS 'td',''
,BuyerUserName AS 'td',''
,SellerUserName AS 'td',''
,ISNULL(EmailOptIn,'') AS 'td',''
,AccountType AS 'td',''
,BoutiqueType AS 'td',''
,AccountStatus AS 'td',''
,IsActive AS 'td',''
,ISNULL(LatestBlogDate,'') AS 'td',''
,ISNULL(FeedbackRating,'') AS 'td',''
,AccountCreatedTimestamp AS 'td',''
,Country_Key AS 'td'
FROM  #Transient_Dim_MKT_Account ORDER BY [User_ID], Seller_ID 
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))


SET @body ='<html><body><H3>Market Place - Duplicate Data</H3>
<table border = 1> 
<tr>
<th> User_ID </th> <th> Seller_ID </th> <th> AccountFullName </th>    
<th> BuyerUserName </th> <th> SellerUserName </th> <th> EmailOptIn </th>
<th> AccountType </th> <th> BoutiqueType </th> <th> AccountStatus </th>
<th> IsActive </th> <th> LatestBlogDate </th> <th> FeedbackRating </th>
<th> AccountCreatedTimestamp </th> <th> Country_Key </th> 
</tr>'
 
SET @body = @body + @xml +'</table></body><H3>Please fix the above</H3></html>'


EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'SqlSrvMailUser', 
@body = @body,
@body_format ='HTML',
@recipients = 'BITeam@asos.com',
@copy_recipients =  'ChrisN@asos.com',
@subject = 'MarketPlace - User Accounts - Duplicate Data' ;



