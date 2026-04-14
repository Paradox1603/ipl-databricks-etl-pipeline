--Batsmen Performance
SELECT
    batsman_name,
    SUM(runs_scored) AS total_runs,
    COUNT(ball_id) AS balls_faced,
    ROUND(
        (SUM(runs_scored) / COUNT(ball_id) * 100)
        ,2) AS strike_rate
FROM   silver_level_ipl_data
WHERE  lower(extra_type) = 'no extras'
GROUP BY batsman_name
ORDER BY total_runs DESC


--Bowlers Performance
SELECT
    bowler_name,
    SUM(runs_scored + bowler_extras) AS runs_conceded,
    SUM(CASE WHEN bowler_wicket THEN 1 ELSE 0 END) AS wickets_taken,
    COUNT(ball_id) AS balls_bowled,
    ROUND(
        COUNT(ball_id) / 6
        ,2)
        AS overs_bowled,
    ROUND(
        SUM(runs_scored + bowler_extras) * 6 / (COUNT(ball_id) )
        ,2) As economy_rate
FROM    silver_level_ipl_data
GROUP BY bowler_name
HAVING (COUNT(ball_id) / 6) > 10
ORDER BY wickets_taken DESC, economy_rate


--Match Summary
SELECT
    match_id,
    MAX(season_year) AS season_year,
    SUM(runs_scored + extra_runs) AS total_match_runs,
    MAX(team1) AS team1,
    MAX(team2) AS team2,
    (
        MAX(match_winner) || 
        ' won by ' || 
        MAX(win_margin) ||' '|| 
        MAX(win_type)
    ) AS match_result
FROM    silver_level_ipl_data
WHERE   match_id IS NOT NULL
GROUP BY match_id
ORDER BY match_id


--Top batsman each season
SELECT
    season_year,
    batsman_name,
    total_runs,
    batting_avg
FROM(SELECT
        total_runs,
        batsman_name,
        season_year,
        batting_avg,
        ROW_NUMBER() OVER (PARTITION BY agg.season_year ORDER BY total_runs DESC) AS rn
    FROM(SELECT
            SUM(runs_scored) AS total_runs,
            batsman_name,
            season_year,
            SUM(CASE WHEN is_wicket THEN 1 ELSE 0 END) AS no_of_dismissals,
            ROUND(
                (SUM(runs_scored) / NULLIF(SUM(CASE WHEN is_wicket THEN 1 ELSE 0 END),0) )
                ,2) AS batting_avg
        FROM    silver_level_ipl_data
        GROUP BY batsman_name, season_year)agg
    )ranked
WHERE rn = 1


--Bowlers efficiency in Powerplay overs
SELECT
    bowler_name,
    SUM(runs_Scored + bowler_extras) AS total_runs_conceded,
    SUM(CASE WHEN bowler_wicket THEN 1 ELSE 0 END) AS wickets,
    COUNT(ball_id) AS balls_bowled,
    ROUND(
        SUM(runs_scored + bowler_extras) * 6 / NULLIF(COUNT(ball_id),0)
        ,2
    ) AS economy_rate
FROM    silver_level_ipl_data
WHERE   over_id <= 6
GROUP BY bowler_name
HAVING COUNT(ball_id) >= 60
ORDER BY wickets DESC, economy_rate ASC


--Toss impact on the match
SELECT  
    match_id,
    MAX(season_year) AS season_year,
    MAX(toss_winner) AS toss_winner,
    MAX(match_winner) AS match_winner,
    MAX(toss_name) AS toss_name,
    MAX(CASE WHEN toss_winner = match_winner THEN 'Win' ELSE 'Loss' END) AS match_outcome
FROM    silver_level_ipl_data
WHERE   toss_name IS NOT NULL
GROUP BY match_id