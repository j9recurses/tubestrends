#!/usr/local/bin/ruby
#encoding:utf-8

require_relative './MyCoolClasses.rb'


class YoutubeTrends < MyCoolClass

	def initialize
		require 'watir-webdriver'
		require 'headless'
		require 'nokogiri'
		require 'rubygems'
		require 'json'
		require 'open-uri'
		#start up headless, the headless browser!
		#@headless = Headless.new(display: 101,destroy_at_exit: false,reuse:true)@headless.start
    #start up headless, the headless browser!
    # so the headless gem would default to using the :99 display.
    # This was all fine and good when running the scripts individually.
    # But if you run multiple scripts that try to use the same display,
    # the first script gets disconnected from the headless session
    # and the second script takes over.
    display = Random.rand(2..1000)
    @headless = Headless.new(:display => display)
    @headless.start
	end

	def start_grabbin
		url = "http://www.youtube.com/trendsdashboard"
		myhome = ''
		#create the headless browser browser
		b = get_browswer(url)
		doc = b.div(:id  => "filter-groups").wait_until_present
		##grab the html from the browser. 
		@mydoc = grab_html(@b)
		#@placeselector = @doc.css("div")
		cool = @mydoc.search("//select[@class='trends-filter-loc trends-filter']")
		location_map = Hash[ cool.css('option').map{ |o| [o['value'], o.text] }]
		[location_map, b]
	end

	def get_woeid_list(location_map)
		#eliminate the woeids aren't countries
		location_map = location_map.delete_if{ |key, value| key.to_s.match(/all_\d+/) }
		location_map_vals = location_map.values
		location_map_vals.delete("Countries")
		my_country_dict = get_woeids(location_map_vals)
		my_country_dict 
	end

	 def get_country_specific_trendz(browser, country)
    	sleep(10)
    	b = browser
    	@today = grab_the_date
    	#@today = "201410418"
    	begin
    		cool = b.select_list(:class, 'trends-filter-loc trends-filter').option(:text, country).exists?
    		if cool
    			b.select_list(:class, 'trends-filter-loc trends-filter').option(:text, country).when_present.select
    			newdoc = b.div(:id  => "videos-0-items").wait_until_present
    		end
		rescue Exception=>e
			puts e
			puts "something weird happened"
		end
		return b
	end

	def get_trend_stuff(countrydoc,  country, woeid, sdoid, todays_date)
		otherstuff = countrydoc.search("//div[@class='video-item-info']")
		rank = countrydoc.search("//div[@class='video-item-num']").map{ |node| node.text }
		title = otherstuff.search("//h4/a").map{ |node| node.text }
		hrefz = otherstuff.search("//h4/a/@href").map{ |node| "http://www.youtube.com" + node.text }
		views = countrydoc.search("//div[@class='video-item-info']").map{ |node| node.text }
		new_views = Array.new
		views.each do |v|
			v = v.to_s
			matches = v.match /\S+ views/
			if matches
				v =  matches[0]
				v.to_s
				v = v.gsub(/,/, '')
				v = v.gsub(/views/, '')
				new_views << v
			end
		end
		trend_list =  Array.new
		trend_list_string =  Array.new
		rank.zip( title, hrefz, new_views ).each do |r, t, z, v|
  			trend_row = Array.new
  			trend_row << woeid.to_s
  			trend_row << todays_date
  			trend_row << sdoid
  			trend_row << t
  			trend_row << v
  			trend_row << r.to_s
  			trend_row << z
  			trend_row << get_timestamp
  			trend_list << trend_row
  		end
  		trend_list
	end

	def make_goog_json_obj(trend_list, filename)
		fields = [ 'woeid' , 'the_date', 'sdoid' , 'title', 'view_count', 'rank', 'url', 'timestamp']
		yt_json_arry = Array.new
		trend_list.each do | g|
			my_yt_hash = Hash[fields.zip(g)]
			my_yt_hash = my_yt_hash.to_json
			yt_json_arry << my_yt_hash
		end
		write_trend_rows_to_file2( filename, yt_json_arry,)
	end


	def youtube_main
    b = ''
		begin 
    		sleep(40)
    	  counter = 0
			  letter_array =  ('a'..'z').to_a
        #check and create dir structure
        today =  grab_the_date
        basedir =  '/mnt/s3/tubes_trends_orig/json_data/'
        network = 'youtube/'
        today_dir = today + "/"
        file_dir = basedir+network +today_dir
        ch_directory_exists(file_dir)
		

			  ##name of file to write the trend data too; will need to write the file
			  youtube_trends_file = file_dir + "youtube_trends_" +grab_the_date+ "_" + letter_array[counter]+ ".json"

			  while ( File.exist?youtube_trends_file)
				  youtube_trends_file = file_dir + "youtube_trends_" +grab_the_date+  "_"+ letter_array[counter]+ ".json"
				  counter = counter + 1
			  end

			  location_map, b = start_grabbin
			  sdoid =  get_sdoid('youtube')
			  todays_date = grab_the_date
			  countries_dict = get_woeid_list(location_map)
			  puts "here!"
			  countries_dict.each do |country, woeid|
				  sleep(10)
				  puts "writing records for " + country
				  b = get_country_specific_trendz(b, country)
				  countrydoc = grab_html(b)
				  trend_list = get_trend_stuff(countrydoc, country, woeid, sdoid, todays_date)
				  make_goog_json_obj(trend_list, youtube_trends_file)
			  end
		rescue Exception=>e
			puts "broke here"
			puts e
    end
    destroy = destroy_browser(b)
	end

end

##name of file to write the trend data too; will need to write the file
yt =  YoutubeTrends.new
yt.youtube_main
