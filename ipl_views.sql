-- BATTING QUERIES

-- Batsmen with most runs

create view one as
select batsman, sum(batsman_runs) as runs, avg(strike_rate) as SR
from ipl
where is_ball = 1 
group by batsman
order by runs desc limit 10;


-- Most impactful batsmen (best strike rate)

create view two as
SELECT batsman, SUM(batsman_runs) AS runs, COUNT(is_ball) AS balls, AVG(strike_rate) AS strike_rate
FROM ipl
WHERE is_ball = 1
GROUP BY batsman
HAVING balls > 500
ORDER BY strike_rate DESC
LIMIT 10;


create view three as
SELECT batsman, SUM(batsman_runs) AS runs, COUNT(is_ball) AS balls, AVG(strike_rate) AS strike_rate
FROM ipl
WHERE is_ball = 1
GROUP BY batsman
HAVING balls > 1000
ORDER BY strike_rate ASC
LIMIT 10;


-- Batsmen with most sixes

create view four as
SELECT batsman, count(batsman_runs) sixes FROM ipl
WHERE batsman_runs = 6
GROUP BY batsman
ORDER BY sixes desc LIMIT 10;


-- Batsmen with most fours

create view five as
SELECT batsman, count(batsman_runs) fours FROM ipl
WHERE batsman_runs = 4
GROUP BY batsman
ORDER BY fours desc LIMIT 10;


-- Most impactful batsmen in Death overs

create view six as
SELECT batsman, SUM(batsman_runs) AS runs, COUNT(is_ball) AS balls, AVG(strike_rate) AS strike_rate, phase
FROM ipl
WHERE is_ball = 1 and phase = 'Death'
GROUP BY batsman
HAVING balls > 500
ORDER BY strike_rate DESC
LIMIT 10;


-- Most impactful batsmen in Middle overs

create view seven as
select batsman, sum(batsman_runs) runs, count(is_ball) balls, avg(strike_rate) as SR, phase
from ipl 
where phase = 'Middle'
group by batsman
having balls > 500
order by SR desc limit 10;


-- Most impactful batsmen in Powerplay

create view eight as
select batsman, sum(batsman_runs) runs, count(is_ball) balls, avg(strike_rate) as SR, phase
from ipl 
where phase = 'Powerplay' and is_ball = 1
group by batsman
having balls > 500
order by SR desc limit 10;


-- Batsmen with best average

create view nine as
select batsman, sum(batsman_runs) runs, sum(batsman_runs) / count(distinct match_id) average, avg(strike_rate) as SR
from ipl
where is_ball = 1
group by batsman
having runs > 3000
order by average desc limit 10;


-- Orange Cap winner in each season

create view ten as
SELECT season, batsman as OrangeCapWinner, runs
FROM (
    SELECT 
        season,
        batsman,
	    SUM(batsman_runs) AS runs,
        RANK() OVER (PARTITION BY season ORDER BY SUM(batsman_runs) DESC) AS rnk
    FROM ipl
    GROUP BY season, batsman
) t
WHERE rnk = 1;


-- Batsman with highest strike rate in each season

create view eleven as
SELECT season, batsman, strikerate
FROM (
    SELECT 
        season,
        batsman,
        AVG(strike_rate) AS strikerate,
        COUNT(is_ball) as balls,
        RANK() OVER (PARTITION BY season ORDER BY AVG(strike_rate) DESC) AS rnk
    FROM ipl
    WHERE is_ball = 1 
    GROUP BY season, batsman
    HAVING balls > 200
) t
WHERE rnk = 1;



-- BOWLING QUERIES
-- Bowlers with most wickets

create view twelwe as
SELECT bowler, COUNT(player_dismissed) AS wickets
FROM ipl
WHERE dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') 
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;


-- Bowlers with best economy rate

create view thirteen as
SELECT bowler, SUM(total_runs) AS runs_conceded, COUNT(is_ball) AS balls,
    ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy
FROM ipl
WHERE is_ball = 1 
GROUP BY bowler
HAVING balls > 1000
ORDER BY economy ASC
LIMIT 10;


-- Bowlers with best economy rate in Powerplay

create view fourteen as
SELECT bowler, SUM(total_runs) AS runs_conceded, COUNT(is_ball) AS balls,
    ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy
