use [DataWarehouse]

--Start of Variable Declarations
DECLARE @CurrentBilledMonth NVARCHAR(2) =  CASE 
											WHEN DATEPART(M,GETDATE()) < 10 THEN '0' + CAST(DATEPART(M,GETDATE()) AS NVARCHAR(2))
											ELSE CAST(DATEPART(M,GETDATE()) AS NVARCHAR(2))
										   END	
DECLARE @CurrentBilledYear INT =  DATEPART(yyyy,GETDATE())
DECLARE @LatestLoadDate DATE = 		(SELECT
										 MAX(CAST(LogCreatedDateTime AS DATE)) as LogCreatedDateTime
									 FROM
									 	 diframework.datawarehouse.ActivityLog
									 WHERE
									 	 Object = 'Datawarehouse'
									 AND
										 Remark = 'DataWarehouseMaster has completed a load')
DECLARE @Servername NVARCHAR(50) = @@SERVERNAME
DECLARE @LoadStatus NVARCHAR(MAX) = 'The last full load on ' + @servername + ' completed on ' + CAST(@LatestLoadDate AS CHAR(10)) + ' , all data returned in the query will be upto this date'

SELECT @LoadStatus as PLEASE_BE_AWARE

--Created for validation on TEST04 latest load
--End of Variable Declarations

DECLARE @TABLE TABLE
(
DimCustomerAccountSKey  INT
)

insert into @TABLE
VALUES (350876),(10531305),(36657565)


;with 
	cte_Cust_FactOrderItem 
AS
(
  SELECT 
	 f.DimCustomerAccountSKey
	,f.DimBillingAddressSKey
	,f.DimShippingAddressSKey
	,f.DimShippedDateSkey
	,f.[DimProductSKey]
	,f.ReceiptId
	,f.ReceiptItemId
	,f.[VoidItemId] 
	,f.TransactionPrice
	,f.TransactionDiscountValue
	,f.Units
	,f.DimDiscountSKey
	,f.[DimbilledDateSkey]
	,f.[DimReceiptDateSKey]
	,A.FirstName 
	,A.LastName 
	,A.AccountEmail 
  FROM 
	[DataWarehouse].[datawarehouse].[FactOrderItem] f
  inner join
    [DataWarehouse].[datawarehouse].[DimCustomerAccount] A on f.DimCustomerAccountSKey = a.DimCustomerAccountSKey
  inner join 
	@TABLE t ON f.DimCustomerAccountSKey = T.DimCustomerAccountSKey
),

	cte_OrderDetails
