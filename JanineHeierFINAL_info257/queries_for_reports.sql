
 
---Report 1: 
--In the past 5 days, what and in what countries have google ----and twitter had similar trend items ?

select the_date, twitter_retreivedat, google_retreivedat, countryname, twitter_trend, google_trend, 
(twitter_retreivedat - google_retreivedat) as timediff,  google_search_count, latcent, longcent, 
google_trend_image
from (
	select t.the_date, 
	c.name as countryname,
	c.latcent, 
	c.longcent,
	t.retrieved_at as twitter_retreivedat, 
	gt.retrieved_at as google_retreivedat, 
	t.name as twitter_trend,
	trending_item as google_trend, 
	trend_search_count as google_search_count, 
	gt.google_trend_ranking, 
	trend_image_url as google_trend_image 
	from twitter_trends_country
	join country c on t.woeid = c.woeid 
	join  google_hottrends gt on c.woeid = gt.woeid and gt.the_date = t.the_date
	where t.the_date > '2013-12-12'
) z  where twitter_trend like  google_trend
order by twitter_retreivedat desc;



--report drills deeper: Query for where and when google and 
--twitter trends -have been similar:

  select the_date,countryname, twitter_trend, google_trend, latcent, longcent, google_trend_image
 from (
	select t.the_date, 
	c.name as countryname,
	c.latcent, 
	c.longcent,
	t.retrieved_at as twitter_retreivedat, 
	gt.retrieved_at as google_retreivedat, 
	t.name as twitter_trend,
	trending_item as google_trend, 
	trend_search_count  as google_search_count, 
	gt.google_trend_ranking, 
	trend_image_url as google_trend_image 
	from twitter_trends_country t
	join country c on t.woeid = c.woeid 
	join  google_hottrends gt on c.woeid = gt.woeid and gt.the_date = t.the_date
	where t.the_date > '2013-12-12'
) z  where twitter_trend like  google_trend
group by  the_date,countryname, twitter_trend, google_trend,latcent, longcent
order by the_date desc 


--Report number 2:  Find the 35  highest trending/most talked-- --items in the data set; ironically, christmas actually comes --in first place :)
create  temporary table most_popular (the_date date, phrase varchar(100), sdoid int,  countct int) 
--
create  temporary table ipp as select the_date, substring(caption,1,99) , sdoid, count(*) as ct from instgm_popular group by the_date, caption, sdoid
 order by count(*) desc limit 20;
 
 insert most_popular(the_date, phrase, sdoid, countct) select * from  ipp;
 ----
create  temporary table gtp as select the_date, trending_item , sdoid, count(*) as ct from google_hottrends group by the_date, trending_item,sdoid
 order by count(*) desc limit 20;

insert most_popular(the_date, phrase, sdoid, countct) select * from  gtp;

---
create  temporary table ytp as select the_date, videoname , sdoid, count(*) as ct from youtube_popular group by the_date, videoname,sdoid
 order by count(*) desc limit 20;

insert most_popular(the_date, phrase, sdoid, countct) select * from  ytp;
-----

create  temporary table ttc as select the_date, name , sdoid, count(*) as ct from twitter_trends_country group by the_date, name,sdoid
 order by count(*) desc limit 20;

insert most_popular(the_date, phrase, sdoid, countct) select * from  ttc;

--
create  temporary table ttp as select the_date, name , sdoid, count(*) as ct from twitter_trends_places group by the_date, name,sdoid
 order by count(*) desc limit 20;

insert most_popular(the_date, phrase, sdoid, countct) select * from  ttp;

-----
--by day
select * from most_popular order by countct desc 

--overall top item
select phrase , sum(countct) from(  
select phrase,countct from most_popular order by countct desc  
)z group by phrase order by  sum(countct) desc  




----Query for report -----
--Report 3: 
-get twitter trend data for specific cities on a specific day


select distinct p.name,  tp.the_date, tp. name,  p.latcent, p.longcent  from twitter_trends tp
inner join  places p on  tp.woeid = p.woeid
where (p.name = 'San Francisco' and tp.the_date > '2013-12-15' and tp.the_date < '2013-12-17') ;

select distinct p.name, tp.the_date, tp. name,  p.latcent, p.longcent  from twitter_trends tp
inner join  places p on  tp.woeid = p.woeid
where (p.name = 'London' and tp.the_date > '2013-12-15' and tp.the_date < '2013-12-17'); 


select distinct p.name, tp.the_date, tp. name ,  p.latcent, p.longcent  from twitter_trends tp
inner join  places p on  tp.woeid = p.woeid
where (p.name = 'Seattle' and tp.the_date > '2013-12-15' and tp.the_date < '2013-12-17') ;


--the three above queries are equiv. To the one below: 

select distinct p.name, tp.the_date, tp. name ,  p.latcent, p.longcent  from twitter_trends tp
inner join  places p on  tp.woeid = p.woeid
where ((p.name = 'Chicago' or p.name ='Portland' or p.name = 'Austin') and tp.the_date > '2013-12-15' and tp.the_date < '2013-12-17') 
order by p.name

