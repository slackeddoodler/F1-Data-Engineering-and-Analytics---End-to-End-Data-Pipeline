SELECT 
    r.event_name,
    r.session_type,
    r.full_name AS DriverName,
    r.team_name,
    l.compound,
    CAST(l.stint AS INTEGER) AS stint,
    CAST(l.tyre_life AS INTEGER) AS tyre_life,
    CAST(l.lap_number AS INTEGER) AS lap_number,
    EXTRACT(EPOCH FROM l.lap_time) AS lap_time_seconds
FROM {{ source('f1_data', 'raw_f1_results') }} r
JOIN {{ source('f1_data', 'raw_f1_laps') }} l 
    ON r.driver_number = l.driver_number 
    AND r.round_number = l.round_number 
    AND r.session_type = l.session_type
WHERE r.session_type = 'Race'
  AND l.is_accurate = TRUE
  AND l.compound IS NOT NULL
  AND l.lap_time IS NOT NULL