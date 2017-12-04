DECLARE @TABLE TABLE
(
DimCustomerAccountSKey  INT
)

insert into @TABLE
VALUES (350876),(10531305),(36657565)



;with cte_DimCustomerAccount AS
(
select D.*
FROM [DataWarehouse].[datawarehouse].[DimCustomerAccount] D
inner join @TABLE T ON D.DimCustomerAccountSKey = T.DimCustomerAccountSKey
--where [DimCustomerAccountSKey]  in (@DimCustomerAccountSKey)
),

cte_CustAccountStartDate AS
(
select C.*, D.[CalendarDate] AS CustAccountStartDate from cte_DimCustomerAccount c
inner join (select DimCustomerAccountSKey, dimaccountregistereddateskey, D.[CalendarDate] fROM [DataWarehouse].[datawarehouse].[DimCustomerAccount] c
   INNER JOIN [DataWarehouse].[datawarehouse].[DimDate] d ON C.dimaccountregistereddateskey = D.[DimDateSKey]) D ON C.DimCustomerAccountSKey = D.DimCustomerAccountSKey
    
),


cte_FactOrderItem AS
(
SELECT [DimItemLifeUpdateDateSKey]
      ,[DimReceiptDateSKey]
      ,[DimBilledDateSKey]
      ,[DimShippedDateSKey]
      ,[DimVoidDateSKey]
      ,[DimCancelledDateSKey]
      ,[DimReturnDateSKey]
      ,[DimUnexpectedVoidDateSKey]
      ,[DimItemLifeUpdateTimeSKey]
      ,[DimReceiptTimeSKey]
      ,[DimBilledTimeSKey]
      ,[DimShippedTimeSKey]
      ,[DimVoidTimeSKey]
      ,[DimCancelledTimeSKey]
      ,[DimReturnTimeSKey]
      ,[DimUnexpectedVoidTimeSKey]
      ,[DimCustomerOrderLineItemTypeSKey]
      ,f.[DimCustomerAccountSKey]
      ,[DimCustomerAccountBehaviourSKey]
      ,[DimProductSKey]
      ,[DimProductStatusSKey]
      ,[DimSiteSKey]
      ,[DimBillingAddressSKey]
      ,[DimShippingAddressSKey]
      ,[DimShippingCountrySKey]
      ,[DimShippingCarrierMethodSKey]
      ,[DimTransactionCurrencySKey]
      ,[DimSupplierSKey]
      ,[DimAffiliateSKey]
      ,[DimPaymentMethodSKey]
      ,[DimPaymentTypeSKey]
      ,[DimDiscountSKey]
      ,[DimBasketPricePointSKey]
      ,[DimBackOfficeOriginalRetailPricePointSKey]
      ,[DimItemPricePointSKey]
      ,[DimCustomerOrderTypeSKey]
      ,[DimCustomerVoidTypeSKey]
      ,[DimCustomerOrderStatusSKey]
      ,[DimZoneSKey]
      ,[DimZoneCurrencySKey]
      ,[DimUKPriceStatusSKey]
      ,[DimZonePriceStatusSKey]
      ,[DimUKVoidPriceStatusSKey]
      ,[DimZoneVoidPriceStatusSKey]
      ,[DimPricingEventSKey]
      ,[DimUKPricingEventSKey]
      ,[DimBulletinSKey]
      ,[DimCustomerBasketSizeSKey]
      ,[DimBilledCashDirectionSKey]
      ,[DimVoidCashDirectionSKey]
      ,[DimFulfilmentCentreSKey]
      ,[DimVoidFaultActionReasonSKey]
      ,[DimReturnFulfilmentCentreSKey]
      ,[DimCustomerAgeSKey]
      ,[TransactionCurrencyBaseRate]
      ,[TransactionCurrencySellingRate]
      ,[Units]
      ,[TransactionPrice]
      ,[BackOfficeOriginalRetailPrice]
      ,[VATRate]
      ,[ActualTaxRate]
      ,[RealTaxRate]
      ,[UKPrice]
      ,[ZonePrice]
      ,[PricingUKPrice]
      ,[PricingZonePrice]
      ,[IsStockReturn]
      ,[IsDiscountExempt]
      ,[ZoneCurrencySellingRate]
      ,[IsFreeShipped]
      ,[IsFreeReturn]
      ,[IsCollectionReturn]
      ,[IsPremierCustomer]
      ,[IsSuccessfulOrder]
      ,[IsReplacement]
      ,[DimFirstItemShippedDateSKey]
      ,[DimFirstOrderDateSKey]
      ,[ZonalConversionFactor]
      ,[UnitCost]
      ,[AverageWeightedLandedCost]
      ,[ShippedAverageWeightedLandedCost]
      ,[PercentDiscountAvailable]
      ,[DiscountPercentage]
      ,[TransactionDiscountValue]
      ,[ZoneDiscountValue]
      ,[UKDiscountValue]
      ,[ReceiptToShippedMinutes]
      ,[ReturnPeriodDays]
      ,[ZoneFromPrice]
      ,[UKFromPrice]
      ,[ZoneFirstFullPrice]
      ,[UKFirstFullPrice]
      ,[ZoneLastFullPrice]
      ,[UKLastFullPrice]
      ,[IsBrandPriceProtected]
      ,[IsProductPriceProtected]
      ,[BaseReceiptId]
      ,[OrderReference]
      ,[ReceiptId]
      ,[ReceiptItemId]
      ,[ReceiptDropId]
      ,[ReceiptShippingSubscriptionId]
      ,[ReceiptVoucherId]
      ,[ShippingSubscriptionTypeId]
      ,[OrderHasVoid]
      ,[VoidHeaderId]
      ,[VoidItemId]
      ,[BilledPOSItemId]
      ,[VoidPOSItemId]
      ,[BilledPaymentLedgerId]
      ,[VoidPaymentLedgerId]
      ,[CreatedByLogID]
      ,[LastModifiedByLogID]
  FROM [DataWarehouse].[datawarehouse].[FactOrderItem] f
  inner join @TABLE t ON f.DimCustomerAccountSKey = T.DimCustomerAccountSKey
)
,


