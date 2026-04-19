WITH team_round_points AS (
    SELECT 
        round_number,
        event_name,
        team_name,
        SUM(points) AS weekend_points
    FROM {{ source('f1_data', 'raw_f1_results') }}
    GROUP BY 
        1, 2, 3
)
SELECT
    round_number,
    event_name,
    team_name,
    weekend_points,
    SUM(weekend_points) OVER (
        PARTITION BY team_name 
        ORDER BY round_number ASC
    ) AS cumulative_points
FROM team_round_points
ORDER BY round_number ASC, cumulative_points DESC