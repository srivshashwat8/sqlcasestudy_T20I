use sqlcasestudies;

-- Q1 Identify matches played between two specific teams (e.g., India and South Africa) in 2024 and their results.

SELECT 
    *
FROM
    T20I
WHERE
    ((Team1 = 'South Africa'
        AND Team2 = 'India')
        OR (Team2 = 'South Africa'
        AND Team1 = 'India'))
        AND YEAR(MatchDate) = 2024;
        
-- OR --

SELECT *
FROM t20i
WHERE team1 IN ('India', 'South Africa') 
  AND team2 IN ('India', 'South Africa')
  AND YEAR(matchdate) = 2024;


-- Q2 Find the team with the highest number of wins in 2024 and the total matches it won.

SELECT 
    winner, COUNT(winner) AS totalmatchesWon
FROM
    t20i
GROUP BY winner
ORDER BY totalmatcheswon DESC
LIMIT 1;


-- Q3 Rank the teams based on the total number of wins in 2024.
 
SELECT Winner, COUNT(*) AS 'Number of Wins',
	DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS Rank_Assigned
FROM T20I
WHERE YEAR(MatchDate) = 2024 AND Winner NOT IN('tied', 'no result')
GROUP BY Winner
;


--  Q4 (a) Which team had the highest average winning margin (in runs), and what was the average margin?

SELECT 
    Winner, 
    AVG(CAST(SUBSTRING_INDEX(Margin, ' ', 1) AS UNSIGNED)) AS Avg_Margin
FROM T20I
WHERE Margin LIKE '%runs'
GROUP BY Winner
ORDER BY Avg_Margin DESC
limit 1
;


-- Q4 (b) Which team had the highest average winning margin (in wickets), and what was the average margin?

SELECT 
    winner,
    AVG(CAST(SUBSTRING_INDEX(margin, ' ', 1) AS UNSIGNED)) AS avgWicketMargin
FROM
    t20i
WHERE
    margin LIKE '%wickets'
GROUP BY winner
ORDER BY avgWicketMargin DESC
LIMIT 1
;


-- Q5 List all matches where the winning margin(in runs) was greater than the average margin across all matches.

SELECT 
    *
FROM
    t20i
WHERE
    margin LIKE '%runs'
        AND CAST(SUBSTRING_INDEX(margin, ' ', 1) AS UNSIGNED) > (SELECT 
            AVG(CAST(SUBSTRING_INDEX(margin, ' ', 1) AS UNSIGNED)) avgmargin
        FROM
            t20i
        WHERE
            margin LIKE '%runs')
;

-- OR --

with cte_a as ( 
	SELECT 
	AVG(CAST(SUBSTRING_INDEX(margin, ' ', 1) AS UNSIGNED)) AS avgmargin
	FROM t20i
	WHERE margin LIKE '%runs')
SELECT 
    *
FROM
    t20i i
        CROSS JOIN
    cte_a a
WHERE
    margin LIKE '%runs'
        AND CAST(SUBSTRING_INDEX(margin, ' ', 1) AS UNSIGNED) > avgmargin
;



-- Q6 Find the team with the most wins when chasing a target (wins by wickets).

SELECT Winner, WinWhileChasing
FROM (
		SELECT Winner, COUNT(*) AS WinWhileChasing,
			RANK() OVER( ORDER BY COUNT(*) DESC) AS rk
		FROM T20I
		WHERE Margin LIKE '%wickets'
		AND Winner NOT IN ('tied', 'no result')
		GROUP BY Winner
) t
WHERE rk=1
;



-- Q7 Head-to-head record between two selected teams (e.g., England vs Australia).

SELECT 
    *
FROM
    t20i
WHERE
    (team1 = 'England'
        AND team2 = 'Australia')
        OR (team1 = 'Australia'
        AND team2 = 'England')
;
-- OR --

SET @TeamA = 'England';
SET @TeamB = 'Australia';

SELECT Winner, COUNT(*) AS Matches
FROM T20I
WHERE (Team1 = @TeamA AND Team2 = @TeamB) 
   OR (Team1 = @TeamB AND Team2 = @TeamA)
GROUP BY Winner
;




-- Q8 Identify the month in 2024 with the highest number of T20I matches played.

select MonthName, MostMatchPlayed 
from (
select monthname(matchdate) MonthName, count(month(matchdate)) MostMatchPlayed, dense_rank() over(order by count(month(matchdate)) desc) as rk
from t20i
where year(matchdate)= 2024
group by MONTH(matchdate), monthname(matchdate)
) a 
where rk =1
;

-- OR --

SELECT 
    YEAR(MatchDate) AS YearPlayed,
    MONTHNAME(MatchDate) AS MonthName,
    COUNT(*) AS MatchesPlayed
FROM T20I
WHERE YEAR(MatchDate) = 2024
GROUP BY YearPlayed, MONTH(MatchDate), MonthName
ORDER BY MatchesPlayed DESC
;



-- Q9 For each team, find how many matches they played in 2024 and their win percentage.

select * from t20i 
where team1='nepal' or team2 ='nepal';

with cte_mp as (
select Team, count(*) MatchesPlayed
from 
		(SELECT 
			team1 AS Team
		FROM
			t20i
		WHERE
			YEAR(MatchDate) = 2024
        
		union all 
		
        SELECT 
			team2 AS Team
		FROM
			t20i
		WHERE
			YEAR(MatchDate) = 2024) a
group by team
order by matchesplayed desc ),
cte_w as (
	SELECT 
    winner AS Team, COUNT(*) AS Total_Wins
FROM
    t20i
WHERE
    YEAR(MatchDate) = 2024
        AND winner NOT IN ('tied' , 'no result')
GROUP BY winner
ORDER BY total_wins DESC)
    
SELECT 
    m.Team,
    m.MatchesPlayed,
    IFNULL(w.total_wins, 0) AS Total_Wins,
    ROUND((IFNULL(w.total_wins, 0) / m.matchesplayed) * 100,
            2) AS WinningPercentage
FROM
    cte_mp AS m
        LEFT JOIN
    cte_w w ON m.team = w.team
ORDER BY total_wins DESC
;




-- Q10 Identify the most successful team at each ground (team with most wins per ground).


WITH CTE_WinsPerGround AS (
	SELECT Ground, Winner, Wins, RANK() OVER (PARTITION BY Ground ORDER BY Wins DESC) AS rn
	FROM (
			SELECT Ground, Winner, COUNT(*) AS Wins
			FROM T20I 
			WHERE Winner NOT IN ('tied','no result')
			GROUP BY Ground, Winner
		 ) t
)
SELECT Ground, Winner AS MostSuccessfulTeams, Wins
FROM CTE_WinsPerGround
WHERE rn = 1
ORDER BY Ground
;












































