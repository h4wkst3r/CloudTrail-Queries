SELECT 
    e1.userIdentity.arn, 
    e1.sourceIpAddress, 
    COUNT(DISTINCT e1.eventName) AS event_count,
    MIN(e1.eventTime) AS first_event_time,
    MAX(e1.eventTime) AS last_event_time
FROM 
    [EVENT_DATA_STORE_GUID] e1
JOIN 
    [EVENT_DATA_STORE_GUID] e2
ON 
    e1.userIdentity.arn = e2.userIdentity.arn 
    AND e1.sourceIpAddress = e2.sourceIpAddress
    AND e1.eventName <> e2.eventName
    AND abs(date_diff('hour', e1.eventTime, e2.eventTime)) <= 24
WHERE 
    e1.eventName IN ('ListModels', 'DescribeModel', 'GetBucketVersioning', 'GetObject')
    AND e2.eventName IN ('ListModels', 'DescribeModel', 'GetBucketVersioning', 'GetObject')
    AND e1.userIdentity.arn <> ''
GROUP BY 
    e1.userIdentity.arn, 
    e1.sourceIpAddress
HAVING 
    COUNT(DISTINCT e1.eventName) = 4
ORDER BY 
    last_event_time DESC;
