--  put foreign key constraints here; we don't want someone
 -- delete a given parent row if a child row exists that references the value for that parent row.
 -- if that happpened, it could kill all the data that was collected, and be a mess to sort out

ALTER TABLE `tubes_trends`.`twitter_available_places`
ADD CONSTRAINT FK_twitter_aval_pl_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
ON DELETE Restrict
ON UPDATE Restrict;

ALTER TABLE  `tubes_trends`.`places`
ADD CONSTRAINT FK_places_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
ON DELETE Restrict
ON UPDATE Restrict;

ALTER TABLE `tubes_trends`.`country`
ADD CONSTRAINT FK_country_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
ON DELETE Restrict
ON UPDATE Restrict;

ALTER TABLE `tubes_trends`.`country`
ADD CONSTRAINT FK_country_continent
FOREIGN KEY (`continent`) references `tubes_trends`.`continent` (`idcontinent`)
ON DELETE Restrict
ON UPDATE Restrict;


ALTER TABLE `tubes_trends`.`twitter_trends_country`
ADD CONSTRAINT FK_woeids_tw_trend_places_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
ON DELETE Restrict
ON UPDATE Restrict;


ALTER TABLE `tubes_trends`.`twitter_trends_country`
ADD CONSTRAINT FK_trend_current_country_woeidz
FOREIGN KEY (woeid) REFERENCES country(woeid) 
ON DELETE Restrict
ON UPDATE Restrict;


ALTER TABLE `tubes_trends`.`twitter_trends_places`
ADD CONSTRAINT FK_woeids_tw_trend_places_more_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
ON DELETE Restrict
ON UPDATE Restrict;


ALTER TABLE `tubes_trends`.`twitter_trends_places`
ADD CONSTRAINT FK_trend_crnt_place_woeidz
FOREIGN KEY (woeid) REFERENCES places(woeid) 
ON DELETE Restrict
ON UPDATE Restrict;


ALTER TABLE `tubes_trends`.`google_hottrends`
ADD CONSTRAINT FK_woeids_googlez_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
ON DELETE Restrict
ON UPDATE Restrict;

ALTER TABLE `tubes_trends`.`google_hottrends`
ADD CONSTRAINT FK_trend_google_woeidz
FOREIGN KEY (woeid) REFERENCES country(woeid) 
ON DELETE Restrict
ON UPDATE Restrict;


 -- use fK contraints to mimize damage from accidentical deletes

ALTER TABLE `tubes_trends`.`instgm_popular`
ADD CONSTRAINT FK_woeids_instgm_popular_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(sdoid) 
ON DELETE Restrict
ON UPDATE Restrict;


ALTER TABLE `tubes_trends`.`youtube_country` 
ADD CONSTRAINT FK_woeids_youtube_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(`sdoid`) 
ON DELETE Restrict
ON UPDATE Restrict;

ALTER TABLE `tubes_trends`.`youtubescntry`
ADD CONSTRAINT FK_woeids_youtubescntry_sdoid
FOREIGN KEY (sdoid) REFERENCES source_data_orgs(`sdoid`) 
ON DELETE Restrict
ON UPDATE Restrict;


ALTER TABLE `tubes_trends`.`youtubescntry`
ADD CONSTRAINT FK_trend_youtubescntry_woeidz
FOREIGN KEY (woeid) REFERENCES country(woeid) 
ON DELETE Restrict
ON UPDATE Restrict;


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


ALTER TABLE `tubes_trends`.`youtube_popular`
ADD CONSTRAINT FK_trend_youtube_popular_youtubescntry_woeidz
FOREIGN KEY (yt_cntry_code) REFERENCES youtubescntry (`yt_cntry_code`)
ON DELETE Restrict
ON UPDATE Restrict;