AS
(
	SELECT 
		 DimCustomerAccountSKey		=	F.DimCustomerAccountSKey 
		,AccountName				=	F.FirstName +' '+ F.LastName 
		,AccountEmail				=	F.AccountEmail 
		,Billed_Address1			=	ad.[Address1]
		,Billed_Address2			=	ad.[Address2]
		,Billed_City				=	ad.[City]
		,Billed_County				=	ad.[County]
		,Billed_Postcode			=	ad.[Postcode]
		,Shipped_Address1			=	sh.[Address1]
		,Shipped_Address2 			=	sh.[Address2]
		,Shipped_City 				=	sh.[City]
		,Shipped_County 			=	sh.[County]
		,Shipped_Postcode			=	sh.[Postcode]
		,ReceiptId 					=	F.ReceiptId
		,ReceiptItemId				=	F.ReceiptItemId
		,ProductDescription			=	P.ProductDescription
		,BilledDate					=	b.[CalendarDate]
		,BilledYearMonth			=	b.[CalendarYearMonthDescription]
		,BilledYear					=	b.[CalendarYearNumber]
		,ShippedDate				=	s.[CalendarDate] 
		,DiscountCode				=	d.[DiscountCode]
		,[Returns]					=	 CASE 
											WHEN [VoidItemId]  = '-1' 
											THEN 0 
											ELSE sum(TransactionPrice) + sum(TransactionDiscountValue) 
										 END
		,[TransactionPrice]			=	 sum(TransactionPrice)
		,[TransactionDiscountValue]	=	 sum(TransactionDiscountValue)
		,[ASOSStaffDiscountPrice]	=	 sum(TransactionPrice) + sum(TransactionDiscountValue)
		,[QTY]						=	 sum(Units) 
	FROM
		cte_Cust_FactOrderItem F
	INNER JOIN  
		[DataWarehouse].[datawarehouse].[DimAddress] ad  on f.DimBillingAddressSKey = ad.DimAddressSKey
	INNER JOIN  
		[DataWarehouse].[datawarehouse].[DimAddress] sh  on f.DimShippingAddressSKey = sh.DimAddressSKey
	INNER JOIN 
		[DataWarehouse].[datawarehouse].[DimProduct] p on p.[DimProductSKey] = f.[DimProductSKey] 
	INNER JOIN  
		[DataWarehouse].[datawarehouse].[DimDate] s ON f.[DimShippedDateSkey] = s.[DimDateSKey]
	INNER JOIN  
		[DataWarehouse].[datawarehouse].[DimDate] b ON f.[DimbilledDateSkey] = b.[DimDateSKey]
	INNER JOIN  
		[DataWarehouse].[datawarehouse].[DimDate] R ON f.[DimReceiptDateSKey] = r.[DimDateSKey]
	INNER JOIN  
		[DataWarehouse].[datawarehouse].[DimDiscount] d ON d.DimDiscountSKey = F.DimDiscountSKey
	--We Report on Billed Date, as if a Billed Date has a value of 9999-12-31 then this means there was an issue with the order such as "Card Declined"
	WHERE
		b.[CalendarDate] <> '9999-12-31'
	GROUP BY
		 F.DimCustomerAccountSKey 
		,F.FirstName +' '+ F.LastName 
		,F.AccountEmail 
		,ad.[Address1]
		,ad.[Address2]
		,ad.[City]
		,ad.[County]
		,ad.[Postcode]
		,sh.[Address1]
		,sh.[Address2]
		,sh.[City]
		,sh.[County]
		,sh.[Postcode]
		,F.ReceiptId
		,F.ReceiptItemId
		,P.ProductDescription
		,b.[CalendarDate]
		,b.[CalendarYearMonthDescription]
		,b.[CalendarYearNumber]
		,s.[CalendarDate] 
		,d.[DiscountCode]
	    ,f.[VoidItemId] 
),

	cte_Summarised
AS
(
	SELECT 
		 BilledYearMonth
		,[CurrentBilledMonth]					= CASE 
													 WHEN LEFT(BilledYearMonth,4) = @CurrentBilledYear AND CAST(RIGHT(BilledYearMonth,2)AS NVARCHAR(2)) = @CurrentBilledMonth
													 THEN 1
													 ELSE 0
												  END
		,MonthlyReturnsTotal					= SUM([Returns])  									
		,MonthlyTransactionalPriceTotal			= SUM([TransactionPrice])	
		,MonthlyTransactionDiscountTotal		= SUM([TransactionDiscountValue]) 
		,MonthlyASOSStaffDiscountExpenditure	= SUM([ASOSStaffDiscountPrice]) 
		,MonthlyItemsTotal						= SUM([QTY])		
		,MonthlyRemainingDiscount				= 700 - SUM([ASOSStaffDiscountPrice] - [Returns])	
	FROM cte_OrderDetails
	GROUP BY
		BilledYearMonth

)

SELECT 
	 s.[CurrentBilledMonth]
	,s.[BilledYearMonth]
	,s.[MonthlyRemainingDiscount]
	,s.[MonthlyASOSStaffDiscountExpenditure]
	,o.*
FROM
	cte_OrderDetails O
INNER JOIN
	cte_Summarised S ON O.BilledYearMonth = S.BilledYearMonth
ORDER BY
	O.BilledDate DESC
