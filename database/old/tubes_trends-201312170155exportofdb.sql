-- MySQL dump 10.13  Distrib 5.5.34, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: tubes_trends
-- ------------------------------------------------------
-- Server version	5.5.34-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `continent`
--

DROP TABLE IF EXISTS `continent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `continent` (
  `idcontinent` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idcontinent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `continent`
--

LOCK TABLES `continent` WRITE;
/*!40000 ALTER TABLE `continent` DISABLE KEYS */;
/*!40000 ALTER TABLE `continent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `idcountry` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) NOT NULL,
  `the_date` date DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `continent` int(11) DEFAULT NULL,
  `placetype` varchar(75) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `latcent` float DEFAULT NULL,
  `longcent` float DEFAULT NULL,
  `latsw` float DEFAULT NULL,
  `longsw` float DEFAULT NULL,
  `latne` float DEFAULT NULL,
  `longne` float DEFAULT NULL,
  `poprank` int(11) DEFAULT NULL,
  `arearank` int(11) DEFAULT NULL,
  `timezone` varchar(75) DEFAULT NULL,
  `admin1type` varchar(75) DEFAULT NULL,
  `admin1` varchar(75) DEFAULT NULL,
  `admin2type` varchar(75) DEFAULT NULL,
  `admin2` varchar(75) DEFAULT NULL,
  `admin3type` varchar(75) DEFAULT NULL,
  `admin3` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`idcountry`),
  KEY `woeid` (`woeid`),
  KEY `continent` (`continent`),
  KEY `sdoid` (`sdoid`),
  CONSTRAINT `country_ibfk_1` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`),
  CONSTRAINT `country_ibfk_2` FOREIGN KEY (`continent`) REFERENCES `continent` (`idcontinent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table is a mapping table; this maps country to place and maps country to twitter avail. \nplaces. Gets yahoo woeid info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `google_hottrends`
--

DROP TABLE IF EXISTS `google_hottrends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `google_hottrends` (
  `idgoogle_hottrends` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) NOT NULL,
  `the_date` date DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `retrieved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `trending_item` varchar(100) DEFAULT NULL,
  `trend_search_count` varchar(45) DEFAULT NULL,
  `google_trend_ranking` int(11) DEFAULT NULL,
  `trend_url` varchar(100) DEFAULT NULL,
  `trend_image_url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idgoogle_hottrends`),
  KEY `woeid` (`woeid`),
  KEY `sdoid` (`sdoid`),
  CONSTRAINT `FK_trend_google_woeidz` FOREIGN KEY (`woeid`) REFERENCES `country` (`woeid`),
  CONSTRAINT `FK_woeids_googlez_sdoid` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table contains data collected from a ruby script that scrape google hot trend website';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `google_hottrends`
--

