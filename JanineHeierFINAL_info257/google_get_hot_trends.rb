
#!/usr/local/bin/ruby
class GoogleTrendsWWW
	##most of google trends online content isnt put in the atom feed; so we will make a browser instance to rendder
	#the javascript that actually creates the html that is displayed on the page
	def initialize
		require 'watir-webdriver'
		require 'headless'
		require 'nokogiri'
		require 'rubygems'
		#start up headless, the headless browser!
		@headless = Headless.new
		@headless.start
	end

	
	def get_browswer(url)
		#create the browser instance
		@url = url
		#actually start the browser now!
		@b = Watir::Browser.start @url
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
		#@todays_date = "20131202"
		@div_today = "div.hottrends-trends-list-date-container#" + @todays_date
		@single_day =  @doc.css(@div_today)
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
		##grab how many searches each trend has (aka how many users on google are search for the trend)
		@doc = doc
		@trend_search_numbers = @doc.css("span.hottrends-single-trend-info-line").to_a
		@search_numbers = Array.new
		@trend_search_numbers.each do |trend|
			trend = trend.to_s
			@trend_search_numb = trend.match /\w*,?\w* ?\+/
			if @trend_search_numb
				@trend_search_numb =  @trend_search_numb.to_s
				@trend_search_numb =  @trend_search_numb.chop
				@trend_search_numb =  @trend_search_numb.gsub(/,/, '')
				##clean up the string
				@search_numbers << @trend_search_numb.chomp.strip
			end
		end
		@search_numbers
	end

	def grab_trend_rank(doc)
		##grab the trend's rank on google
		@doc = doc
		@trend_rank_html = @doc.css("span.hottrends-single-trend-index")
		@trend_ranks = Array.new
		@trend_rank_html.each do |trend|
			trend = trend.to_s
			@rank =  trend.match /\d+/
			if @rank
				@rank = @rank.to_s
				##clean up the string
				@trend_ranks << @rank.chomp.strip
			end
		end
		@trend_ranks
	end

	def grab_trend_title(doc)
		##grab the actual trend value from the list
		@doc = doc
		@trend_title_html = @doc.css("span.hottrends-single-trend-title")
		@trend_title = Array.new
		@trend_title_html.each do |trend|
			trend = trend.to_s
			@matches =  trend.match />([\w ]*)</
			if @matches
				@trend_title << @matches[1].chomp.strip
			end
		end
		@trend_title
	end
		
	def get_news_source(doc)
		##grab a link/reference/news source for the trend
		@doc = doc
		@trend_news_html = @doc.css("div.hottrends-single-trend-news-article-container")
		@trend_news_source = Array.new
		@trend_news_html.each do |trend|
			trend = trend.to_s
			@matches = trend.match /href="http:\/\/(www.[.\/a-zA-Z0-9\-]*)"/
			if @matches
				##clean up the string
				@trend_news_source << @matches[1].chomp.strip
			end
		end
		@trend_news_source
	end

	def get_trend_image(doc)
		##grab a link for the image of the trend
		@doc = doc
		@trend_image_html = @doc.css("div.hottrends-single-trend-image-container")
		@trend_image_source = Array.new
		@trend_image_html.each do |trend|
			trend = trend.to_s
			@matches = trend.match /img src="http:\/\/([.\/a-zA-Z0-9\-?=:_]*)/
			if @matches
				##clean up the string
				@trend_image_source << @matches[1].chomp.strip
			end
		end
		@trend_image_source
	end

    ##using headless/watir, automate the the headless browser to go to trend page for each country
    def get_country_specific_trendz(browser, instance)
    	@instance =  instance
    	@b = browser
		sleep(5)
		@f = @b.span :id => "geo-picker-button_caption" 
		@country =  @f.text
		@c = @b.span :class => 'popup-picker-anchor-arrow'
		@c.click
		@d = @b.div :class => 'goog-menu-nocheckbox picker-menu goog-menu'
		@e = @d.div(:class => 'goog-menuitem', :id => @instance)
		@e.click
		return [@country, @b]
	end

	def countrymapping(country)
		@country = country
		if @country == 'France'
			@woeid = 23424819
		elsif @country == 'Germany'
			@woeid =  23424829
		elsif @country == 'Hong Kong'
			@woeid =  24865698
		elsif @country == 'India'
			@woeid = 23424848
		elsif @country == 'Isreal'
			@woeid = 23424852
		elsif @country == 'Japan'
			@woeid = 23424856
		elsif @country == 'Netherlands'
			@woeid = 23424909
		elsif @country == 'Russia'
			@woeid =  23424936
		elsif @country == 'Singapore'
			@woeid = 23424948
		elsif @country == 'United Kingdom'
			@woeid = 23424975
		elsif @country == 'United States'
			@woeid = 23424977
		end
		return @woeid
	end



	def zip_arrays_together(todays_date, country, trend_titles,trend_search_count, trend_rankings, trend_news_sources, trend_image_sources, source_data_id)
	# Zipping multiple arrays together
		@todays_date = todays_date
		@source_data_id =  source_data_id
		@country =  country
		@woeid = countrymapping(country)
		@trend_titles = trend_titles
		@trend_search_count = trend_search_count
		@trend_rankings = trend_rankings
		@trend_news_sources = trend_news_sources
		@trend_image_sources = trend_image_sources
		#make an array to store all the trend info for each country
		@google_trend_list =  Array.new
		@google_trend_list_string =  Array.new
		trend_titles.zip( trend_search_count, trend_rankings, trend_news_sources, trend_image_sources ).each do |title,searchct, trrank, nwsrc, imgsrc |
  			@trend_row = Array.new
  			@trend_row << @woeid.to_s
  			@trend_row << @todays_date.chomp.strip()
  			@trend_row << source_data_id.to_s
  			@trend_row << title
  			@trend_row << searchct.chop
  			@trend_row << trrank.to_s
  			@trend_row << nwsrc 
  			@trend_row << imgsrc
  			@trend_row_string = @trend_row.join("|")
  			@google_trend_list_string << @trend_row_string
  			@google_trend_list << @trend_row
  		end
  		return[ @google_trend_list, @google_trend_list_string ]
  	end

  	def write_trend_rows_to_file (filename, google_trend_list_string)
  		@filename = filename
  		@google_trend_rows = google_trend_list_string
  		begin
  			# Create a new file and write to it  
			@myfile = File.open(@filename, 'a')
			@google_trend_rows_string.each do |trend| 
				trend.each do |t|
					@myfile.puts(t)
				end
			end
  		end
	end

	def mysanitize(string)
		@string = string
		##function to santitze strings to prevent sql injections
   		@safe_string = @string.gsub(/'/, '')
   		return @safe_string
 	end

	def insert_woeids_place_all_info_to_db(google_trend_final_list)
		#insert google hot data into the data; also have to clean it up a little
		@woeids = google_trend_final_list
		@insertst_orig =  'insert into tubes_trends.google_hottrends ( woeid , the_date, sdoid , trending_item, 
			trend_search_count, google_trend_ranking, trend_url, trend_image_url) VALUES '
		begin
			require_relative './MyCoolClasses.rb'
			@db = MyCoolClass.new
			#connect to sql db
			@mydb =  @db.connect_to_sqldb
			@woeids.each do |w|
				#transform certain woeids to sql strings, so you won't have insert problems
				##strings in array that need to be transformed are: [3,4, 13, 15, 16, 17, 18, 19, 20]
				@insertst = @insertst_orig + " ( "
				@mystringnumbs = [3, 6, 7]
				@mystringnumbs.each do |i| 
					@ststf = w[i] 
					if ! @ststf.nil?
						@ststf = mysanitize(@ststf)
						w[i] = "'" + @ststf + "'"
					end
				end
				w.each do |w2|
					###make sure to escape all the weird chars; Don't want a sql injection atttack on the db
					if w2.nil?
						w2 = " '',"
						@insertst = @insertst + w2 
					else
						@insertst = @insertst + w2 + ","
					end
				end
				@insertst = @insertst.chop + "); "
			@mydb.query(@insertst)
			end
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end
	end

