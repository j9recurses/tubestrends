
 
--create the database
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
-- Table `tubes_trends`.`source_data_orgs` insert statements
---need to run them now, because ruby code is dependent on these id values being stable
-- -----------------------------------------------------
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('twitter', 'http://www.twitter.com') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('google', 'http://www.google.com/trends/') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('yahoo', 'http://www.yahoo.com') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('instagram', 'http://www.instagram.com') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('youtube', 'http://www.youtube.com') ;

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
   PRIMARY KEY(`idtwitter_ap`), 
   FOREIGN KEY (`sdoid`) references `tubes_trends`.`source_data_orgs`(`sdoid`))
ENGINE = InnoDB
COMMENT = 'table contains data collected from a ruby script to get the twitter avail places website';


---insert csome countries tjat arent in the twitter woeids
insert into `tubes_trends`.`twitter_available_places`(`woeid`, `sdoid`) VALUES ( 23424971, 3); 
insert into `tubes_trends`.`twitter_available_places`(`woeid`, `sdoid`) VALUES ( 23424852, 3); 
insert into `tubes_trends`.`twitter_available_places`(`woeid`, `sdoid`) VALUES (24865698, 3);

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
   INDEX (`country`),
   FOREIGN KEY (`sdoid`) references `tubes_trends`.`source_data_orgs`(`sdoid`))
ENGINE = InnoDB
COMMENT = 'table is a mapping table; yahoo woeid info';

--------now, we need to populate the places table 
-- to populate the places table, we need to get data from the yahoo woeid api.
---At this point, run the script:
---twitter_aval_places.rb