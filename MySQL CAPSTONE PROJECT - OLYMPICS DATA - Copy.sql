								   						                ############################################
														                ## MySQL CAPSTONE PROJECT - OLYMPICS DATA ##
																        ############################################
                                                                     
                                                                     

-------------------# Applying appropriate normalization techniques (upto 3 NF) to divide it into multiple tables #------------------

/*
-------------------------------------------------------------------------------------------------------------------------------------------------------------------                
1. First Normal form: 
Here, we tackle the problem of atomicity. Atomicity means values in the table should not be further divided. 
In simple terms, a single cell cannot hold multiple values. If a table contains a composite or multi-valued attribute, 
it violates the First Normal Form.
  
# In this database table is not containing mutiple-valued attributes. That means the table is in 1st normal form. 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
2. Second Normal form:
The first condition in the 2nd NF is that the table has to be in 1st NF. The table also should not contain partial dependency. 
Here partial dependency means the proper subset of candidate key determines a non-prime attribute. 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
3. Third Normal form:
The same rule applies as before i.e, the table has to be in 2NF before proceeding to 3NF. 
The other condition is there should be no transitive dependency for non-prime attributes. 
That means non-prime attributes (which doesn’t form a candidate key) should not be dependent on other non-prime attributes 
in a given table. So a transitive dependency is a functional dependency in which X → Z (X determines Z) indirectly, 
by virtue of X → Y and Y → Z (where it is not the case that Y → X)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

----------------# WHILE OUR DATA IS TOO BIG. SO, IM TAKING RANDOM 5 RECORDS FROM THE DATA. #------------------------  

#------------------------------------------#
# CREATING NEW DATABASE AS "OLYMPICS_DATA" #
#------------------------------------------#

CREATE DATABASE IF NOT EXISTS `OLYMPICS_DATA`;
USE OLYMPICS_DATA;

#----------------------------------------#
# CREATING TABLE AS ATHLETES INFORMATION #
#----------------------------------------#

CREATE TABLE ATHLETES_INFO (
    ATHLETE_ID INT NOT NULL,
    NAME VARCHAR(30) NOT NULL,
    AGE INT NOT NULL,
    PRIMARY KEY (ATHLETE_ID));
    
#------------------------------------------------------#
# INSERTING VALUES INTO THE ATHLETES INFORMATION TABLE #
#------------------------------------------------------#

INSERT INTO ATHLETES_INFO (ATHLETE_ID, NAME, AGE) VALUES
(01, 'Michael Phelps', 27), 
(02, 'Aaron Armstrong', 30), 
(03, 'Aaron McIntosh', 28), 
(04, 'Byeon Cheon-Sa', 18), 
(05, 'Cael Sanderson', 25) ;

#---------------------------------------#
# CREATING TABLE AS COUNTRY INFORMATION #
#---------------------------------------#

CREATE TABLE COUNTRY_INFO (
    COUNTRY_ID VARCHAR(30) NOT NULL,
    COUNTRY VARCHAR(30)NOT NULL,
    PRIMARY KEY (COUNTRY_ID));
    
#-----------------------------------------------------#
# INSERTING VALUES INTO THE COUNTRY INFORMATION TABLE #
#-----------------------------------------------------#

INSERT INTO COUNTRY_INFO (COUNTRY_ID, COUNTRY) VALUES
('US', 'United States'),
('TT' , 'Trinidad and Tobago'),
('NZ', 'New Zealand'),
('SK', 'South Korea'),
('CH', 'China');

#--------------------------------------#
# CREATING TABLE AS SPORTS INFORMATION #
#--------------------------------------#

CREATE TABLE SPORTS_INFO (
    SPORTS_ID VARCHAR(30) NOT NULL,
    SPORTS VARCHAR(30) NOT NULL,
    COUNTRY VARCHAR(30)NOT NULL,
    DATE_GIVEN DATETIME NULL,
    PRIMARY KEY (SPORTS_ID));
    
#----------------------------------------------------#
# INSERTING VALUES INTO THE SPORTS INFORMATION TABLE #
#----------------------------------------------------#

INSERT INTO SPORTS_INFO(SPORTS_ID, SPORTS, COUNTRY, DATE_GIVEN) VALUES 
('SM', 'Swimming', 'United States', DATE'2012-08-12'), 
('AT', 'Athletics', 'Trinidad and Tobago', DATE'2008-08-24'),
('SG', 'Sailing', 'New Zealand', DATE'2000-10-01'),
('STSS', 'Short-Track Speed Skating', 'South Korea', DATE'2006-02-26'),
('WG', 'Wrestling', 'China', DATE'2004-08-29');

#--------------------------------------#
# CREATING TABLE AS MEDALS INFORMATION #
#--------------------------------------#

CREATE TABLE MEDALS_INFO (
    SPORTS_ID VARCHAR(30) NOT NULL,
    ATHLETE_ID INT NOT NULL,
    COUNTRY_ID VARCHAR(30) NOT NULL,
    DATE_GIVEN DATETIME NULL,
    GOLD_MEDAL INT NOT NULL,
    SILVER_MEDAL INT NOT NULL,
    BRONZE_MEDAL INT NOT NULL,
    TOTAL_MEDALS INT NOT NULL,
    PRIMARY KEY (SPORTS_ID), 
    FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY_INFO(COUNTRY_ID),
    FOREIGN KEY (ATHLETE_ID) REFERENCES ATHLETES_INFO(ATHLETE_ID));
    
#----------------------------------------------------#
# INSERTING VALUES INTO THE MEDALS INFORMATION TABLE #
#----------------------------------------------------#

INSERT INTO MEDALS_INFO (SPORTS_ID, ATHLETE_ID, COUNTRY_ID, DATE_GIVEN, GOLD_MEDAL, SILVER_MEDAL, BRONZE_MEDAL, TOTAL_MEDALS) VALUES
('SM', '01', 'US', DATE'2012-08-12', 4, 2, 0, 6),
('AT', '02', 'TT', DATE'2008-08-24', 0, 1, 0, 1), 
('SG', '03', 'NZ', DATE'2000-10-01', 0, 0, 1, 1),
('STSS', '04', 'SK', DATE'2006-02-26', 1, 0, 0, 1), 
('WG', '05', 'CH', DATE'2004-08-29', 1, 0, 0, 1) ;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------## IM USING THE CLEANED DATA FOR WRITING QUIERIES WHICH I HAVE SAVED FROM THE PYTHON AND DESCRIPTIVE STATISTICS
------------## "OLYMPICS_DATA" WHICH IS FILE NAME
------------## IMPORTING FILE DIRECTLY CLICKING ON CREATED DATABASE ( Table Data Import Wizard ) 
------------## AND SAVING IN A NEW TABLE 'olympic_details'

#------------------------------------------------------------------#
# IMPORTING A CSV FILE AND INSERTING IN NEW TABLE 'olympic_details #
#------------------------------------------------------------------#
# AFTER IMPORTING WRITING QUIERIES #
#----------------------------------#

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## 1. Find the average number of medals won by each country

# SLECTING COUNTRY AND TOTAL_MEDALS FROM "olympic_details" table
# AND CALCULATING THE SUM AND AVERAGAE OF TOTAL_MEDALS
# AND USING GOURP BY FUNCTION TO COUNTRY COLUMN
# TO FIND THE AVERAGE NUMBER OF MEDALS WON BY EACH COUNTRY
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    country,
    SUM(total_medal) AS 'total_medals',
    AVG(total_medal) AS 'avg of total medals'
FROM
    olympic_details
GROUP BY country;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## 2. Display the countries and the number of gold medals they have won in decreasing order

# SELCTING COUNRTRY AND GOLD_MEDALS FROM "olympic_details" table
# CALCULATING THE SUM OF GOLD MEDALS AND USING GROUP BY FUNCTION TO COUNTRY COLUMN
# AND ARRANGING THE RESULT IN DECREASING ORDER OF GOLD MEDALS COUNT
# TO GET THE COUNTRIES AND THE NUMBER OF GOLD MEDALS THE HAVE WON IN DECREASING ORDER
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    country, SUM(gold_medal) AS 'number_of_gold_medals'
FROM
    olympic_details
GROUP BY country
ORDER BY SUM(gold_medal) desc;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## 3. Display the list of people and the medals they have won in descending order, grouped by their country

# SELCTING NAME, COUNRTRY, GOLD_MEDALS, SILVER_MEDAL, BRONZE_MEDALS AND TOTAL_MEDALS FROM "olympic_details" table
# CALCULATING THE SUM OF ALL MEDALS AND TOTAL MEDALS 
# USING GROUP BY TO COUNTRY TO GET VALUES UNIQUE 
# AND ARRANGING IN DECREASINNG ORDER OF SUM OF TOTAL MEDALS COUNT 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    name,
    country,
    SUM(gold_medal) AS 'total_gold_medals_won',
    SUM(silver_medal) AS 'total_silver_medals_won',
    SUM(brone_medal) AS 'total_brone_medals_won',
    SUM(total_medal) AS 'total_medals_won'
FROM
    olympic_details
GROUP BY country , name
order by sum(total_medal) desc;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## 4. Display the list of people with the medals they have won according to their their age 
 
# SELCTING NAME, AGE, GOLD_MEDALS, SILVER_MEDAL AND BRONZE_MEDALS FROM "olympic_details" table
# CALCULATING THE SUM OF ALL MEDALS AND TOTAL MEDALS 
# USING GROUP BY TO NAME AND AGE TO GET ALL THE PLAYERS WHO HAVE WON IN DIFFERENT AGE 
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

SELECT 
    name,
    age,
    SUM(gold_medal) AS 'total_gold_medals_won',
    SUM(silver_medal) AS 'total_silver_medals_won',
    SUM(brone_medal) AS 'total_brone_medals_won'
FROM
    olympic_details
GROUP BY name , age;
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
## 5. Which country has won the most number of medals (cumulative)

# SLECTING COUNTRY AND TOTAL_MEDALS FROM "olympic_details" table
# CALCULATING THE SUM OF TOTAL MEDALS 
# USING GROUP BY TO COUNTRY TO GET VALUES UNIQUE 
# AND GIVING LIMIT 0,1 TO GET THE TOP VALUE 
# AND THAT VALUE WILL THE COUNTRY THAT HAS WON THE MOST NUMBER OF MEDALS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
    country, SUM(total_medal) AS 'total_medals'
FROM
    olympic_details
GROUP BY country
ORDER BY SUM(total_medal) DESC
LIMIT 0 , 1;