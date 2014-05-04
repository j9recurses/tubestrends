--- make a continent table 
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tubes_trends`.`continent`;

CREATE  TABLE IF NOT EXISTS `tubes_trends`.`continent` (
  `idcontinent` INT  NOT NULL AUTO_INCREMENT ,
  `name` varchar(50), 
   PRIMARY KEY (`idcontinent`));

INSERT INTO `tubes_trends`.`continent` (name) VALUES ('Asia');
INSERT INTO `tubes_trends`.`continent` (name)  VALUES ('Europe');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('North America');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('South America');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('Africa');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('Middle East');

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
   INDEX (`sdoid` ), 
   FOREIGN KEY (`sdoid`) references `tubes_trends`.`source_data_orgs` (`sdoid`),
   FOREIGN KEY (`continent`) references `tubes_trends`.`continent` (`idcontinent`))
ENGINE = InnoDB
COMMENT = 'table is a mapping table; this maps country to place and maps country to twitter avail. 
places. Gets yahoo woeid info';

---normalization of the data below; we split out countries from places.

--grab the countries from out of the places table
insert into `tubes_trends`.`country` (`woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` )
select `woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` 
from `tubes_trends`.`places` where `placetype` = 'Country';

--now delete the countries table;
delete from `tubes_trends`.`places` where `woeid` in (select `woeid` from `country`);

--grab the worldwide woeid
insert into `tubes_trends`.`country` (`woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` )
select `woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` 
from `tubes_trends`.`places` where country = '0'

--delete worldwide from woeid
delete from `tubes_trends`.`places` where `woeid` in (select `woeid` from `country`);

--Add a foreign key reference to country now that we have the the countries
ALTER TABLE places ADD FOREIGN KEY (`country`) REFERENCES country(`woeid`);


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

--use fK contraints to mimize damage from accidentical deletes

ALTER TABLE `tubes_trends`.`twitter_trends_country`
ADD CONSTRAINT FK_woeids_tw_trend_places_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
On Delete Restrict
on update Restrict;

ALTER TABLE `tubes_trends`.`twitter_trends_country`
ADD CONSTRAINT FK_trend_current_country_woeidz
FOREIGN KEY (woeid) REFERENCES country(woeid) 
 On Delete Restrict
 On UPDATE Restrict;


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


--put foreign key constraints here; we don't want someone
 --delete a given parent row if a child row exists that references the value for that parent row.
 --if that happpened, it could kill all the data that was collected, and be a mess to sort out

ALTER TABLE `tubes_trends`.`twitter_trends_places`
ADD CONSTRAINT FK_woeids_tw_trend_places_more_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
On Delete Restrict
on update Restrict;

ALTER TABLE `tubes_trends`.`twitter_trends_places`
ADD CONSTRAINT FK_trend_crnt_place_woeidz
FOREIGN KEY (woeid) REFERENCES places(woeid) 
 On Delete Restrict
 On UPDATE Restrict;




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


--use fK contraints to mimize damage from accidentical deletes

ALTER TABLE `tubes_trends`.`google_hottrends`
ADD CONSTRAINT FK_woeids_googlez_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
On Delete Restrict
 On UPDATE Restrict;

ALTER TABLE `tubes_trends`.`google_hottrends`
ADD CONSTRAINT FK_trend_google_woeidz
FOREIGN KEY (woeid) REFERENCES country(woeid) 
On Delete Restrict
 On UPDATE Restrict;

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


--use fK contraints to mimize damage from accidentical deletes


ALTER TABLE `tubes_trends`.`instgm_popular`
ADD CONSTRAINT FK_woeids_instgm_popular_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
On Delete Restrict
 On UPDATE Restrict;

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


ALTER TABLE `tubes_trends`.`youtube_country` 
ADD CONSTRAINT FK_woeids_country_sdoid
FOREIGN KEY (`sdoid`) REFERENCES source_data_orgs(`sdoid`) 
on delete cascade
on update cascade;


INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Australia','AU');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Austria','AT');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Belgium','BE');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Brazil','BR');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Canada','CA');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Chile','CL');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Colombia','CO');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Czech Republic','CZ');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Egypt','EG');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'France','FR');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Germany','DE');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Great Britain','GB');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Hong Kong','HK');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Hungary','HU');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'India','IN');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Ireland','IE');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Israel','IL');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Italy','IT');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Japan','JP');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Jordan','JO');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Malaysia','MY');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Mexico','MX');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Morocco','MA');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Netherlands','NL');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'New Zealand','NZ');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Peru','PE');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Philippines','PH');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Poland','PL');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Russia','RU');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Saudi Arabia','SA');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Singapore','SG');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'South Africa','ZA');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'South Korea','KR');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Spain','ES');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Sweden','SE');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Switzerland','CH');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'Taiwan','TW');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'United Arab Emirates','AE');
INSERT INTO `tubes_trends`.`youtube_country` (sdoid, countryname, yt_cntry_code) VALUES (5, 'United States','US');

--now lets do some acrobatics to get the woeids so that we can just have a mapping table 
-- that is just the woeids and youtube country codes.
--create table you_tube_cc_map as select yc.sdoid, woeid, yt_cntry_code
---from youtube_country yc  join country c
---on yc.countryname = c.name 
 DrOP TABLE IF EXISTS `tubes_trends`.`youtubescntry`;
CREATE  TABLE IF NOT EXISTS `tubes_trends`.`youtubescntry` (
  `idyoutubecntry` INT NOT NULL AUTO_INCREMENT ,
  `woeid` INT, 
  `sdoid` INT NOT NULL ,
  `yt_cntry_code` varchar(2), 
   PRIMARY KEY (idyoutubecntry), 
   INDEX (`woeid`) ,
   INDEX (`sdoid`), 
	INDEX(`yt_cntry_code`), 
    FOREIGN KEY (`sdoid`) references `tubes_trends`.`source_data_orgs` (`sdoid`),
   FOREIGN KEY (`woeid`) references `tubes_trends`.`country` (`woeid`))
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
	INDEX (`yt_cntry_code`)
 	FOREIGN KEY (`yt_cntry_code`) REFERENCES `tubes_trends`.`youtubescntry`(`yt_cntry_code`),
   FOREIGN KEY (`sdoid`) references `tubes_trends`.`source_data_orgs` (`sdoid`),
   FOREIGN KEY (`woeid`) references `tubes_trends`.`country` (`woeid`))
ENGINE = InnoDB
COMMENT = 'table is a mapping table; maps youtube country_code to woeid'; 


---put foreign key constraints here to keep in check the data integretiy

ALTER TABLE `tubes_trends`.`youtube_popular`
ADD CONSTRAINT FK_woeids_youttube_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
On Delete Restrict
on update Restrict;

ALTER TABLE `tubes_trends`.`youtube_popular`
ADD CONSTRAINT FK_youtube_cnty_woeidz
FOREIGN KEY (woeid) REFERENCES country(woeid) 
 On Delete Restrict
 On UPDATE Restrict;






