
#!/usr/local/bin/ruby
####grab the most recent trends for the top place for where google is getting data for the countries####
##output for log###
puts "#####runnning a trend tube ######"
puts "starting to grab the twitter trends!!" 
puts Time.now
require_relative './twitter_current_trends_now.rb'
require_relative './twitter_get_trends.rb'

######main####
##output for log###
puts "starting to grab the twitter top countries!!" 
puts Time.now
gt =  GetTwiterCurrentTrend.new
t = TwitterTrends.new
twitter_all_trends = Array.new
#get the included woeids
includeplaces =  ['United States', 'Argentina', 'Austria', 'Australia', 'Belgium', 'Brazil', 'Canada', 'Colombia', 'Chile', 'Czech Republic', 'Denmark', 'France', 'Egypt', 'Finland', 'Germany','Greece','Hong Kong', 'Hungary', 'India', 'Indonesia', 'Israel', 'Italy', 'Japan', 'Kenya', 'Malaysia','Mexico', 'Netherlands', 'Nigeria', 'Norway', 'Philippines', 'Poland', 'Portugal', 'Romania', 'Russia', 'Saudi Arabia', 'Singapore', 'South Africa', 'South Korea', 'Sweden', 'Spain', 'Sweden', 'Switzerland', 'Taiwan', 'Thailand', 'Turkey', 'Ukraine', 'United Kingdom', 'Vietnam' ]
require_relative './MyCoolClasses.rb'
woeids_stuff_list = Array.new
db = MyCoolClass.new
#connect to sql db
mydb =  db.connect_to_sqldb
includeplaces.each do |s|
	begin
		mys = "select woeid from country where name = '" + s + "';"
		rs  =  mydb.query(mys)
		n_rows = rs.num_rows
		n_rows.times do
			woeids_stuff_list << rs.fetch_row[0]
		end
	rescue Exception=>e 
		puts "Something went wrong! Could not connect to DB"
		puts e
	end
end

woeids_stuff_list.each do | p |
	begin
		puts p
		#twitter_all_trends <<  trend_row;
		#insert_twitter_trend_rows_into_the_db(twitter_all_trends)
		##twitter has a trend limit of 15 get requests per 15 minute periods; 
		##make one trend request a minute
		#there are 415 places to get, so it will take about 7 hrs for this script to run
		##ex: 415/60 = 6.91 hrs
		##if you go more than 1 request a minute, will go over the rate limit
		sleep(30)
		response_trend_place =  t.make_request_get_response_trend_place(p)
		tweets_place  = t.parse_trend_places(response_trend_place)
		trend_rows, trend_rows_string = t.parse_trend_tweets_place (tweets_place)
		country = 'cntry'
		gt.insert_twitter_trend_rows_into_the_db(trend_rows, country)
		#gt.write_tw_trends_to_file(filetrendbkup, trend_rows_strings)
	rescue Exception=>e  
		puts e
	end
end
