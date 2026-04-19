SELECT 
    r.event_name,
    r.full_name AS driver_name,
    r.team_name,
    CAST(r.position AS INTEGER) AS final_position,
    COUNT(l.lap_number) AS clean_laps_completed,
    MIN(EXTRACT(EPOCH FROM l.lap_time)) AS fastest_lap_seconds,
    AVG(EXTRACT(EPOCH FROM l.lap_time)) AS avg_lap_time_seconds,
    STDDEV(EXTRACT(EPOCH FROM l.lap_time)) AS lap_time_variance
FROM {{ source('f1_data', 'raw_f1_results') }} r
JOIN {{ source('f1_data', 'raw_f1_laps') }} l 
    ON r.driver_number = l.driver_number 
    AND r.round_number = l.round_number 
    AND r.session_type = l.session_type
WHERE r.session_type = 'Race'
  AND l.is_accurate = TRUE 
  AND l.track_status = '1'
GROUP BY 
    1, 2, 3, 4
HAVING COUNT(l.lap_number) > 10