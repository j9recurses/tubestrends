
#!/usr/local/bin/ruby
require_relative './MyCoolClasses.rb'
class GoogleTrendsWWW2 < MyCoolClass
	##most of google trends online content isnt put in the atom feed; so we will make a browser instance to rendder
	#the javascript that actually creates the html that is displayed on the page
	def initialize
		require 'watir-webdriver'
		require 'headless'
		require 'nokogiri'
		require 'rubygems'
		require 'json'
		#start up headless, the headless browser!
		@headless = Headless.new
		@headless.start
	end


	def get_browswer(url)
		#create the browser instance
		@url = url
		#actually start the browser now!
		@b = Watir::Browser.start :firefox
		@b.goto url
		@b
	end

		#
	def destroy_browser(browser)
		#destroy the browser instance when you finish
		@b = browser
		@b.close
		@headless.destroy
	end


	def grab_html(browser)
		#create a instance of nokogiri, an html parsing tool; this will parse the html that is rendered. 
		@b = browser
		@whole_doc = Nokogiri::HTML(@b.html)
		@whole_doc
	end

	def grab_the_date
		require 'date'
		@date = DateTime.now
		@dateyear = @date.year.to_s 
		@datemonth  = @date.month.to_s
		@dateday = @date.day.to_s
		if @datemonth.size == 1 
			@datemonth = "0" + @datemonth
		end
		if @dateday.size == 1 
			@dateday = "0" + dateday
		end
		@todays_date = @dateyear + @datemonth + @dateday
		@todays_date
	end

	def grab_the_date_yesterday
		require 'date'
		@date = DateTime.now
		@dateyear = @date.year.to_s 
		@datemonth  = @date.month.to_s
		@dateday = @date.day
		@dateday = @dateday  -1 
		@dateday = @dateday.to_s
		if @datemonth.size == 1 
			@datemonth = "0" + @datemonth
		end
		if @dateday.size == 1 
			@dateday = "0" + dateday
		end
		@todays_date = @dateyear + @datemonth + @dateday
		@todays_date
	end



	def grab_one_day(doc)
		##google posts a bunch of trends for multiple days on the page; just grab today's date; we will be collecting the 
		##other days on the days that they are published.
		@doc =  doc
		require 'date'
		@date = DateTime.now
		@dateyear = @date.year.to_s 
		@datemonth  = @date.month.to_s
		@dateday = @date.day.to_s
		if @datemonth.size == 1 
			@datemonth = "0" + @datemonth
		end
		if @dateday.size == 1 
			@dateday = "0" + @dateday
		end
		@todays_date = @dateyear + @datemonth + @dateday
		##if working late, need to put in the date here 
	
		@todays_date = "201410418"

		@div_today = "div.hottrends-trends-list-date-container#" + @todays_date
		
		@single_day =  @doc.css(@div_today)
		puts @single_day.size
		return[@todays_date, @single_day]

	end


	def get_last_updated(whole_doc)
		##google updates their trending data at weird intervals
		##when this script is set to run 1x a hour, so if something was updated 3 hours ago, 
		##then we don't need to grab the trend info because we already have it. 
		@doc =  whole_doc
		@last_update =  @doc.css("span.summary-message-text#summaryMessageText")
		@last_update.each do |trend|
			trend = trend.to_s
			#grab the time that google updated the trends
			@matches = trend.match /Updated about ([\w ]*)ago/ 
			if @matches
				@last_g_update =  @matches[1]
				@updatetime = @last_g_update.split(" ")
				##if its been updated less than hr or an hour ago, grab it; otherwise, ignore
				if @updatetime[0].chomp != "1" and @updatetime[1].chomp == 'minutes'
					return true
				elsif @updatetime[0].chomp == "1" and @updatetime[1].chomp == 'hour'
					return true
				else 
					return false
				end
			end
		end
	end


	def grab_trend_date(doc)
		@doc = doc
		#grab the trending trend date from the header
		@trend_days =  @doc.css("span.hottrends-trends-list-date-header-text").to_a() 
		#convert node to string
		@trend_day =  @trend_days[0].to_s
		@match1 = @trend_day.match />(\w*,? ?\w* ?\w*,? ?\w*)</
		@final_trend_day = @match1[1]
		@final_trend_day
	end


	def grab_trend_search_number(doc)
		@doc = doc
		##grab how many searches each trend has (aka how many users on google are search for the trend)
		@search_numbers = Array.new
		@nodes = @doc.search("//span[@class='hottrends-single-trend-info-line-number']")
		@nodes.each do |node|
   			@trend =  node.to_s
   			@trend_search_numb = @trend.match /\w*,?\w* ?\+/
			if @trend_search_numb
				@trend_search_numb =  @trend_search_numb.to_s
				@trend_search_numb =  @trend_search_numb.chop
				@trend_search_numb =  @trend_search_numb.gsub(/,/, '')
				##clean up the string
				@search_numbers << @trend_search_numb.chomp.strip
			end
		end
		return @search_numbers
	end

	def grab_trend_rank(doc)
		##grab the trend's rank on google
		@doc = doc
		#trend_rank_html = doc.css("span.")
		trend_ranks = Array.new
		nodes = @doc.search("//span[@class='hottrends-single-trend-index']")
		nodes.each do |node|
   			trend =  node.to_s
			rank =  trend.match /\d+/
			if rank
				rank = rank.to_s
				##clean up the string
				trend_ranks << rank.chomp.strip
			end
		end
		trend_ranks
	end

	def grab_trend_title(doc)
		##grab the actual trend value from the list
		doc = doc
		trend_title = Array.new
		nodes = doc.search("//span[@class='hottrends-single-trend-title']")
		nodes.each do |node|
   			trend =  node.to_s
			matches =  trend.match />([\w ]*)</
			if matches
				trend_title << matches[1].chomp.strip
			end
		end
		trend_title
	end
		
	def get_news_source(doc)
		##grab a link/reference/news source for the trend
		doc = doc
		#trend_news_html = doc.css("div.hottrends-single-trend-news-article-container")
		trend_news_source = Array.new
		nodes = doc.search("//div[@class='hottrends-single-trend-news-article-container']")
		nodes.each do |node|
   			trend =  node.to_s
			matches = trend.match /href="http:\/\/(www.[.\/a-zA-Z0-9\-]*)"/
			if matches
				##clean up the string
				trend_news_source << matches[1].chomp.strip
			end
		end
		trend_news_source
	end

	def get_trend_image(doc)
		##grab a link for the image of the trend
		doc = doc
		#trend_image_html = doc.css("div.hottrends-single-trend-image-container")
		trend_image_source = Array.new
		nodes = doc.search("//div[@class='hottrends-single-trend-image-and-text-container']")
		nodes.each do |node|
   			trend =  node.to_s
			matches = trend.match /img src="http:\/\/([.\/a-zA-Z0-9\-?=:_]*)/
			if matches
				##clean up the string
				trend_image_source << matches[1].chomp.strip
			end
		end
		trend_image_source
	end

    ##using headless/watir, automate the the headless browser to go to trend page for each country
    def get_country_specific_trendz(browser, instance)
    	instance =  
    	sleep(15)
    	b = browser
    	country = ''
    	#@today = grab_the_date
    	@today = "201410418"
    	begin
    		#skip over item 2 in the list, its a place holder/empty
    		if instance != 2
    			f = b.span(:class => "popup-picker-anchor-caption")
				country =  f.text
				c = b.span(:class => "popup-picker-anchor-arrow")
				c.click
				#while b.div(:class => "hottrends-trends-list-container").visible? do sleep 1 end
				d = b.div(:class => 'goog-menu-nocheckbox picker-menu goog-menu')
				e = d.div(:id => ":" + instance.to_s)
				e.click
			end
		rescue Exception=>e
			puts e
			puts "something weird happened"
		end
		return [country, b]
	end

	def countrymapping(country, my_country_dict )
		country = country
		my_country_dict = my_country_dict
		woeid =  my_country_dict[country]
	 	return woeid
	end


	def zip_arrays_together(todays_date, country, trend_titles,trend_search_count, trend_rankings, trend_news_sources, trend_image_sources, source_data_id, my_country_dict)
	# Zipping multiple arrays together to make a big array of stuff
		todays_date = todays_date
		source_data_id =  source_data_id
		country =  country
		woeid = countrymapping(country, my_country_dict)
		trend_titles = trend_titles
		trend_search_count = trend_search_count
		trend_rankings = trend_rankings
		trend_news_sources = trend_news_sources
		trend_image_sources = trend_image_sources
		#make an array to store all the trend info for each country
		google_trend_list =  Array.new
		google_trend_list_string =  Array.new
		trend_titles.zip( trend_search_count, trend_rankings, trend_news_sources, trend_image_sources ).each do |title,searchct, trrank, nwsrc, imgsrc |
  			trend_row = Array.new
  			trend_row << woeid.to_s
  			trend_row << todays_date.chomp.strip()
  			trend_row << source_data_id.to_s
  			trend_row << title
  			trend_row << searchct.chop
  			trend_row << trrank.to_s
  			trend_row << nwsrc 
  			trend_row << imgsrc
  			trend_row_string = trend_row.join("|")
  			google_trend_list_string << trend_row_string
  			google_trend_list << trend_row
  		end
  		return[ google_trend_list, google_trend_list_string ]
  	end

	def make_goog_json_obj(google_trend_final_list, filename)
		fields = [ 'woeid' , 'the_date', 'sdoid' , 'title', 'search_count', 'rank', 'url', 'image_url', 'timestamp']
		goog_json_arry = Array.new
		google_trend_final_list.each do | g|
			g << get_timestamp
			my_google_hash = Hash[fields.zip(g)]
			my_google_hash = my_google_hash.to_json
			goog_json_arry << my_google_hash
		end
		write_trend_rows_to_file2( filename, goog_json_arry,)
	end

	#get the woeid's for the hottrends countries; returns a dictionary of woeids
	def get_hottrend_woeids (countries_to_grab)
		countries_to_grab = countries_to_grab
		mysql_qr =  'select woeid, name from country where '
		countries_to_grab.each do |g|
			mysql_qr = mysql_qr + "name = \'" + g + "\' or "
		end
		mysql_qr = mysql_qr[0..-5] + ";"
		require_relative './MyCoolClasses.rb'
		#connect to sql db
		db = MyCoolClass.new
		##make a dictionary to store the results
		my_country_dict = Hash.new
		#connect to sql db
		begin
		mydb =  db.connect_to_sqldb
		rs =  mydb.query(mysql_qr)
		rs.each_hash do |row|
   			 my_country_dict[row['name']] = row['woeid']
		end
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end
		my_country_dict
	end


	######MAIN################
	def goog_main 

		countries_to_grab = ['United States', 'Argentina', 'Austria', 'Australia', 'Belgium', 'Brazil', 'Canada', 'Colombia', 'Chile', 'Czech Republic', 'Denmark', 'France', 'Egypt', 'Finland', 'Germany','Greece','Hong Kong', 'Hungary', 'India', 'Indonesia', 'Israel', 'Italy', 'Japan', 'Kenya', 'Malaysia','Mexico', 'Netherlands', 'Nigeria', 'Norway', 'Philippines', 'Poland', 'Portugal', 'Romania', 'Russia', 'Saudi Arabia', 'Singapore', 'South Africa', 'South Korea', 'Sweden', 'Spain', 'Sweden', 'Switzerland', 'Taiwan', 'Thailand', 'Turkey', 'Ukraine', 'United Kingdom', 'Vietnam' ]
		countries_to_grab = countries_to_grab.sort { |a, b| a <=> b }

		##output for logging purposes--> see what trend countries are being collected ###
		puts "starting to grab the hot trends!!" 
		timenow =  Time.new
		puts timenow.inspect

		##url to start out at:
		url = 'http://www.google.com/trends/hottrends'
		
		my_country_dict = get_hottrend_woeids(countries_to_grab)

		#create the headless browser browser
		browser = get_browswer(url)

		##name of file to write the trend data too; will need to write the file 
		google_trends_file = "../json_data/google/google_trends_" + grab_the_date + ".json"

		#heres a list of all the countries!!! in this menu div; dynamically get the countries from the drop-down menu
		##so that the script will work even if google changes the web links/addrs to the country trend data. 
		ids_letters =  ("a".."z").to_a
		ids_digits = (1..12).to_a
		ids = ids_digits + ids_letters
		#set googles source data id = 2; this number identifies google as the source of data in the db. 
		source_data_id =  2

		##iterate through list of countries 
		america_cnt = 0 
		ids.each do |instance|
			if instance == 2 
				next
			else
				sleep(15)
				puts instance
				#get the browser instance for each country
				country, country_browser = get_country_specific_trendz(browser, instance)
				##grab the html from the browser. 
				whole_doc = grab_html(country_browser)
				#check to see if the html was updated in the last hour
				updated_in_last_hour = get_last_updated(whole_doc)
				#file name to 
				#if updated_in_last_hour
				#get the date and just the trend for today
				todays_date, doc = grab_one_day(whole_doc)
				begin
				#get the search count 
					trend_search_count = grab_trend_search_number(doc)
				#get the trend ranking
					trend_rankings = grab_trend_rank(doc)
				#get the actual trend names
					trend_titles = grab_trend_title(doc)
				#get the new source for the trend
					trend_news_sources = get_news_source(doc)
				#get the image sources for the trend
					trend_image_sources = get_trend_image(doc)
				#zipp the arrays together
					google_trend_list, google_trend_list_string =  zip_arrays_together(todays_date, country, trend_titles,trend_search_count, trend_rankings, trend_news_sources, trend_image_sources, source_data_id, my_country_dict)
				
					if country ==  'United States'
						america_cnt = america_cnt + 1 
						if america_cnt < 2
							#write rows to file 
							puts "******"
							puts "wrote records for " + country + " " +  timenow.inspect
							puts "******"
							make_goog_json_obj(google_trend_list, google_trends_file)
						end
					else
						puts "******"
						puts "wrote records for " + country + " " +  timenow.inspect
						puts "******"
						make_goog_json_obj(google_trend_list, google_trends_file)
					end
				rescue Exception=>e  
						puts "broke here"
						puts instance
						puts doc
						puts e
					end
			end
		end

		##finally destroy the browser- need to do this or will get problems
		destroy = destroy_browser(browser)
	end
end
