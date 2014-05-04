
#!/usr/local/bin/ruby
#require_relative 'google_get_hot_trends.rb'

require_relative './MyCoolClasses.rb'

class YahooTrends < MyCoolClass

	def initialize
		require 'watir-webdriver'
		require 'headless'
		require 'nokogiri'
		require 'rubygems'
		require 'json'
		require 'open-uri'
		#start up headless, the headless browser!
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
	
	def grabtrends (sdoid, mydb)
		url = "www.yahoo.com"
		my_yahoo_json =  Array.new
		doc = Nokogiri::HTML(open('https://www.yahoo.com'))
		nodes = doc.search("//ol[@class='lh-192 trendingnow_trend-list fw-b']")
		nodes.each do |node|
			trends = node.text
			trend_parts = trends.split(/(\d+)/)
			trend_parts.shift
			#puts trend_parts
   			##make each line to insert into the db
   			trend_parts.each_slice(2) do |chunk|
   				rank = mysanitize(chunk [0])
   				title = "'" + mysanitize(chunk[1]) + "'"
   				if not rank.empty? and rank.to_i < 11
   					the_date = grab_the_date
   					trend_line = Array.new
   					trend_line << the_date
   					trend_line << sdoid
  					trend_line << rank
  					trend_line << title
  				#trend_row =  trend_line.join (", ")
  				#mysql2 =  "insert into `tubes_trends`.`yahoo_trends` (the_date, sdoid, rank, title) select " + trend_row + ";"
				#generic_insert(mysql2, mydb)
				##also make a json object
  					trend_json_line = make_yahoo_json_obj(trend_line)
  					my_yahoo_json << trend_json_line
  				end
   			end
		end
		return my_yahoo_json
	end

	def make_yahoo_json_obj(trend_line)
		if trend_line.size == 4
			fields = ['the_date', 'sdoid', 'rank', 'title', 'timestamp']
			trend_line << get_timestamp
			my_yahoo_hash = Hash[fields.zip(trend_line)]
			my_yahoo_hash = my_yahoo_hash.to_json
		end
		return my_yahoo_hash 
	end

	##main function
	def yahoo_trends_main
		the_date =  grab_the_date
		
		 #create a unique file name
    counter = 0
    letter_array =  ('a'..'z').to_a
    today =  grab_the_date
    basedir =  '/mnt/s3/tubes_trends_orig/json_data/'
    network = 'yahoo/'
    today_dir = today + "/"
    file_dir = basedir+network +today_dir
    ch_directory_exists(file_dir)
    filename = file_dir + 'yahoo_trends_' + grab_the_date + "_" + letter_array[counter]+ ".json"
    while (  File.exist?filename)
      	filename = file_dir + '/yahoo_trends_' + grab_the_date + "_" + letter_array[counter]+ ".json"
      	counter = counter + 1
    end


		sdoid, mydb = get_sdoid('yahoo')
		my_yahoo_json = grabtrends(sdoid, mydb)
		write_trend_rows_to_file2(filename, my_yahoo_json)
	end

end

#to use:
yt = YahooTrends.new
yt.yahoo_trends_main



