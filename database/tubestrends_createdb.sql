-- note: foreign keys constraints will be created at the end to avoid conflicts
 
-- create the database
CREATE DATABASE IF NOT EXISTS `tubes_trends`; 

-- -----------------------------------------------------
-- Table `tubes_trends`.`source_data_orgs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`source_data_orgs` ;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`source_data_orgs` (
  sdoid  INT NOT NULL AUTO_INCREMENT ,
  name VARCHAR(45) NULL ,
  homepage_url VARCHAR(45) NULL ,
  PRIMARY KEY (sdoid) )
ENGINE = InnoDB
COMMENT = 'mapping table; contains the id and name of source data from websites';

-- -----------------------------------------------------
-- Table `tubes_trends`.`twitter_available_places`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`twitter_available_places` ;

CREATE  TABLE IF NOT EXISTS `tubes_trends`.`twitter_available_places` (
  `idtwitter_ap` INT NOT NULL AUTO_INCREMENT ,
  `woeid` INT NOT NULL,
  `the_date` DATE, 
  `sdoid` INT NOT NULL ,
   INDEX (`woeid`), 
   INDEX (`sdoid`),
   PRIMARY KEY(`idtwitter_ap`))
ENGINE = InnoDB
COMMENT = 'table contains data collected from a ruby script to get the twitter avail places website';

-- -----------------------------------------------------
-- Table `tubes_trends`.`places`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`places`;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`places` (
  `idplaces` INT  NOT NULL AUTO_INCREMENT ,
  `woeid` INT NOT NULL,
  `the_date` DATE, 
  `sdoid` INT NOT NULL ,
  `placetype` varchar(75),
  `name` varchar(150),
  `country` INT,
  `latcent`  float,
  `longcent`  float,
  `latsw`  float, 
  `longsw`  float, 
  `latne` float,
  `longne` float,
  `poprank` INT,
  `arearank` INT,
  `timezone` varchar(75),
  `admin1type` varchar(75), 
  `admin1` varchar(75), 
  `admin2type` varchar(75), 
  `admin2`  varchar(75),
  `admin3type` varchar(75), 
  `admin3` varchar(75),
   PRIMARY KEY (`idplaces`),
   INDEX (`woeid` ),
   INDEX (`sdoid`),
   INDEX (`country`))
ENGINE = InnoDB
COMMENT = 'table is a mapping table; yahoo woeid info';

-- -----------------------------------------------------
-- make a continent table 
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`continent`;

CREATE  TABLE IF NOT EXISTS `tubes_trends`.`continent` (
  `idcontinent` INT  NOT NULL AUTO_INCREMENT ,
  `name` varchar(50), 
   PRIMARY KEY (`idcontinent`));

DROP TABLE IF EXISTS `tubes_trends`.`country`;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`country` (
  `idcountry` INT  NOT NULL AUTO_INCREMENT ,
  `woeid` INT NOT NULL,
  `the_date` DATE, 
  `sdoid`  INT NOT NULL ,
  `continent` INT,
  `placetype` varchar(75),
  `name` varchar(150),
  `latcent`  float,
  `longcent`  float,
  `latsw`  float, 
  `longsw`  float, 
  `latne` float,
  `longne` float,
  `poprank` INT,
  `arearank` INT,
  `timezone` varchar(75),
  `admin1type` varchar(75), 
  `admin1` varchar(75), 
  `admin2type` varchar(75), 
  `admin2`  varchar(75),
  `admin3type` varchar(75), 
  `admin3` varchar(75),
   PRIMARY KEY (`idcountry`),
   INDEX (`woeid` ),
   INDEX (`continent`),
   INDEX (`sdoid` ))
ENGINE = InnoDB
COMMENT = 'table is a mapping table; this maps country to place and maps country to twitter avail. 
places. Gets yahoo woeid info';

-- -----------------------------------------------------
-- Table `tubes_trends`.`twitter_trends`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`twitter_trends_country`;

CREATE  TABLE IF NOT EXISTS `tubes_trends`.`twitter_trends_country` (
  `idtwtrendplaces` INT  NOT NULL AUTO_INCREMENT ,
  `woeid` INT NOT NULL,
  `the_date`  DATE, 
  `sdoid` INT NOT NULL ,
  `retrieved_at`  timestamp NOT NULL default CURRENT_TIMESTAMP,
   `as_of` varchar(30),
   `name` varchar(150),
   `url`  varchar(200),
   PRIMARY KEY (`idtwtrendplaces`),
   INDEX (`woeid`) ,
   INDEX (`sdoid`))
ENGINE = InnoDB
COMMENT = 'table is a table of all the twitter trends--> works by country its searchable on whoeid';



DROP TABLE IF EXISTS `tubes_trends`.`twitter_trends_places`;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`twitter_trends_places` (
  `idtwtrendplaces` INT  NOT NULL AUTO_INCREMENT ,
  `woeid` INT NOT NULL,
  `the_date`  DATE, 
  `sdoid` INT NOT NULL ,
  `retrieved_at`  timestamp NOT NULL default CURRENT_TIMESTAMP,
   `as_of` varchar(30),
   `name` varchar(150),
   `url`  varchar(200),
   PRIMARY KEY (`idtwtrendplaces`),
   INDEX (`woeid`) ,
   INDEX (`sdoid`))
ENGINE = InnoDB
COMMENT = 'table is a table of all the twitter trends for all places--> its searchable on woeid';



-- -----------------------------------------------------
-- Table `tubes_trends`.`google_hottrends`
-- -----------------------------------------------------

DROP TABLE IF EXISTS `tubes_trends`.`google_hottrends` ;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`google_hottrends` (
  `idgoogle_hottrends` INT NOT NULL AUTO_INCREMENT ,
  `woeid` INT NOT NULL,
  `the_date`  DATE, 
  `sdoid` INT NOT NULL ,
  `retrieved_at`  timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `trending_item` VARCHAR(100) NULL ,
  `trend_search_count` VARCHAR(45) NULL ,
  `google_trend_ranking` INT NULL ,
  `trend_url` VARCHAR(100) NULL ,
  `trend_image_url` VARCHAR(100) NULL ,
  PRIMARY KEY (`idgoogle_hottrends`),
   INDEX (`woeid`) ,
   INDEX (`sdoid`))
ENGINE = InnoDB
COMMENT = 'table contains data collected from a ruby script that scrape google hot trend website';



-- -----------------------------------------------------
-- Table `tubes_trends`.`instgm_popular`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`instgm_popular` ;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`instgm_popular` (
  `idistgma_popular` INT NOT NULL AUTO_INCREMENT ,
  `woeid` INT, 
  `the_date`  DATE, 
  `sdoid` INT NOT NULL ,
  `retrieved_at`  timestamp NOT NULL default CURRENT_TIMESTAMP,
  `lat` FLOAT, 
  `longt` FLOAT,
  `link` varchar(150), 
  `thumbimage` varchar(150),
  `regimage` varchar(150),
  `tags` varchar(150),
  `camera_filter` varchar(50),
  `as_of` INT, 
  `caption` varchar(150),
  `likes_count` INT, 
  `content_type` varchar(2), 
   PRIMARY KEY (`idistgma_popular`),
   INDEX (`woeid`) ,
   INDEX (`sdoid`))
ENGINE = InnoDB
COMMENT = 'table contains data collected from a ruby script that collects data from the instagram api';


-- -----------------------------------------------------
-- Table `tubes_trends`.`youtube_country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`youtube_country`;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`youtube_country` (
  `idyoutube_country` INT  NOT NULL AUTO_INCREMENT ,
  `sdoid` INT NOT NULL ,
  `countryname` varchar(50), 
  `yt_cntry_code` varchar(2), 
   PRIMARY KEY (idyoutube_country))
