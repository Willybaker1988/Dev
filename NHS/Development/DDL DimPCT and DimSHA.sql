--CREATE TABLE [Datawarehouse].[DimPrimaryCareTrust]
--(
--	[DimPrimaryCareTrustSkey]	INT IDENTITY(1,1),
--	[PrimaryTrustId]			varchar(3),
--	[PrimaryCareTrustName]		varchar(150) NULL,
--	[DateActiveFrom]			DATETIME,
--	[DimHealthAuthroritySkey]	INT

--)

create TABLE [Datawarehouse].[DimHealthAuthority]
(
	[DimHealthAuthroritySkey] INT IDENTITY(1,1),
	[HealthAuthorityId]	varchar(3),
	[HealthAuthorityName] varchar(150) NULL,
	[DateActiveFrom] DATETIME

)
