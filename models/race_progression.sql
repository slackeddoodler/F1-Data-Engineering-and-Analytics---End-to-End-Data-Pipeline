SELECT 
    r.event_name,
    r.full_name AS driver_name,
    r.team_name,
    r.team_color,
    CAST(r.grid_position AS INTEGER) AS grid_position,
    CAST(r.position AS INTEGER) AS final_position,
    CAST(l.lap_number AS INTEGER) AS lap_number,
    CAST(l.position AS INTEGER) AS lap_position,
    l.track_status
FROM {{ source('f1_data', 'raw_f1_results') }} r
JOIN {{ source('f1_data', 'raw_f1_laps') }} l 
    ON r.driver_number = l.driver_number 
    AND r.round_number = l.round_number 
    AND r.session_type = l.session_type
WHERE r.session_type = 'Race'
  AND l.position IS NOT NULL
ORDER BY l.lap_number, l.position