DECLARE @TABLE TABLE
(
DimCustomerAccountSKey  INT
)

insert into @TABLE
VALUES (350876),(10531305),(36657565)

;With CteFilterFactOI
as
(
SELECT 
	F.DimCustomerAccountSKey,
	F.DimBillingAddressSKey,
	F.DimShippingAddressSKey,
	F.DimProductSKey,
	F.DimShippedDateSkey,
	F.DimbilledDateSkey,
	F.DimReceiptDateSKey,
	F.[DimFirstOrderDateSKey],
	F.ReceiptId  ,
	F.[ReceiptItemId],
	F.VoidItemId,
	F.TransactionPrice,
	F.TransactionDiscountValue,
	F.Units
FROM 
	[DataWarehouse].[datawarehouse].[FactOrderItem] F
INNER JOIN 
	@TABLE T ON F.DimCustomerAccountSKey = T.DimCustomerAccountSKey
)

SELECT 
	 DimCustomerAccountSKey		= 		 c.DimCustomerAccountSKey	
	,AccountEmail				=		 c.AccountEmail
	,FullName					=		 c.FirstName + ' ' + c.LastName 
	,divisiondescription		=		 p.divisiondescription
	,CategoryDescription		=		 p.CategoryDescription 
	,ColourDescription			=		 p.ColourDescription
	,[ProductDescription]		=		 p.[ProductDescription]
	,[ASOSSizeDescription]		=		 p.[ASOSSizeDescription]
	,ReceiptYear				=		 r.[CalendarYearNumber] 
	,ReceiptYearMonth			=		 r.[CalendarYearMonthDescription] 
	,WeekCommencingDate			=		 r.[CalendarWeekCommencingDate] 
	,ReceiptDate				=		 r.[CalendarDate] 
	,BilledYear					=		 b.[CalendarYearNumber] 
	,BilledYearMonth			=		 b.[CalendarYearMonthDescription]
	,BilledDate					=		 b.[CalendarDate] 
	,ShippedYear				=		 s.[CalendarYearNumber]   
	,ShippedYearMonth			=        s.[CalendarYearMonthDescription]  
	,ShippedDate				=		 s.[CalendarDate]	
	,[Returns]					=		 CASE 
											WHEN [VoidItemId]  = '-1' THEN 0 
											ELSE SUM(TransactionPrice) + SUM(TransactionDiscountValue) 
										 END 
	,TransactionPrice			=		 SUM(TransactionPrice)			
	,TransactionDiscountValue	=		 SUM(TransactionDiscountValue)  			
	,TransactionValueAfterDiscount  =    SUM(TransactionPrice) + SUM(TransactionDiscountValue) 
	,QTY						=		 SUM(Units)
	,DimAddressSKey				=		 ad.DimAddressSKey
	,Billed_Address1			=		 ad.[Address1]
	,Billed_Address2			=		 ad.[Address2]
	,Billed_City				=		 ad.[City]
	,Billed_County				=		 ad.[County] 
	,Billed_Postcode			=		 ad.[Postcode]		
	,Shipped_Address1			=		 sh.[Address1]
	,Shipped_Address2			=		 sh.[Address2]
	,Shipped_City				=		 sh.[City]
	,Shipped_County				=		 sh.[County]
	,Shipped_Postcode			=		 sh.[Postcode]	 
FROM 
	CteFilterFactOI F
INNER JOIN
	[DataWarehouse].[datawarehouse].[DimCustomerAccount] C ON F.DimCustomerAccountSKey = C.DimCustomerAccountSKey
INNER JOIN
	[DataWarehouse].[datawarehouse].[DimAddress] AD on F.DimBillingAddressSKey = AD.DimAddressSKey
INNER JOIN  
	[DataWarehouse].[datawarehouse].[DimAddress] SH on F.DimShippingAddressSKey = SH.DimAddressSKey
INNER JOIN  
	[DataWarehouse].[datawarehouse].[DimProduct] P on P.[DimProductSKey] = F.[DimProductSKey] 
INNER JOIN
	[DataWarehouse].[datawarehouse].[DimDate] S ON F.[DimShippedDateSkey] = S.[DimDateSKey]
INNER JOIN  
	[DataWarehouse].[datawarehouse].[DimDate] B ON F.[DimbilledDateSkey] = b.[DimDateSKey]
INNER JOIN  
	[DataWarehouse].[datawarehouse].[DimDate] R ON f.[DimReceiptDateSKey] = R.[DimDateSKey]
WHERE
	B.[CalendarDate] <> '9999-12-31'
GROUP BY
	  c.DimCustomerAccountSKey	
	 ,c.AccountEmail
	 ,c.FirstName + ' ' + c.LastName 
	 ,p.divisiondescription
	 ,p.CategoryDescription 
	 ,p.ColourDescription
	 ,p.[ProductDescription]
	 ,p.[ASOSSizeDescription]
	 ,r.[CalendarYearNumber] 
	 ,r.[CalendarYearMonthDescription] 
	 ,r.[CalendarWeekCommencingDate] 
	 ,r.[CalendarDate] 
	 ,b.[CalendarYearNumber] 
	 ,b.[CalendarYearMonthDescription]
	 ,b.[CalendarDate] 
	 ,s.[CalendarYearNumber]   
	 ,s.[CalendarYearMonthDescription]  
	 ,s.[CalendarDate]	
	 ,ad.DimAddressSKey
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
	 ,[VoidItemId]

