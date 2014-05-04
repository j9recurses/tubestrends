
#!/usr/local/bin/ruby
#encoding:utf-8

####class to twitter request calls for places#####
require_relative './MyCoolClasses.rb'
require_relative './twitter_current_trends_now.rb'
require_relative './twitter_get_trends.rb'


class Twitter_get_tr_restoworld  < GetTwiterCurrentTrend 
	def excluded_country_places
		excludeplaces =  ['United States', 'Argentina', 'Austria', 'Australia', 'Belgium', 'Brazil', 'Canada', 'Colombia', 'Chile', 'Czech Republic', 'Denmark', 'France', 'Egypt', 'Finland', 'Germany','Greece','Hong Kong', 'Hungary', 'India', 'Indonesia', 'Israel', 'Italy', 'Japan', 'Kenya', 'Malaysia','Mexico', 'Netherlands', 'Nigeria', 'Norway', 'Philippines', 'Poland', 'Portugal', 'Romania', 'Russia', 'Saudi Arabia', 'Singapore', 'South Africa', 'South Korea', 'Sweden', 'Spain', 'Sweden', 'Switzerland', 'Taiwan', 'Thailand', 'Turkey', 'Ukraine', 'United Kingdom', 'Vietnam' ]
		require_relative './MyCoolClasses.rb'
		woeids_stuff_list = Array.new
		db = MyCoolClass.new
		#connect to sql db
		mydb =  db.connect_to_sqldb
		excludeplaces.each do |s|
			begin
				mys = "select woeid from country where name = '" + s + "' and woeid in (select woeid from twitter_available_places);"
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
		return woeids_stuff_list
	end
	
	def get_world_wide_trends
		
		counter = 0
		letter_array =  ('a'..'z').to_a
    #check and create dir structure
    today =  grab_the_date
    basedir =  '/mnt/s3/tubes_trends_orig/json_data/'
    network = 'twitter/'
    today_dir = today + "/"
    file_dir = basedir+network +today_dir
    ch_directory_exists(file_dir)


    filetrendbkup_world = file_dir + "twitter_trends_places_" + grab_the_date + "_" + letter_array[counter]+ ".json"
			

		while (File.exist?filetrendbkup_world)
			filetrendbkup_world = file_dir + "twitter_trends_places_" + grab_the_date + "_" + letter_array[counter]+ ".json"
			counter = counter + 1 
		end

		excludeplaces = excluded_country_places
		##output for log###
		puts "#####runnning a trend tube ######"
		puts "starting to grab the twitter trends for the rest of the world!!" 
		puts Time.now
		gt =  GetTwiterCurrentTrend.new
		woeids = gt.getwoeidstolookup
		t = TwitterTrends.new
		twitter_all_trends = Array.new
		counter = 0
		woeids.each do | w |
			if not excludeplaces.include?(w)
				puts w
				time = Time.new
				timemin =  time.min 
				
				#sleep(60) 
				##twitter has a trend limit of 15 get requests per 15 minute periods; 
				##make one trend request a minute
				#there are 415 places to get, so it will take about 7 hrs for this script to run
				##ex: 415/60 = 6.91 hrs
				##if you go more than 1 request a minute, will go over the rate limit
				###so, we're running the world wide trends hourly, so we need to hold back this script back 
				##for the first 10 min of each hour so we can let the other twitter script run and not go over the
				##rate limit
		
					begin
						sleep(60)
						country = 'world'
						response_trend_place =  t.make_request_get_response_trend_place(w, country)
						tweets_place  = t.parse_trend_places(response_trend_place)
						trend_rows, trend_rows_string = t.parse_trend_tweets_place (tweets_place)
            puts trend_rows
						country = 'all'
						#insert_twitter_trend_rows_into_the_db(trend_rows, country
						make_twitter_json_obj(trend_rows, filetrendbkup_world)
						puts "wrote a row"
					rescue Exception=>e  
						puts e
					end
				
			end
		end
	end
end

twrw = Twitter_get_tr_restoworld.new
mystuff = twrw.get_world_wide_trends


