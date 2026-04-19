WITH round_points AS (
    SELECT 
        lap_number,
        event_name,
        driver_number,
        full_name AS driver_name,
        team_name,
        SUM(points) AS weekend_points
    FROM {{ source('f1_data', 'raw_f1_results') }}
    GROUP BY 
        1, 2, 3, 4, 5
)
SELECT
    round_number,
    event_name,
    driver_name,
    team_name,
    weekend_points,
    SUM(weekend_points) OVER (
        PARTITION BY driver_number 
        ORDER BY round_number ASC
    ) AS cumulative_points
FROM round_points
ORDER BY round_number ASC, cumulative_points DESC