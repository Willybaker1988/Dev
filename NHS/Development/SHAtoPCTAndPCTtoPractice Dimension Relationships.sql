/*
Defining the hierarchy

	1. SHA TO PCT relationship - 1 to many.
	2. PCT TO Practive  1- to - many 


*/


/*
1.				Test Results to define SHA TO PCT relationship - 1 to many.
*/

SELECT top 10
		[SHA]
      , count( distinct [PCT])
     -- ,[PRACTICE]

  FROM [NHS].[Stage].[Prescription]
  group by [SHA] 
 --having count( distinct [PCT]) desc
   ORDER BY count( distinct [PCT]) desc


   
SELECT top 10
		[PCT]
      , count( distinct [SHA])
     -- ,[PRACTICE]

  FROM [NHS].[Stage].[Prescription]
  group by [PCT] 
 --having count( distinct [PCT]) desc
   ORDER BY count( distinct [SHA]) desc


/*
2.				Test Results to define SHA TO PCT relationship - 1 to many.
*/



SELECT top 10
		[PCT]
      , count( distinct [PRACTICE])
     -- ,[PRACTICE]

  FROM [NHS].[Stage].[Prescription]
  group by [PCT] 
 --having count( distinct [PCT]) desc
   ORDER BY count( distinct [PRACTICE]) desc

SELECT top 10
		[PRACTICE]
      , count( distinct PCT)
     -- ,[PRACTICE]

  FROM [NHS].[Stage].[Prescription]
  group by [PRACTICE] 
 --having count( distinct [PCT]) desc
   ORDER BY count( distinct PCT) desc






