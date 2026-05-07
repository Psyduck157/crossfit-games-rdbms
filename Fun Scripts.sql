# displaying all tables
SELECT * FROM affiliate; 
SELECT * FROM competitor; 
SELECT * FROM country;
SELECT * FROM division; # for this table I left the min and max values null because I couldnt figure out how to fill it without manually inputing values
SELECT * FROM score;
SELECT * FROM workout; # similar thing for this, no way to pull just the type of workout 

-- Q#10
INSERT IGNORE INTO DIVISION (division_name)
SELECT DISTINCT division FROM competitorsetup;

INSERT IGNORE INTO DIVISION (division_name)
SELECT DISTINCT TRIM(division) FROM competitorsetup;

UPDATE COMPETITOR
JOIN competitorsetup ON COMPETITOR.competitorid = competitorsetup.competitorid
JOIN DIVISION ON TRIM(competitorsetup.division) = DIVISION.division_name
SET COMPETITOR.division_id = DIVISION.division_id;


#connects the Competitor to the right Division ID
UPDATE COMPETITOR
JOIN competitorsetup ON COMPETITOR.competitorid = competitorsetup.competitorid
JOIN DIVISION ON competitorsetup.division = DIVISION.division_name
SET COMPETITOR.division_id = DIVISION.division_id;


#a
SELECT 
    C.firstname, 
    C.lastname, 
    CO.countryoforigin_name, 
    C.overallscore,
    C.overallrank
FROM COMPETITOR C
JOIN COUNTRY CO ON C.countryoforigin_code = CO.countryoforigin_code
JOIN DIVISION D ON C.division_id = D.division_id
WHERE D.division_name LIKE '%Men%' 
ORDER BY C.overallscore DESC 
LIMIT 1;

#b
SELECT COMPETITOR.firstname, COMPETITOR.lastname, COMPETITOR.status
FROM COMPETITOR
WHERE COMPETITOR.status = 'Cut' OR COMPETITOR.status = 'Withdrawn' OR COMPETITOR.status = 'WD';

#c
SELECT COUNTRY.countryoforigin_name, SUM(COMPETITOR.overallscore) AS total_points, COUNTRY.country_population
FROM COMPETITOR
JOIN COUNTRY ON COMPETITOR.countryoforigin_code = COUNTRY.countryoforigin_code
GROUP BY COUNTRY.countryoforigin_name, COUNTRY.country_population
ORDER BY total_points DESC;

#d
SELECT COMPETITOR.firstname, COMPETITOR.lastname, COMPETITOR.overallscore
FROM COMPETITOR
JOIN DIVISION ON COMPETITOR.division_id = DIVISION.division_id
WHERE DIVISION.division_name = 'Men (35-39)'
ORDER BY COMPETITOR.overallscore DESC
LIMIT 10;

#e
SELECT COMPETITOR.firstname, COMPETITOR.lastname, COUNTRY.countryoforigin_name
FROM COMPETITOR
JOIN COUNTRY ON COMPETITOR.countryoforigin_code = COUNTRY.countryoforigin_code
WHERE COUNTRY.countryoforigin_name REGEXP 'stan$';

#f
SELECT COMPETITOR.firstname, COMPETITOR.lastname, COUNTRY.countryoforigin_name, AFFILIATE.affiliatename
FROM COMPETITOR
JOIN COUNTRY ON COMPETITOR.countryoforigin_code = COUNTRY.countryoforigin_code
JOIN AFFILIATE ON COMPETITOR.affiliateid = AFFILIATE.affiliateid;

#g
SELECT DIVISION.division_name, COUNT(COMPETITOR.competitorid) AS total_athletes
FROM COMPETITOR
JOIN DIVISION ON COMPETITOR.division_id = DIVISION.division_id
GROUP BY DIVISION.division_name;

#h
SELECT COMPETITOR.firstname, COMPETITOR.lastname, COMPETITOR.overallscore
FROM COMPETITOR
WHERE COMPETITOR.overallscore > (SELECT AVG(overallscore) FROM COMPETITOR);

#i
SELECT COMPETITOR.firstname, COMPETITOR.lastname, COMPETITOR.overallscore
FROM COMPETITOR
WHERE COMPETITOR.lastname LIKE 'S%';