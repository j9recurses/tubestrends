
#!/usr/local/bin/ruby
####grab the most recent trends for the top places####
##output for log###
puts "#####runnning a trend tube ######"
puts "starting to grab the twitter trends!!" 
puts Time.now
require_relative './twitter_current_trends_now.rb'


######main####
##output for log###
puts "starting to grab the twitter top countries!!" 
puts Time.now

gt =  GetTwiterCurrentTrend.new
woeids = [1, 23424819 , 23424829 , 23424848 , 23424909 , 23424936 , 23424948 , 23424975 , 23424977]
require_relative './twitter_get_trends.rb'
t = TwitterTrends.new
twitter_all_trends = Array.new

woeids.each do | w |
	begin
		puts w
		#twitter_all_trends <<  trend_row;
		#insert_twitter_trend_rows_into_the_db(twitter_all_trends)
		##twitter has a trend limit of 15 get requests per 15 minute periods; 
		##make one trend request a minute
		#there are 415 places to get, so it will take about 7 hrs for this script to run
		##ex: 415/60 = 6.91 hrs
		##if you go more than 1 request a minute, will go over the rate limit
		sleep(60)
		response_trend_place =  t.make_request_get_response_trend_place(w)
		tweets_place  = t.parse_trend_places(response_trend_place)
		trend_rows, trend_rows_string = t.parse_trend_tweets_place (tweets_place)
		country = 'cntry'
		gt.insert_twitter_trend_rows_into_the_db(trend_rows, country)
		#gt.write_tw_trends_to_file(filetrendbkup, trend_rows_strings)
	rescue Exception=>e  
		puts e
	end
end
