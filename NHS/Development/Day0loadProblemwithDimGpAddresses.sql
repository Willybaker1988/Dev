
/*

Will always have a problem with Day0 loads into [NHS].[Datawarehouse] [DimGeneralPracticeAddress], we won't persist historic records and will just load the latest.

Would need to change the logic in Mirror phase to process files in batches therfore persisting history into the Dim

*/


SELECT t.*
FROM
	[NHS].[Transform].[DimGeneralPracticeAddress] t
INNER JOIN
(
		SELECT 
			 GPId,
			 COUNT(DISTINCT PostCode) as Dups
		FROM  [NHS].[Transform].[DimGeneralPracticeAddress] --ORDER BY GPId
		GROUP BY  GPId
		HAVING COUNT(DISTINCT PostCode) > 1
)d
on d.GPId = t.GPId
order by GPId

use NHS;
sp_help '[NHS].[Transform].[DimGeneralPracticeAddress]';
go
sp_help '[NHS].[Mirror].[DimGeneralPracticeAddress]';
go