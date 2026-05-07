create database CrossFitProject; 
use CrossFitProject; 

create table COUNTRY (
countryoforigin_code VARCHAR(10) PRIMARY KEY,
  countryoforigin_name VARCHAR(255),
  country_population BIGINT);

CREATE TABLE AFFILIATE (
  affiliateid INT PRIMARY KEY,
  affiliatename VARCHAR(255));
  
CREATE TABLE DIVISION (
  division_id INT AUTO_INCREMENT PRIMARY KEY,
  division_name VARCHAR(255),
  min_age VARCHAR(10),
  max_age VARCHAR(10));
  
CREATE TABLE WORKOUT (
  workoutid_for_division INT,
  year INT,
  result_type VARCHAR(255),
  PRIMARY KEY (workoutid_for_division, year));
  
CREATE TABLE COMPETITOR (
  competitorid INT PRIMARY KEY,
  firstname VARCHAR(255),
  lastname VARCHAR(255),
  gender VARCHAR(10),
  age INT,
  height FLOAT,
  weight FLOAT,
  status VARCHAR(50),
  bibid INT,
  overallrank VARCHAR(10), 
  overallscore INT,
  countryoforigin_code VARCHAR(10),
  affiliateid INT,
  division_id INT,
  FOREIGN KEY (countryoforigin_code) REFERENCES COUNTRY(countryoforigin_code),
  FOREIGN KEY (affiliateid) REFERENCES AFFILIATE(affiliateid),
  FOREIGN KEY (division_id) REFERENCES DIVISION(division_id));
  
CREATE TABLE SCORE (
  competitorid INT,
  workoutid_for_division INT,
  year INT,
  points INT,
  result_value VARCHAR(255),
  `rank` VARCHAR(10),
  workout_rank VARCHAR(10),
  heat INT,
  lane INT,
  PRIMARY KEY (competitorid, workoutid_for_division, year),
  FOREIGN KEY (competitorid) REFERENCES COMPETITOR(competitorid),
  FOREIGN KEY (workoutid_for_division, year) REFERENCES WORKOUT(workoutid_for_division, year));
  
CREATE TABLE competitorsetup ( 
height TEXT,
  affiliateid TEXT,
  countryoforiginname TEXT,
  weight TEXT,
  affiliatename TEXT,
  status TEXT,
  bibid TEXT,
  competitorid TEXT,
  firstname TEXT,
  gender TEXT,
  age TEXT,
  lastname TEXT,
  countryoforigincode TEXT,
  overallrank TEXT,
  overallscore TEXT,
  division TEXT,
  countrypopulation TEXT
);

CREATE TABLE scoresetup (
  workoutIDforDivision TEXT,
  breakdown TEXT,
  lane TEXT,
  `rank` TEXT,
  heat TEXT,
  points TEXT,
  scoredisplay TEXT,
  `time` TEXT,
  workoutrank TEXT,
  competitorid TEXT,
  Year TEXT
);

# 1. Fill COUNTRY
INSERT IGNORE INTO COUNTRY (countryoforigin_code, countryoforigin_name, country_population)
SELECT DISTINCT countryoforigincode, countryoforiginname, CAST(countrypopulation AS SIGNED)
FROM competitorsetup;

# 2. Fill AFFILIATE
INSERT IGNORE INTO AFFILIATE (affiliateid, affiliatename)
SELECT DISTINCT CAST(affiliateid AS SIGNED), affiliatename 
FROM competitorsetup 
WHERE affiliateid IS NOT NULL AND affiliateid != '';

# 3. Fill DIVISION
INSERT IGNORE INTO DIVISION (division_name)
SELECT DISTINCT division FROM competitorsetup;

# 4. Fill COMPETITOR
INSERT IGNORE INTO COMPETITOR (competitorid, firstname, lastname, gender, age, height, weight, status, bibid, overallrank, overallscore, countryoforigin_code, affiliateid, division_id)
SELECT 
    CAST(c.competitorid AS SIGNED), c.firstname, c.lastname, c.gender, 
    CAST(c.age AS SIGNED), CAST(c.height AS FLOAT), CAST(c.weight AS FLOAT), 
    c.status, CAST(c.bibid AS SIGNED), c.overallrank, 
    CAST(c.overallscore AS SIGNED), c.countryoforigincode, 
    CAST(c.affiliateid AS SIGNED), d.division_id
FROM competitorsetup c
JOIN DIVISION d ON c.division = d.division_name;

# 5. Fill WORKOUT
INSERT IGNORE INTO WORKOUT (workoutid_for_division, year)
SELECT DISTINCT CAST(workoutIDforDivision AS SIGNED), CAST(Year AS SIGNED) 
FROM scoresetup;

# 6. Fill SCORE
INSERT IGNORE INTO SCORE (competitorid, workoutid_for_division, year, points, result_value, `rank`, workout_rank, heat, lane)
SELECT 
    CAST(competitorid AS SIGNED), CAST(workoutIDforDivision AS SIGNED), 
    CAST(Year AS SIGNED), CAST(points AS SIGNED), scoredisplay, 
    `rank`, workoutrank, CAST(heat AS SIGNED), CAST(lane AS SIGNED)
FROM scoresetup;