use Transform	

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE
	TABLE_CATALOG='transform'  --Database
AND
	TABLE_TYPE LIKE '%IWT%'	   --tables