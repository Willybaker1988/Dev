/*
	Convert BLANKS in attributes to NULLs for Transformation from Staging to Datwarehouse
*/

DECLARE @Updatecounter INT

UPDATE [NHS].[Stage].[GPAddress]
SET Address1 = NULL
WHERE Address1 = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS Address1


UPDATE [NHS].[Stage].[GPAddress]
SET Address2 = NULL
WHERE Address2 = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS Address2


UPDATE [NHS].[Stage].[GPAddress]
SET Address3 = NULL
WHERE Address3 = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS Address3

UPDATE [NHS].[Stage].[GPAddress]
SET name = NULL
WHERE name = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS name

UPDATE [NHS].[Stage].[GPAddress]
SET gpsurgeryname = NULL
WHERE gpsurgeryname = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS gpsurgeryname

UPDATE [NHS].[Stage].[GPAddress]
SET postcode = NULL
WHERE postcode = '                         '

SET @Updatecounter = @@ROWCOUNT
SELECT @Updatecounter AS postcode