LOCK TABLES `google_hottrends` WRITE;
/*!40000 ALTER TABLE `google_hottrends` DISABLE KEYS */;
/*!40000 ALTER TABLE `google_hottrends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instgm_popular`
--

DROP TABLE IF EXISTS `instgm_popular`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instgm_popular` (
  `idistgma_popular` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) DEFAULT NULL,
  `the_date` date DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `retrieved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lat` float DEFAULT NULL,
  `longt` float DEFAULT NULL,
  `link` varchar(150) DEFAULT NULL,
  `thumbimage` varchar(150) DEFAULT NULL,
  `regimage` varchar(150) DEFAULT NULL,
  `tags` varchar(150) DEFAULT NULL,
  `camera_filter` varchar(50) DEFAULT NULL,
  `as_of` int(11) DEFAULT NULL,
  `caption` varchar(150) DEFAULT NULL,
  `likes_count` int(11) DEFAULT NULL,
  `content_type` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`idistgma_popular`),
  KEY `woeid` (`woeid`),
  KEY `sdoid` (`sdoid`),
  CONSTRAINT `FK_woeids_instgm_popular_sdoid` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table contains data collected from a ruby script that collects data from the instagram api';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instgm_popular`
--

LOCK TABLES `instgm_popular` WRITE;
/*!40000 ALTER TABLE `instgm_popular` DISABLE KEYS */;
/*!40000 ALTER TABLE `instgm_popular` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `places`
--

DROP TABLE IF EXISTS `places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `places` (
  `idplaces` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) NOT NULL,
  `the_date` date DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `placetype` varchar(75) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `country` int(11) DEFAULT NULL,
  `latcent` float DEFAULT NULL,
  `longcent` float DEFAULT NULL,
  `latsw` float DEFAULT NULL,
  `longsw` float DEFAULT NULL,
  `latne` float DEFAULT NULL,
  `longne` float DEFAULT NULL,
  `poprank` int(11) DEFAULT NULL,
  `arearank` int(11) DEFAULT NULL,
  `timezone` varchar(75) DEFAULT NULL,
  `admin1type` varchar(75) DEFAULT NULL,
  `admin1` varchar(75) DEFAULT NULL,
  `admin2type` varchar(75) DEFAULT NULL,
  `admin2` varchar(75) DEFAULT NULL,
  `admin3type` varchar(75) DEFAULT NULL,
  `admin3` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`idplaces`),
  KEY `woeid` (`woeid`),
  KEY `sdoid` (`sdoid`),
  KEY `country` (`country`),
  CONSTRAINT `places_ibfk_3` FOREIGN KEY (`country`) REFERENCES `country` (`woeid`),
  CONSTRAINT `places_ibfk_1` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`),
  CONSTRAINT `places_ibfk_2` FOREIGN KEY (`country`) REFERENCES `country` (`woeid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table is a mapping table; yahoo woeid info';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `places`
--

LOCK TABLES `places` WRITE;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
/*!40000 ALTER TABLE `places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source_data_orgs`
--

DROP TABLE IF EXISTS `source_data_orgs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `source_data_orgs` (
  `sdoid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `homepage_url` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`sdoid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COMMENT='mapping table; contains the id and name of source data from websites';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source_data_orgs`
--

LOCK TABLES `source_data_orgs` WRITE;
/*!40000 ALTER TABLE `source_data_orgs` DISABLE KEYS */;
INSERT INTO `source_data_orgs` VALUES (1,'twitter','http://www.twitter.com'),(2,'google','http://www.google.com/trends/'),(3,'yahoo','http://www.yahoo.com'),(4,'instagram','http://www.instagram.com'),(5,'youtube','http://www.youtube.com');
/*!40000 ALTER TABLE `source_data_orgs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `twitter_available_places`
--

DROP TABLE IF EXISTS `twitter_available_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `twitter_available_places` (
  `idtwitter_ap` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) NOT NULL,
  `the_date` date DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  PRIMARY KEY (`idtwitter_ap`),
  KEY `woeid` (`woeid`),
  KEY `sdoid` (`sdoid`),
  CONSTRAINT `twitter_available_places_ibfk_1` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table contains data collected from a ruby script to get the twitter avail places website';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twitter_available_places`
--

LOCK TABLES `twitter_available_places` WRITE;
/*!40000 ALTER TABLE `twitter_available_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `twitter_available_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `twitter_trends_country`
--

DROP TABLE IF EXISTS `twitter_trends_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `twitter_trends_country` (
  `idtwtrendplaces` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) NOT NULL,
  `the_date` date DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `retrieved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `as_of` varchar(30) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idtwtrendplaces`),
  KEY `woeid` (`woeid`),
  KEY `sdoid` (`sdoid`),
  CONSTRAINT `FK_trend_current_country_woeidz` FOREIGN KEY (`woeid`) REFERENCES `country` (`woeid`),
  CONSTRAINT `FK_woeids_tw_trend_places_sdoid` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table is a table of all the twitter trends--> works by country its searchable on whoeid';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twitter_trends_country`
--

LOCK TABLES `twitter_trends_country` WRITE;
/*!40000 ALTER TABLE `twitter_trends_country` DISABLE KEYS */;
/*!40000 ALTER TABLE `twitter_trends_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `twitter_trends_places`
--

DROP TABLE IF EXISTS `twitter_trends_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `twitter_trends_places` (
  `idtwtrendplaces` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) NOT NULL,
  `the_date` date DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `retrieved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `as_of` varchar(30) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`idtwtrendplaces`),
  KEY `woeid` (`woeid`),
  KEY `sdoid` (`sdoid`),
  CONSTRAINT `FK_trend_crnt_place_woeidz` FOREIGN KEY (`woeid`) REFERENCES `places` (`woeid`),
  CONSTRAINT `FK_trend_current_place_woeidz` FOREIGN KEY (`woeid`) REFERENCES `country` (`woeid`),
  CONSTRAINT `FK_woeids_tw_trend_places_more_sdoid` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table is a table of all the twitter trends for all places--> its searchable on woeid';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twitter_trends_places`
--

LOCK TABLES `twitter_trends_places` WRITE;
/*!40000 ALTER TABLE `twitter_trends_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `twitter_trends_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `youtube_country`
--

DROP TABLE IF EXISTS `youtube_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `youtube_country` (
  `idyoutube_country` int(11) NOT NULL AUTO_INCREMENT,
  `sdoid` int(11) NOT NULL,
  `countryname` varchar(50) DEFAULT NULL,
  `yt_cntry_code` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`idyoutube_country`),
  KEY `FK_woeids_country_sdoid` (`sdoid`),
  CONSTRAINT `FK_woeids_country_sdoid` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table is a mapping table; maps youtube country code to places tables on country name';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `youtube_country`
--

LOCK TABLES `youtube_country` WRITE;
/*!40000 ALTER TABLE `youtube_country` DISABLE KEYS */;
/*!40000 ALTER TABLE `youtube_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `youtube_popular`
--

DROP TABLE IF EXISTS `youtube_popular`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `youtube_popular` (
  `idyoutube_popular` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `retrieved_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `the_date` date DEFAULT NULL,
  `linktovideo` varchar(100) DEFAULT NULL,
  `numberofviews` int(11) DEFAULT NULL,
  `nameofvideo` varchar(75) DEFAULT NULL,
  `yt_cntry_code` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`idyoutube_popular`),
  KEY `sdoid` (`sdoid`),
  KEY `woeid` (`woeid`),
  KEY `yt_cntry_code` (`yt_cntry_code`),
  CONSTRAINT `youtube_popular_ibfk_3` FOREIGN KEY (`yt_cntry_code`) REFERENCES `youtubescntry` (`yt_cntry_code`),
  CONSTRAINT `FK_woeids_youttube_sdoid` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`),
  CONSTRAINT `FK_youtube_cnty_woeidz` FOREIGN KEY (`woeid`) REFERENCES `country` (`woeid`),
  CONSTRAINT `youtube_popular_ibfk_1` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`),
  CONSTRAINT `youtube_popular_ibfk_2` FOREIGN KEY (`woeid`) REFERENCES `country` (`woeid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table is a mapping table; maps youtube country_code to woeid';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `youtube_popular`
--

LOCK TABLES `youtube_popular` WRITE;
/*!40000 ALTER TABLE `youtube_popular` DISABLE KEYS */;
/*!40000 ALTER TABLE `youtube_popular` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `youtubescntry`
--

DROP TABLE IF EXISTS `youtubescntry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `youtubescntry` (
  `idyoutubecntry` int(11) NOT NULL AUTO_INCREMENT,
  `woeid` int(11) DEFAULT NULL,
  `sdoid` int(11) NOT NULL,
  `yt_cntry_code` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`idyoutubecntry`),
  KEY `woeid` (`woeid`),
  KEY `sdoid` (`sdoid`),
  KEY `yt_cntry_code` (`yt_cntry_code`),
  CONSTRAINT `youtubescntry_ibfk_1` FOREIGN KEY (`sdoid`) REFERENCES `source_data_orgs` (`sdoid`),
  CONSTRAINT `youtubescntry_ibfk_2` FOREIGN KEY (`woeid`) REFERENCES `country` (`woeid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='table is a mapping table; maps youtube country_code to woeid';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `youtubescntry`
--

LOCK TABLES `youtubescntry` WRITE;
/*!40000 ALTER TABLE `youtubescntry` DISABLE KEYS */;
/*!40000 ALTER TABLE `youtubescntry` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-17  1:55:19