cte_CustOrders
as
(

SELECT DimCustomerAccountSKey, FirstName +' '+LastName as AccountName,AccountEmail ,
Billed_Address1 ,Billed_Address2 ,Billed_City ,Billed_County , Billed_Postcode,
CASE 
 WHEN Shipped_Postcode =  'LE9 6PW' THEN 'Jak Yeates' 
 WHEN Shipped_Postcode =  'LE7 2DL' THEN 'Sean Noon' Else FirstName +' '+LastName 
end as ShippedTo,
Shipped_Address1, Shipped_Address2 ,Shipped_City ,Shipped_County , Shipped_Postcode,
ReceiptId, ReceiptItemId , divisiondescription, CategoryDescription, ColourDescription , [ProductDescription], [ASOSSizeDescription], 
ReceiptYear,ReceiptYearMonth ,WeekCommencingDate, ReceiptDate,
BilledYear,  BilledYearMonth, BilledDate, ShippedDate, DiscountCode,
CASE 
 WHEN [VoidItemId]  = '-1' THEN 0 ELSE sum(TransactionPrice) + sum(TransactionDiscountValue) 
end AS [Returns],
sum(TransactionPrice) as TransactionPrice, sum(TransactionDiscountValue) as TransactionDiscountValue ,
sum(TransactionPrice) + sum(TransactionDiscountValue) as TransactionValueAfterDiscount, Sum(Units) as QTY

FROM 
(

 SELECT a.DimCustomerAccountSKey, a.CustAccountStartDate ,a.FirstName, a.LastName, a.AccountEmail, 
  --f.*, 
 p.divisiondescription, p.CategoryDescription, p.ColourDescription , p.[ProductDescription], p.[ASOSSizeDescription],
 r.[CalendarYearNumber] as ReceiptYear , r.[CalendarYearMonthDescription] as ReceiptYearMonth,  r.[CalendarWeekCommencingDate] as WeekCommencingDate, r.[CalendarDate] as ReceiptDate,
 b.[CalendarYearNumber] as BilledYear , b.[CalendarYearMonthDescription] as BilledYearMonth,b.[CalendarDate] as BilledDate, b.[DimDateSKey] as BilledDateSkey,
 s.[CalendarYearNumber] as ShippedYear , s.[CalendarYearMonthDescription] as ShippedYearMonth, s.[CalendarDate] as ShippedDate, s.[DimDateSKey] as ShippedDateSkey,
 F.[DimFirstOrderDateSKey] , F.TransactionPrice, F.TransactionDiscountValue, F.Units, F.ReceiptId, F.[ReceiptItemId], F.[VoidItemId],
 ad.DimAddressSKey, D.DiscountCode,
 ad.[Address1] as Billed_Address1 ,ad.[Address2] as Billed_Address2 ,ad.[City] as Billed_City ,ad.[County] as Billed_County ,ad.[Postcode] as Billed_Postcode,
 sh.[Address1]  as Shipped_Address1, sh.[Address2] as Shipped_Address2 ,sh.[City] as Shipped_City ,sh.[County] as Shipped_County ,sh.[Postcode] as Shipped_Postcode
 FROM cte_CustAccountStartDate A
 INNER JOIN cte_FactOrderItem F on a.DimCustomerAccountSKey = f.DimCustomerAccountSKey
 INNER JOIN  [DataWarehouse].[datawarehouse].[DimAddress] ad  on f.DimBillingAddressSKey = ad.DimAddressSKey
 INNER JOIN  [DataWarehouse].[datawarehouse].[DimAddress] sh  on f.DimShippingAddressSKey = sh.DimAddressSKey
 INNER JOIN  [DataWarehouse].[datawarehouse].[DimProduct] p on p.[DimProductSKey] = f.[DimProductSKey] 
 INNER JOIN  [DataWarehouse].[datawarehouse].[DimDate] s ON f.[DimShippedDateSkey] = s.[DimDateSKey]
 INNER JOIN  [DataWarehouse].[datawarehouse].[DimDate] b ON f.[DimbilledDateSkey] = b.[DimDateSKey]
 INNER JOIN  [DataWarehouse].[datawarehouse].[DimDate] R ON f.[DimReceiptDateSKey] = r.[DimDateSKey]
 INNER JOIN  [DataWarehouse].[datawarehouse].[DimDiscount] d ON d.DimDiscountSKey = F.DimDiscountSKey
 --We Report on Billed Date, as if a Billed Date has a value of 9999-12-31 then this means there was an issue with the order such as "Card Declined"
 where b.[CalendarDate] <> '9999-12-31'
 --where F.ReceiptId = 207148573
)d
group by DimCustomerAccountSKey, FirstName +' '+LastName ,AccountEmail ,
Billed_Address1 ,Billed_Address2 ,Billed_City ,Billed_County , Billed_Postcode,
CASE 
 WHEN Shipped_Postcode =  'LE9 6PW' THEN 'Jak Yeates' 
 WHEN Shipped_Postcode =  'LE7 2DL' THEN 'Sean Noon' Else FirstName +' '+LastName 
end ,
Shipped_Address1, Shipped_Address2 ,Shipped_City ,Shipped_County , Shipped_Postcode,
ReceiptId, ReceiptItemId , divisiondescription, CategoryDescription, ColourDescription , [ProductDescription], [ASOSSizeDescription], 
ReceiptYear,ReceiptYearMonth ,WeekCommencingDate, ReceiptDate,
BilledYear,  BilledYearMonth, BilledDate, ShippedDate, DiscountCode ,[VoidItemId]
)


SELECT *, '('+COALESCE(CAST(DimCustomerAccountSkey AS  NVARCHAR(25)), '') + '||' + 
COALESCE(CAST(Receiptitemid AS NVARCHAR(25)), '') + '||' + 
COALESCE(CAST(Receiptitemid AS NVARCHAR(25)), '') + '||' + 
COALESCE(CAST(REPLACE(billeddate,'-','') AS NVARCHAR(25)), '') + '||' + 
COALESCE(CAST(REPLACE(Shipped_Postcode,' ','') AS NVARCHAR(25)), '')+')' as Skey
FROM cte_CustOrders
