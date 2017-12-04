:setvar DATA_WAREHOUSE_DATABASE_NAME DataWarehouse
			
			
			;With
					cte_DimCountry
				as
				(

					SELECT 
						Min(DimCountrySKey) as DimCountrySKey, 
						ISO3D3166Code
					FROM 
						[$(DATA_WAREHOUSE_DATABASE_NAME)].[datawarehouse].[DimCountry]
					GROUP BY 
						ISO3D3166Code
							
				)

					--INSERT INTO 
					--		[$(DATA_WAREHOUSE_DATABASE_NAME)].[datawarehouse].[LookupShippingRestrictionCountry]



					SELECT DISTINCT
						DimCountrySKey = dc2.DimCountrySKey,
						ShippingRestrictionId
					FROM 
						[stage].[AsosReportShippingRestrictionCountryExclusion] SRE
					CROSS JOIN
						[datawarehouse].[udfTemplateDimCountry]() tdc
					LEFT OUTER JOIN 
						[stage].[AsosReportCountry] C ON C.CountryId = SRE.CountryId
					LEFT JOIN
						cte_DimCountry dc ON dc.ISO3D3166Code = C.ISOCountryCode
					INNER JOIN
						cte_DimCountry dc2 ON dc2.ISO3D3166Code =  COALESCE(dc.ISO3D3166Code, tdc.[ISO3D3166Code])


			
				
