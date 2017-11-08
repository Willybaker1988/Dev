

SELECT execution_id,status,
CASE  WHEN [status] = 1 THEN 'created'
    WHEN [status] = 2 THEN 'running'
    WHEN [status] = 3 THEN 'canceled'
    WHEN [status] = 4 THEN 'failed'
    WHEN [status] = 5 THEN 'pending'
    WHEN [status] = 6 THEN 'ended unexpectedly'
    WHEN [status] = 7 THEN 'succeeded'
    WHEN [status] = 8 THEN 'stopping'
    WHEN [status] = 9 THEN 'completed'
END AS [status_text]
,DATEDIFF(ss,start_time,end_time)DurationInSeconds
FROM  catalog.executions e
where execution_id = 50498