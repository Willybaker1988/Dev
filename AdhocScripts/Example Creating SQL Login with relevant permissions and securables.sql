USE [master]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [AdobeEDWETLUser]    Script Date: 17/01/2017 08:44:01 ******/
CREATE LOGIN [AdobeEDWETLUser] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [AdobeEDWETLUser] DISABLE
GO


USE [AdobeAnalyticsReportOds]
GO

/****** Object:  User [AdobeEDWETLUser]    Script Date: 17/01/2017 08:45:26 ******/
CREATE USER [AdobeEDWETLUser] FOR LOGIN [AdobeEDWETLUser] WITH DEFAULT_SCHEMA=[dbo]
GO

GRANT SELECT ON ApplicationExtract.Channel TO AdobeEDWETLUser
GRANT SELECT ON dbo.ProductViewCount TO AdobeEDWETLUser
GRANT VIEW DEFINITION ON ApplicationExtract.Channel TO AdobeEDWETLUser
GRANT VIEW DEFINITION ON dbo.ProductViewCount TO AdobeEDWETLUser


