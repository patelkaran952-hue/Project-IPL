-- Project IPL

SET GLOBAL local_infile = 1;


LOAD DATA LOCAL INFILE "D:/Project IPL/ipl_cleaned.csv"
INTO TABLE ipl_cleaned
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Creating a copy of a original data

create table ipl
like ipl_cleaned;

insert ipl
select * from ipl_cleaned;


create table matches
like matches_cleaned;

insert matches 
select * from matches_cleaned;


-- Fixing the data where values are impossible or inappropriate

select * from ipl 
where batsman_runs = 7;

update ipl
set total_runs = 1 where batsman_runs = 7;

update ipl
set batsman_runs = 0 where batsman_runs = 7;


update ipl
set batsman_runs = 0 where total_runs = 10;

update ipl
set total_runs = 5 where total_runs = 10;

update ipl
set is_boundary = 0 and strike_rate = 0
where total_runs = 8;

update ipl
set total_runs = 4 and batsman_runs = 0
where total_runs = 8;

update ipl
set batsman_runs = 0 and total_runs = 4
where wide_runs = 4;

update ipl
set total_runs = 4
where wide_runs = 4;

update ipl
set city = 'Dubai'
where venue = 'Dubai International Cricket Stadium';



-- BATTING QUERIES
-- Batsmen with most runs

select batsman, sum(batsman_runs) as runs, avg(strike_rate) as SR
from ipl
where is_ball = 1 
group by batsman
order by runs desc limit 10;


-- Most impactful batsmen (best strike rate)

SELECT batsman, SUM(batsman_runs) AS runs, COUNT(is_ball) AS balls, AVG(strike_rate) AS strike_rate
FROM ipl
WHERE is_ball = 1
GROUP BY batsman
HAVING balls > 500
ORDER BY strike_rate DESC
LIMIT 10;



SELECT batsman, SUM(batsman_runs) AS runs, COUNT(is_ball) AS balls, AVG(strike_rate) AS strike_rate
FROM ipl
WHERE is_ball = 1
GROUP BY batsman
HAVING balls > 1000
ORDER BY strike_rate ASC
LIMIT 10;


-- Batsmen with most sixes

SELECT batsman, count(batsman_runs) sixes FROM ipl
WHERE batsman_runs = 6
GROUP BY batsman
ORDER BY sixes desc LIMIT 10;


-- Batsmen with most fours

SELECT batsman, count(batsman_runs) fours FROM ipl
WHERE batsman_runs = 4
GROUP BY batsman
ORDER BY fours desc LIMIT 10;


-- Most impactful batsmen in Death overs

SELECT batsman, SUM(batsman_runs) AS runs, COUNT(is_ball) AS balls, AVG(strike_rate) AS strike_rate, phase
FROM ipl
WHERE is_ball = 1 and phase = 'Death'
GROUP BY batsman
HAVING balls > 500
ORDER BY strike_rate DESC
LIMIT 10;


-- Most impactful batsmen in Middle overs

select batsman, sum(batsman_runs) runs, count(is_ball) balls, avg(strike_rate) as SR, phase
from ipl 
where phase = 'Middle'
group by batsman
having balls > 500
order by SR desc limit 10;


-- Most impactful batsmen in Powerplay

select batsman, sum(batsman_runs) runs, count(is_ball) balls, avg(strike_rate) as SR, phase
from ipl 
where phase = 'Powerplay' and is_ball = 1
group by batsman
having balls > 500
order by SR desc limit 10;


-- Batsmen with best average

select batsman, sum(batsman_runs) runs, sum(batsman_runs) / count(distinct match_id) average, avg(strike_rate) as SR
from ipl
where is_ball = 1
group by batsman
having runs > 3000
order by average desc limit 10;


-- Orange Cap winner in each season

SELECT season, batsman as OrangeCapWinner, runs
FROM (
    SELECT 
        season,
        batsman,
        COUNT(batsman_runs) AS runs,
        RANK() OVER (PARTITION BY season ORDER BY SUM(batsman_runs) DESC) AS rnk
    FROM ipl
    GROUP BY season, batsman
) t
WHERE rnk = 1;


-- Batsman with highest strike rate in each season

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

SELECT bowler, COUNT(player_dismissed) AS wickets
FROM ipl
WHERE dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') 
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;


-- Bowlers with best economy rate

SELECT bowler, SUM(total_runs) AS runs_conceded, COUNT(is_ball) AS balls,
    ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy
FROM ipl
WHERE is_ball = 1 
GROUP BY bowler
HAVING balls > 1000
ORDER BY economy ASC
LIMIT 10;


-- Bowlers with best economy rate in Powerplay

SELECT bowler, SUM(total_runs) AS runs_conceded, COUNT(is_ball) AS balls,
    ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy
FROM ipl
WHERE is_ball = 1 AND phase = 'Powerplay'
GROUP BY bowler
HAVING balls > 1000
ORDER BY economy ASC
LIMIT 10;


-- Bowlers with best economy rate in Death overs

SELECT bowler, SUM(total_runs) AS runs_conceded, COUNT(is_ball) AS balls,
    ROUND(SUM(total_runs) * 6.0 / COUNT(is_ball), 2) AS economy
FROM ipl
WHERE is_ball = 1 AND phase = 'Death'
GROUP BY bowler
HAVING balls > 1000
ORDER BY economy ASC
LIMIT 10;


-- Bowler with best economy in each season

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

SELECT winner team, count(*) wins FROM matches
GROUP BY winner
ORDER BY wins desc;


-- Impact of toss

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




SELECT batting_team, SUM(total_runs) runs, AVG(strike_rate) as SR
FROM ipl
WHERE phase = 'Death' and is_ball = 1 
GROUP BY batting_team
ORDER BY runs DESC LIMIT 10;


SELECT bowling_team, COUNT(player_dismissed) wickets
FROM ipl
WHERE phase = 'Powerplay' and is_ball = 1 and dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') 
GROUP BY bowling_team
ORDER BY wickets DESC LIMIT 10;





-- Venues with highest average first inning score

select venue, count(distinct match_id) as matches, sum(total_runs) / count(distinct match_id) AverageScore
from ipl
where inning = 1
group by venue 
having matches > 50
order by AverageScore desc;


-- Venues with highest average second inning score

select venue, count(distinct match_id) as matches, sum(total_runs) / count(distinct match_id) AverageScore
from ipl
where inning = 2
group by venue 
having matches > 50
order by AverageScore desc;


-- Head to Head stats

SELECT team1, team2, winner, COUNT(*) AS wins
FROM matches
GROUP BY team1, team2, winner
ORDER BY wins DESC;


select batsman, sum(batsman_runs) runs from ipl
where is_ball = 1 and Season = 'IPL-2017'
group by batsman
order by runs desc;










SELECT 
    batsman,
    Season,
    SUM(batsman_runs) AS runs_in_season,
    SUM(SUM(batsman_runs)) OVER (
        PARTITION BY batsman
        ORDER BY Season
    ) AS rolling_total
FROM ipl
WHERE batsman = 'V Kohli'
GROUP BY batsman, Season
ORDER BY Season;


SELECT bowler, COUNT(player_dismissed) AS wickets
FROM ipl
WHERE dismissal_kind NOT IN ('Not Out', 'obstructing the field', 'run out', 'retired hurt') and phase = 'Death'
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;






