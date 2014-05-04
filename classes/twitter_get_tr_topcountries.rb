
#!/usr/local/bin/ruby

#encoding:utf-8

####grab the most recent trends for the top place for where google is getting data for the countries####
require_relative './MyCoolClasses.rb'
require_relative './twitter_current_trends_now.rb'
require_relative './twitter_get_trends.rb'

class Twitter_Get_Top_Countries < GetTwiterCurrentTrend

	def twitter_top_countries_main 
		puts "#####runnning a trend tube --> ######"
		######main####
		##output for log###
		puts "starting to grab the twitter top countries!!" 
		puts Time.now
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
				mys = "select woeid from country where name = '" + s + "'  and woeid in (select woeid from twitter_available_places);"
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
		

		#set the file name
		counter = 0
		letter_array =  ('a'..'z').to_a
    #check and create dir structure
    today =  grab_the_date
    basedir =  '/mnt/s3/tubes_trends_orig/json_data/'
    network = 'twitter/'
    today_dir = today + "/"
    file_dir = basedir+network +today_dir
    ch_directory_exists(file_dir)

			filetrendbkup = file_dir +  "twitter_trends_country_" + grab_the_date  + "_" + letter_array[counter]+ ".json"
			

		while (  File.exist?filetrendbkup)
				filetrendbkup = file_dir + "twitter_trends_country_" + grab_the_date  + "_" + letter_array[counter]+ ".json"
			counter = counter + 1 
		end





		woeids_stuff_list.each do | p |
			begin
				puts p
				sleep(60)
				country = 'cntry'
				response_trend_place =  t.make_request_get_response_trend_place(p, country)
				if response_trend_place.size != 0 
					tweets_place  = t.parse_trend_places(response_trend_place)
					trend_rows, trend_rows_string = t.parse_trend_tweets_place (tweets_place)
					#insert_twitter_trend_rows_into_the_db(trend_rows, country)
					make_twitter_json_obj(trend_rows, filetrendbkup)
					puts "wrote row"
				else 
					next
				end
			rescue Exception=>e  
				puts e
			end
		end
	end
end

##to use
ct = Twitter_Get_Top_Countries.new
ct.twitter_top_countries_main 