end


######MAIN################

##output for log###
puts "starting to grab the hot trends!!" 
puts Time.now

##url to start out at:
url = 'http://www.google.com/trends/hottrends/atom/#pn=p1'
gt = GoogleTrendsWWW.new


#create the headless browser browser
browser = gt.get_browswer(url)

##name of file to write the trend data too; will need to write the file 
google_trends_file = "mydata/google_trends_data.txt"

#here's a list of all the countries!!! in this menu div; dynamically get the countries from the drop-down menu
##so that the script will work even if google changes the web links/addrs to the country trend data. 
ids = [":1", ":2",":3", ":4", ":5", ":6", ":7", ":8", ":9", ":a", ":b", ":c", ":d", ":e"]
#set google's source data id = 2; this number identifies google as the source of data in the db. 
source_data_id =  2


##iterate through list of countries 
ids.each do |instance|
	#get the browser instance for each country
	country, country_browser = gt.get_country_specific_trendz(browser, instance)
	puts country
	##grab the html from the browser. 
	whole_doc = gt.grab_html(country_browser)
	#check to see if the html was updated in the last hour
	updated_in_last_hour = gt.get_last_updated(whole_doc)
	#file name to 
	if updated_in_last_hour
	#get the date and just the trend for today
		todays_date, doc = gt.grab_one_day(whole_doc)
		#get the search count 
		trend_search_count = gt.grab_trend_search_number(doc)
		#get the trend ranking
		trend_rankings = gt.grab_trend_rank(doc)
		#get the actual trend names
		trend_titles = gt.grab_trend_title(doc)
		#get the new source for the trend
		trend_news_sources = gt.get_news_source(doc)
		#get the image sources for the trend
		trend_image_sources = gt.get_trend_image(doc)
		#zipp the arrays together
		google_trend_list, google_trend_list_string =  gt.zip_arrays_together(todays_date, country, trend_titles,trend_search_count, trend_rankings, trend_news_sources, trend_image_sources, source_data_id)
		#write trend data to a file
		#gt.write_trend_rows_to_file( google_trends_file , google_trend_list_string)
		#write trend data to db
		#gt.write_trend_rows_to_db 
		gt.insert_woeids_place_all_info_to_db(google_trend_list)
		
	end
end
##finally destroy the browser- need to do this or will get problems
destroy = gt.destroy_browser(browser)
