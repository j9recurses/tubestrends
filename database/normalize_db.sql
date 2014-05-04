-- before running this script need to populate the the places tables. 
--  to populate the places table, we grab the data from the yahoo woeid api.
-- At this point, run the script:
-- twitter_aval_places.rb

-- -----------------------------------------------------
-- Table `tubes_trends`.`source_data_orgs` insert statements
-- need to run them now, because ruby code is dependent on these id values being stable
-- -----------------------------------------------------

insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('twitter', 'http://www.twitter.com') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('google', 'http://www.google.com/trends/') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('yahoo', 'http://www.yahoo.com') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('instagram', 'http://www.instagram.com') ;
insert into `tubes_trends`.`source_data_orgs`  (name, homepage_url ) VALUES ('youtube', 'http://www.youtube.com') ;

-- insert csome countries tjat arent in the twitter woeids
insert into `tubes_trends`.`twitter_available_places`(`woeid`, `sdoid`) VALUES ( 23424971, 3); 
insert into `tubes_trends`.`twitter_available_places`(`woeid`, `sdoid`) VALUES ( 23424852, 3); 
insert into `tubes_trends`.`twitter_available_places`(`woeid`, `sdoid`) VALUES (24865698, 3);


-- insert continent values
INSERT INTO `tubes_trends`.`continent` (name) VALUES ('Asia');
INSERT INTO `tubes_trends`.`continent` (name)  VALUES ('Europe');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('North America');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('South America');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('Africa');
INSERT INTO `tubes_trends`.`continent` (name ) VALUES ('Middle East');


-- normalization of the data below; we split out countries from places.

-- grab the countries from out of the places table

insert into `tubes_trends`.`country` (`woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` )
select `woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` 
from `tubes_trends`.`places` where `placetype` = 'Country';

-- now delete the countries table

delete from `tubes_trends`.`places` where `woeid` in ( select `woeid` from `country`);

-- grab the worldwide woeid

insert into `tubes_trends`.`country` (`woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` )
select `woeid`,`the_date`,`sdoid`,`placetype`,`name`,`latcent`,`longcent`,`latsw`,`longsw`,`latne`,`longne`,
`poprank`,`arearank`,`timezone`,`admin1type`,`admin1`,`admin2type`,`admin2`,`admin3type`,`admin3` 
from `tubes_trends`.`places` where country = '0';

-- delete worldwide from woeid
delete from `tubes_trends`.`places` where `woeid` in (select `woeid` from `country`);



-- populate youtube country codes; this will be a mapping table

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

-- -----------------------------------------------------