SET @MaxRecords = (SELECT TOP 1 COUNT(*) FROM  #Transient_Dim_MKT_Account)

IF (@MaxRecords = 0)
BEGIN
	PRINT 'No Duplicate Data';
END
IF (@MaxRecords = 1)
BEGIN

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
	@profile_name = @EmailProfile, 
	--@profile_name = 'BI SQL Server Notifications – UAT', 
	@body = @body,
	@body_format ='HTML',
	@recipients = @Email,
	@copy_recipients =  @EmailCC,
	@subject = 'MarketPlace - User Accounts - Duplicate Data' ;
END
