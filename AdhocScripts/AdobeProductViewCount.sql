CREATE TABLE [stage].[AdobeProductViewCount]
(
	ChannelId TINYINT,
	TimeSliceId BIGINT,
	ViewCountDate DATETIME2,
	ProductID VARCHAR(80),
	ViewCount INT,
	DataUTCCreated DATETIME2,
	DataUTCModified DATETIME2
)
