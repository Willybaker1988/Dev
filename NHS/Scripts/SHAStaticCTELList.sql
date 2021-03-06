/*
References for SHAs lised below
http://www.england.nhs.uk/statistics/cancelled-elective-operations/cancelled-ops-data/
*/
;WITH 
	CTE_SHA
AS
(
		SELECT  'Q39' AS [SHACODE] , 'SOUTH WEST STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q36' AS [SHACODE], 	'LONDON STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q34'  AS [SHACODE],  'WEST MIDLANDS STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q38'  AS [SHACODE], 	'SOUTH CENTRAL STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q30'  AS [SHACODE], 	'NORTH EAST STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q32' AS [SHACODE], 	'YORKSHIRE AND THE HUMBER STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q33' AS [SHACODE], 	'EAST MIDLANDS STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q31' AS [SHACODE], 	'NORTH WEST STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q35' AS [SHACODE], 	'EAST OF ENGLAND STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT'Q37' AS [SHACODE], 	'SOUTH EAST COAST STRATEGIC HEALTH AUTHORITY' AS [SHANAME]
		UNION ALL
		SELECT 'Q99' AS [SHACODE], 	'WALES LHB' AS [SHANAME]
		UNION ALL
		SELECT 'Q44' as [SHACODE],	'CHESHIRE, WARRINGTON AND WIRRAL AREA TEAM'									   as [SHANAME] 
		UNION ALL
		SELECT 'Q45' as [SHACODE],	'DURHAM, DARLINGTON AND TEES AREA TEAM'										   as [SHANAME] 
		UNION ALL
		SELECT 'Q46' as [SHACODE],	'GREATER MANCHESTER AREA TEAM'												   as [SHANAME] 
		UNION ALL
		SELECT 'Q47' as [SHACODE],	'LANCASHIRE AREA TEAM'														   as [SHANAME] 
		UNION ALL
		SELECT 'Q48' as [SHACODE],	'MERSEYSIDE AREA TEAM'														   as [SHANAME] 
		UNION ALL
		SELECT 'Q49' as [SHACODE],	'CUMBRIA, NORTHUMBERLAND, TYNE AND WEAR AREA TEAM'							   as [SHANAME] 
		UNION ALL
		SELECT 'Q50' as [SHACODE],	'NORTH YORKSHIRE AND HUMBER AREA TEAM'										   as [SHANAME] 
		UNION ALL
		SELECT 'Q51' as [SHACODE],	'SOUTH YORKSHIRE AND BASSETLAW AREA TEAM'									   as [SHANAME] 
		UNION ALL
		SELECT 'Q52' as [SHACODE],	'WEST YORKSHIRE AREA TEAM'													   as [SHANAME] 
		UNION ALL
		SELECT 'Q53' as [SHACODE],	'ARDEN, HEREFORDSHIRE AND WORCESTERSHIRE AREA TEAM'							   as [SHANAME] 
		UNION ALL
		SELECT 'Q54' as [SHACODE],	'BIRMINGHAM AND THE BLACK COUNTRY AREA TEAM'								   as [SHANAME] 
		UNION ALL
		SELECT 'Q55' as [SHACODE],	'DERBYSHIRE AND NOTTINGHAMSHIRE AREA TEAM'									   as [SHANAME] 
		UNION ALL
		SELECT 'Q56' as [SHACODE],	'EAST ANGLIA AREA TEAM'														   as [SHANAME] 
		UNION ALL
		SELECT 'Q57' as [SHACODE],	'ESSEX AREA TEAM'															   as [SHANAME] 
		UNION ALL
		SELECT 'Q58' as [SHACODE],	'HERTFORDSHIRE AND THE SOUTH MIDLANDS AREA TEAM'							   as [SHANAME] 
		UNION ALL
		SELECT 'Q59' as [SHACODE],	'LEICESTERSHIRE AND LINCOLNSHIRE AREA TEAM'									   as [SHANAME] 
		UNION ALL
		SELECT 'Q60' as [SHACODE],	'SHROPSHIRE AND STAFFORDSHIRE AREA TEAM'									   as [SHANAME]
		 UNION ALL
		SELECT 'Q64' as [SHACODE],	'BATH, GLOUCESTERSHIRE, SWINDON AND WILTSHIRE AREA TEAM'					   as [SHANAME] 
		UNION ALL
		SELECT 'Q65' as [SHACODE],	'BRISTOL, NORTH SOMERSET, SOMERSET AND SOUTH GLOUCESTERSHIRE AREA TEAM'		   as [SHANAME] 
		UNION ALL
		SELECT 'Q66' as [SHACODE],	'DEVON, CORNWALL AND ISLES OF SCILLY AREA TEAM'								   as [SHANAME] 
		UNION ALL
		SELECT 'Q67' as [SHACODE],	'KENT AND MEDWAY AREA TEAM'													   as [SHANAME] 
		UNION ALL
		SELECT 'Q68' as [SHACODE],	'SURREY AND SUSSEX AREA TEAM'												   as [SHANAME] 
		UNION ALL
		SELECT 'Q69' as [SHACODE],	'THAMES VALLEY AREA TEAM'													   as [SHANAME] 
		UNION ALL
		SELECT 'Q70' as [SHACODE],	'WESSEX AREA TEAM'															   as [SHANAME] 
		UNION ALL
		SELECT 'Q71' as [SHACODE],	'LONDON AREA TEAM'															   as [SHANAME] 

)

SELECT 
	 SHA.DimHealthAuthroritySkey
	,SHA.HealthAuthorityId
	,HealthAuthorityName			= COALESCE(C.SHANAME,'UNDEFINED')
	,SHA.DateActiveFrom
FROM nhs.Datawarehouse.DimHealthAuthority SHA
LEFT OUTER JOIN CTE_SHA C ON SHA.HealthAuthorityId = C.SHACODE