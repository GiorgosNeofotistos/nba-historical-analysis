#1 Τop scorers per season
SELECT 
  p.firstName,
  p.lastName,
  EXTRACT(YEAR FROM DATE(ps.gameDate)) AS season,
  SUM(ps.points) AS total_points
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
JOIN `nba-analysis-project-473109.NBA_analysis_project.Players` p
  ON ps.personId = p.personId
GROUP BY p.firstName, p.lastName, season
QUALIFY ROW_NUMBER() OVER(PARTITION BY season ORDER BY total_points DESC) = 1
ORDER BY season;

#2 Average efficiency per player
SELECT 
  p.firstName,
  p.lastName,
  AVG(
    ps.points + ps.reboundsTotal + ps.assists + ps.steals + ps.blocks
    - ((ps.fieldGoalsAttempted - ps.fieldGoalsMade)
       + (ps.freeThrowsAttempted - ps.freeThrowsMade)
       + ps.turnovers)
  ) AS avg_efficiency
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
JOIN `nba-analysis-project-473109.NBA_analysis_project.Players` p
  ON ps.personId = p.personId
GROUP BY p.firstName, p.lastName
ORDER BY avg_efficiency DESC
LIMIT 50;

#3 Team performance home vs away
SELECT 
  ps.playerteamName AS team,
  SUM(ps.win) AS wins,
  COUNT(*) - SUM(ps.win) AS losses,
  CASE WHEN ps.home = 1 THEN 'Home' ELSE 'Away' END AS location
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
GROUP BY team, location
ORDER BY team, location;

#4 Player stats + info join
SELECT 
  p.firstName,
  p.lastName,
  p.draftYear,
  p.draftRound,
  p.draftNumber,
  ps.points,
  ps.assists,
  ps.reboundsTotal,
  ps.gameDate
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
JOIN `nba-analysis-project-473109.NBA_analysis_project.Players` p
  ON ps.personId = p.personId
ORDER BY ps.gameDate DESC
LIMIT 100;

#5Top 5 players per team per season
SELECT 
  ps.playerteamName AS team,
  p.firstName,
  p.lastName,
  EXTRACT(YEAR FROM DATE(ps.gameDate)) AS season,
  SUM(ps.points) AS total_points
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
JOIN `nba-analysis-project-473109.NBA_analysis_project.Players` p
  ON ps.personId = p.personId
GROUP BY team, p.firstName, p.lastName, season
QUALIFY ROW_NUMBER() OVER(PARTITION BY team, season ORDER BY total_points DESC) <= 5
ORDER BY team, season;

#6 Shooting percentages per player
SELECT 
  p.firstName,
  p.lastName,
  EXTRACT(YEAR FROM DATE(ps.gameDate)) AS season,
  AVG(ps.fieldGoalsPercentage) AS avg_fg_pct,
  AVG(ps.threePointersPercentage) AS avg_3p_pct,
  AVG(ps.freeThrowsPercentage) AS avg_ft_pct
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
JOIN `nba-analysis-project-473109.NBA_analysis_project.Players` p
  ON ps.personId = p.personId
GROUP BY p.firstName, p.lastName, season
ORDER BY season, avg_fg_pct DESC;

#7 Rebounds & assists per team
SELECT 
  ps.playerteamName AS team,
  EXTRACT(YEAR FROM DATE(ps.gameDate)) AS season,
  AVG(ps.reboundsTotal) AS avg_rebounds,
  AVG(ps.assists) AS avg_assists
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
GROUP BY team, season
ORDER BY season, avg_rebounds DESC;

#8 Player performance trends
SELECT 
  EXTRACT(MONTH FROM DATE(ps.gameDate)) AS month,
  SUM(ps.points) AS total_points,
  SUM(ps.assists) AS total_assists,
  SUM(ps.reboundsTotal) AS total_rebounds
FROM `nba-analysis-project-473109.NBA_analysis_project.player_statistics` ps
JOIN `nba-analysis-project-473109.NBA_analysis_project.Players` p
  ON ps.personId = p.personId
WHERE p.firstName = 'James' AND p.lastName = 'Harden'
GROUP BY month
ORDER BY month;