ENGINE = InnoDB
COMMENT = 'table is a mapping table; maps youtube country code to places tables on country name';



-- Need a mapping table that is just the woeids and youtube country codes.

DrOP TABLE IF EXISTS `tubes_trends`.`youtubescntry`;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`youtubescntry` (
  `idyoutubecntry` INT NOT NULL AUTO_INCREMENT ,
  `woeid` INT, 
  `sdoid` INT NOT NULL ,
  `yt_cntry_code` varchar(2), 
   PRIMARY KEY (idyoutubecntry), 
   INDEX (`woeid`) ,
   INDEX (`sdoid`), 
  INDEX(`yt_cntry_code`))
  ENGINE = InnoDB
  COMMENT = 'table is a mapping table; maps youtube country_code to woeid'; 

DrOP TABLE IF EXISTS `tubes_trends`.`youtube_popular`;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`youtube_popular` (
  `idyoutube_popular` INT NOT NULL AUTO_INCREMENT ,
  `woeid` INT, 
  `sdoid` INT NOT NULL ,
  `retrieved_at`  timestamp NOT NULL default CURRENT_TIMESTAMP,
  `the_date`  DATE, 
  `linktovideo` varchar(100), 
  `numberofviews` INT ,
  `nameofvideo` varchar(75),
  `yt_cntry_code` varchar(2),
  PRIMARY KEY (idyoutube_popular), 
   INDEX (`sdoid`), 
    INDEX (`woeid`) ,
  INDEX (`yt_cntry_code`))
ENGINE = InnoDB
COMMENT = 'table is a mapping table; maps youtube country_code to woeid'; 

-- At this point, run the script:
-- twitter_aval_places.rb