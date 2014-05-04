
require_relative './twitter_aval_places.rb'
require_relative './MyCoolClasses.rb'

class YoutubeTrends_setup <  MyCoolClass
# Get_all_avail_coutries

	def initialize
		require 'watir-webdriver'
		require 'headless'
		require 'nokogiri'
		require 'rubygems'
		require 'json'
		require 'open-uri'
		#start up headless, the headless browser!
		@headless = Headless.new
		@headless.start
	end

	#grap the countries that youtube offers
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
		destroy_browser(b)
		return location_map
	end

	#get the woeids for all the countries
	def get_woeids(location_map)
		place_arry =  Array.new
		location_map = location_map.delete_if{ |key, value| key.to_s.match(/all_\d+/) }
		location_map_vals = location_map.values
		location_map_vals.delete("Countries")
		location_map_vals.each do | myc |
			myc =  myc.gsub(" ", "+")
			##call yahoo woeid api here:
			apiquery = 'http://where.yahooapis.com/v1/places.q(' + myc +');count=5?appid=[JJGO2rnV34E1f_wVM0AwMp0u5d0AB0pEUxPipNRCYKor6h4RiYd5swDa8l71MW32GCo-'
			newdoc = Nokogiri.XML(open(apiquery).read)
			##woeid
	 		woeid =  newdoc.xpath('//xmlns:woeid')[0].content
	 		place_arry << woeid 
	 	end
	 	place_arry
	end

	#check to see if the woeids exist in the db
	def check_woeids(place_arry)
		db = connect_to_sqldb
		mysql0 = "DROP TEMPORARY TABLE IF EXISTS mywoeid;"
		generic_insert(mysql0, db);
		mysql1 = "CREATE TEMPORARY TABLE mywoeid ( woeid INT);"
		generic_insert(mysql1, db)
		place_arry.each do |p |
			mysql2 = "insert into mywoeid VALUES ( " + p +" );"
			generic_insert(mysql2, db)
		end
		missing_c = Array.new
		mysql3 = "SELECT woeid from mywoeid where woeid not in (select woeid from country);"
		rs = generic_insert(mysql3, db)
		rs.each_hash do |row|
   			 missing_c << row['woeid']
		end
		puts missing_c
		missing_c
	end

	#insert the missing country woeid info into the db
	def insert_missing_countries_youtube (missing_c)
		twa = Get_all_avail_coutries.new
		table_type = 'country'
		woeid_info_all, woeid_info_all_docs = twa.get_woeids_all(missing_c, table_type)
		#insert country woeid info into the db.
		twa.insert_woeids_place_all_info(woeid_info_all, table_type)
	end

	#main part of job
	def youtube_setup_main
		begin 
    		sleep(10)
			location_map = start_grabbin
			place_arry = get_woeids(location_map)
			missing_c = check_woeids(place_arry)
			insert_missing_countries_youtube (missing_c)
		rescue Exception=>e  
			puts "broke here"
			puts e
		end
	end

end

#setup db first
#cool = All_my_classes.new
#cool.mymain

yt = YoutubeTrends_setup.new
yt.youtube_setup_main