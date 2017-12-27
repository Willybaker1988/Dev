USE [NHS]
GO

print 'Creating NHS objects Indexes'

SET ANSI_PADDING ON
GO

/****** Object:  Index [unq_GPId_PrimaryTrustId]    Script Date: 19/12/2017 12:23:53 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_GPId_PrimaryTrustId] ON [Transform].[LookupPCTToGeneralPractice]
(
	[GPId] ASC,
	[PrimaryTrustId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_GPId_PrimaryTrustId] ON [Transform].[LookupPCTToGeneralPractice]'

GO

/****** Object:  Index [unq_GPId_FileLogId]    Script Date: 19/12/2017 12:24:56 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_GPId_FileLogId] ON [Transform].[DimGeneralPracticeAddress]
(
	[GPId] ASC,
	[FileLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_GPId_FileLogId] ON [Transform].[DimGeneralPracticeAddress]'

GO

/****** Object:  Index [unq_Code]    Script Date: 19/12/2017 12:26:50 ******/
CREATE CLUSTERED INDEX [unq_Code] ON [Stage].[ReferenceTrustCodesAndTrustNames]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_Code] ON [Stage].[ReferenceTrustCodesAndTrustNames]'

GO

/****** Object:  Index [unq_CCGCode]    Script Date: 19/12/2017 12:27:36 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_CCGCode] ON [Stage].[ReferenceCCGCodesAndCCGNames]
(
	[CCGCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


print '...Created [unq_Code] ON [Stage].[ReferenceTrustCodesAndTrustNames]'


GO

/****** Object:  Index [unq_SHA_PCT_PRACTICE_BNFCODE_PERIOD]    Script Date: 19/12/2017 12:29:11 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_SHA_PCT_PRACTICE_BNFCODE_PERIOD] ON [Stage].[Prescription]
(
	[SHA] ASC,
	[PCT] ASC,
	[PRACTICE] ASC,
	[BNFCODE] ASC,
	[PERIOD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_SHA_PCT_PRACTICE_BNFCODE_PERIOD] ON [Stage].[Prescription]'

GO

/****** Object:  Index [unq_PERIOD_GPId]    Script Date: 19/12/2017 12:30:12 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_PERIOD_GPId] ON [Stage].[GPAddress]
(
	[PERIOD] ASC,
	[GPId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_PERIOD_GPId] ON [Stage].[GPAddress]'

GO

/****** Object:  Index [unq_CHEMSUBId_PERIOD]    Script Date: 19/12/2017 12:31:19 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_CHEMSUBId_PERIOD] ON [Stage].[ChemicalSubstance]
(
	[CHEMSUBId] ASC,
	[PERIOD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_CHEMSUBId_PERIOD] ON [Stage].[ChemicalSubstance]'


GO

/****** Object:  Index [unq_SHA_PCT_GPId_BNFCode_ChemicalSubstanceId_PeriodId]    Script Date: 19/12/2017 12:32:53 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_SHA_PCT_GPId_BNFCode_ChemicalSubstanceId_PeriodId] ON [Mirror].[FactPrescription]
(
	[SHA] ASC,
	[PCT] ASC,
	[GPId] ASC,
	[BNFCode] ASC,
	[ChemicalSubstanceId] ASC,
	[PeriodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_SHA_PCT_GPId_BNFCode_ChemicalSubstanceId_PeriodId] ON [Mirror].[FactPrescription]'

GO

/****** Object:  Index [unq_ProductId_ProductName]    Script Date: 19/12/2017 12:33:41 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_ProductId_ProductName] ON [Mirror].[DimProduct]
(
	[ProductId] ASC,
	[ProductName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


print '...Created [unq_ProductId_ProductName] ON [Mirror].[DimProduct]'

GO

/****** Object:  Index [unq_GPId]    Script Date: 19/12/2017 12:34:19 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_GPId] ON [Mirror].[DimGeneralPracticeAddress]
(
	[GPId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


print '...Created [unq_GPId] ON [Mirror].[DimGeneralPracticeAddress]'

GO

/****** Object:  Index [unq_CHEMSUBId_PERIOD]    Script Date: 19/12/2017 12:35:10 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_CHEMSUBId_PERIOD] ON [Mirror].[ChemicalSubstance]
(
	[CHEMSUBId] ASC,
	[PERIOD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_CHEMSUBId_PERIOD] ON [Mirror].[ChemicalSubstance]'

GO

/****** Object:  Index [unq_DimPeriodSkey_DimHealthAuthoritySkey_DimPrimaryTrustSkey_DimGeneralPracticeSkey_DimProductSkey_DimProductTypeSkey]    Script Date: 19/12/2017 12:36:21 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_DimPeriodSkey_DimHealthAuthoritySkey_DimPrimaryTrustSkey_DimGeneralPracticeSkey_DimProductSkey_DimProductTypeSkey] ON [Datawarehouse].[FactPrescription]
(
	[DimPeriodSKey] ASC,
	[DimHealthAuthroritySkey] ASC,
	[DimPrimaryCareTrustSkey] ASC,
	[DimGeneralPracticeSKey] ASC,
	[DimProductSkey] ASC,
	[DimProductTypeSkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_DimPeriodSkey_DimHealthAuthoritySkey_DimPrimaryTrustSkey_DimGeneralPracticeSkey_DimProductSkey_DimProductTypeSkey] ON [Datawarehouse].[FactPrescription]'

GO

/****** Object:  Index [unq_DimProductTypeSkey]    Script Date: 19/12/2017 12:37:00 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_DimProductTypeSkey] ON [Datawarehouse].[DimProductType]
(
	[DimProductTypeSkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_DimProductTypeSkey] ON [Datawarehouse].[DimProductType]'


GO

/****** Object:  Index [unq_DimProductSkey_DimProductTypeSkey]    Script Date: 19/12/2017 12:38:10 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_DimProductSkey_DimProductTypeSkey] ON [Datawarehouse].[DimProduct]
(
	[DimProductSkey] ASC,
	[DimProductTypeSkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_DimProductSkey_DimProductTypeSkey] ON [Datawarehouse].[DimProduct]'

GO

/****** Object:  Index [unq_DimPrimaryCareTrust]    Script Date: 19/12/2017 12:38:49 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_DimPrimaryCareTrust] ON [Datawarehouse].[DimPrimaryCareTrust]
(
	[DimPrimaryCareTrustSkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


print '...Created [unq_DimPrimaryCareTrust] ON [Datawarehouse].[DimPrimaryCareTrust]'


GO

/****** Object:  Index [unq_DimHealthAuthority]    Script Date: 19/12/2017 12:39:37 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_DimHealthAuthority] ON [Datawarehouse].[DimHealthAuthority]
(
	[DimHealthAuthroritySkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


print '...Created [unq_DimHealthAuthority] ON [Datawarehouse].[DimHealthAuthority]'


GO

/****** Object:  Index [unq_DimGeneralPracticeAddress]    Script Date: 19/12/2017 12:40:48 ******/
CREATE UNIQUE CLUSTERED INDEX [unq_DimGeneralPracticeAddress] ON [Datawarehouse].[DimGeneralPracticeAddress]
(
	[DimGeneralPracticeSKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

print '...Created [unq_DimGeneralPracticeAddress] ON [Datawarehouse].[DimGeneralPracticeAddress]'

