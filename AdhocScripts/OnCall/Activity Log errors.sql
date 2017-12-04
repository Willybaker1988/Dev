use DIFramework
--Activity Log errors
SELECT
	*
FROM
	datawarehouse.ActivityLog
WHERE
	Step IN ('Failed','Errored')
	OR Remark like 'Duplicates found in%'
ORDER BY 
	1 DESC

SELECT
	*
FROM
	datawarehouse.ActivityLog
ORDER BY 
	1 DESC