FROM ipl
WHERE is_ball = 1 AND phase = 'Powerplay'
GROUP BY bowler
HAVING balls > 1000
ORDER BY economy ASC
LIMIT 10;


-- Bowlers with best economy rate in Death overs

create view fifteen as
SELECT bowler, SUM(total_runs) AS runs_conceded, COUNT(is_ball) AS balls,
    ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy
FROM ipl
WHERE is_ball = 1 AND phase = 'Death'
GROUP BY bowler
HAVING balls > 1000
ORDER BY economy ASC
LIMIT 10;


-- Bowler with best economy in each season

create view sixteen as
SELECT season, bowler, economy
FROM (
    SELECT 
        season,
        bowler,
        ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy,
        COUNT(is_ball) as balls,
        RANK() OVER (PARTITION BY season ORDER BY ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) ASC) AS rnk
    FROM ipl
    WHERE is_ball = 1 
    GROUP BY season, bowler
    HAVING balls > 300
) t
WHERE rnk = 1;


-- Purple Cap winner in each season

create view seventeen as
SELECT season, bowler as PurpleCapWinner, wickets
FROM (
    SELECT 
        season,
        bowler,
        COUNT(player_dismissed) AS wickets,
        RANK() OVER (PARTITION BY season ORDER BY COUNT(player_dismissed) DESC) AS rnk
    FROM ipl
    WHERE dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') 
    GROUP BY season, bowler
) t
WHERE rnk = 1;


-- Bowler with best economy in each season

create view eighteen as
SELECT season, bowler, economy
FROM (
    SELECT 
        season,
        bowler,
        ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy,
        COUNT(is_ball) as balls,
        RANK() OVER (PARTITION BY season ORDER BY ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) ASC) AS rnk
    FROM ipl
    WHERE is_ball = 1 
    GROUP BY season, bowler
    HAVING balls > 300
) t
WHERE rnk = 1;



-- OTHER QUERIES
-- Total wins by each team

create view nineteen as
SELECT winner team, count(*) wins FROM matches
GROUP BY winner
ORDER BY wins desc;


-- Impact of toss

create view twenty as
SELECT toss_winner, COUNT(*) AS matches, 
	SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS wins_after_toss
FROM matches_cleaned
GROUP BY toss_winner
ORDER BY wins_after_toss DESC;


SELECT 
    ROUND(
        SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS win_percentage_after_toss
FROM matches_cleaned;



create view twentyone as
SELECT batting_team, SUM(total_runs) runs, AVG(strike_rate) as SR
FROM ipl
WHERE phase = 'Death' and is_ball = 1 
GROUP BY batting_team
ORDER BY runs DESC LIMIT 10;

create view twentytwo as
SELECT bowling_team, COUNT(player_dismissed) wickets
FROM ipl
WHERE phase = 'Powerplay' and is_ball = 1 and dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') 
GROUP BY bowling_team
ORDER BY wickets DESC LIMIT 10;





-- Venues with highest average first inning score

create view twentythree as
select venue, count(distinct match_id) as matches, sum(total_runs) / count(distinct match_id) AverageScore
from ipl
where inning = 1
group by venue 
having matches > 50
order by AverageScore desc;


-- Venues with highest average second inning score

create view twentyfour as
select venue, count(distinct match_id) as matches, sum(total_runs) / count(distinct match_id) AverageScore
from ipl
where inning = 2
group by venue 
having matches > 50
order by AverageScore desc;


-- Head to Head stats

create view twentyfive as
SELECT team1, team2, winner, COUNT(*) AS wins
FROM matches
GROUP BY team1, team2, winner
ORDER BY wins DESC;


create view twentysix as
select batsman, sum(batsman_runs) runs from ipl
where is_ball = 1 and Season = 'IPL-2017'
group by batsman
order by runs desc;


create view twentyseven as
SELECT bowler, COUNT(player_dismissed) AS wickets, COUNT(distinct match_id)
FROM ipl
WHERE dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') and phase = 'Powerplay'
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;


create view twentyeight as
SELECT bowler, COUNT(player_dismissed) AS wickets
FROM ipl
WHERE dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') and phase = 'Death'
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;