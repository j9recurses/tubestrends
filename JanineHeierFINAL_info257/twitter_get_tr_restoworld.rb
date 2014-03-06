#!/usr/local/bin/ruby
####grab the most recent trends for the top places####

##output for log###
puts "#####runnning a trend tube ######"
puts "starting to grab the twitter trends!!" 
puts Time.now
require_relative './twitter_current_trends_now.rb'
gt =  GetTwiterCurrentTrend.new
filetrendbkup =  "mydata/twitter_current_trends.txt"
woeids = gt.getwoeidstolookup
require_relative './twitter_get_trends.rb'
t = TwitterTrends.new
excludeplaces = [ '1', '23424819' , '23424829' , '23424848' ,'23424909' , '23424936' , '23424948' , '2342497' , '23424977']
twitter_all_trends = Array.new
counter = 0
woeids.each do | w |
	if not excludeplaces.include?(w)
		puts w
		time = Time.new
		timemin =  time.min 
		until timemin > 10 do
			sleep(60)
		end 
		#twitter_all_trends <<  trend_row;
		#insert_twitter_trend_rows_into_the_db(twitter_all_trends)
		##twitter has a trend limit of 15 get requests per 15 minute periods; 
		##make one trend request a minute
		#there are 415 places to get, so it will take about 7 hrs for this script to run
		##ex: 415/60 = 6.91 hrs
		##if you go more than 1 request a minute, will go over the rate limit
		###so, we're running the world wide trends hourly, so we need to hold back this script back 
		##for the first 10 min of each hour so we can let the other twitter script run and not go over the
		##rate limit
		if timemin > 10
			begin
			sleep(60)
				response_trend_place =  t.make_request_get_response_trend_place(w)
				tweets_place  = t.parse_trend_places(response_trend_place)
				trend_rows, trend_rows_string = t.parse_trend_tweets_place (tweets_place)
				country = 'all'
				gt.insert_twitter_trend_rows_into_the_db(country)
				#gt.write_tw_trends_to_file(filetrendbkup, trend_rows_strings)
			rescue Exception=>e  
				puts e
			end
		end
	end
end
