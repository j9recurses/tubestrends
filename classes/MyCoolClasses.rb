#!/usr/local/bin/ruby

###class to where functions can be used over and over again

class MyCoolClass
	require 'watir-webdriver'
	require 'headless'
	require 'nokogiri'
	require 'rubygems'
	require 'json'
	require 'open-uri'

	def initialize
		require 'rubygems'
	end

	def connect_to_sqldb
		#gem install mysql
		require 'mysql'
		#db parameters: 
		@user = 'j9'
		@password =  'chichi13'
		@database =  'tubes_trends'
		@host = 'localhost'
		begin
  		@db = Mysql.new(@host, @user, @password, @database)
		rescue Mysql::Error
  		puts "Oh noes! We could not connect to our database. -_-;;"
 		exit 1
		end
		@db
	end

	def mysanitize(mystring)
		mystring = mystring.to_s
		##function to santitze strings to prevent sql injections
   		safe_string = mystring.gsub(/'/, '')
   		safe_string = mystring.gsub(/'?'/, '')
   		return safe_string
 	end

	def generic_insert(insert_stmt, db)
		begin
			myresults = db.query(insert_stmt)
		rescue Exception=>e 
			puts insert_stmt
			puts "Something went wrong! Could not insert the data"
			puts e
		end
	end


	def write_trend_rows_to_file (filename, list)
  		filename = filename
  		list = list
  		begin
  			# Create a new file and write to it  
			myfile = File.open(filename, 'a')
			list.each do |trend| 
				trend.each do |t|
					myfile.puts(t)
				end
			end
  		end
	end	

	def write_trend_rows_to_file2 (filename, json_arry)
  		list = json_arry
  		begin
  			# Create a new file and write to it  
			myfile = File.open(filename, 'a+')
			list.each do |trend| 
				@cooltrend =  trend
				#puts @cooltrend 
				myfile.puts(@cooltrend )
				end
			myfile.close
  		end
	end

	def get_timestamp
		time = Time.new
		time.strftime("%Y-%m-%d %H:%M:%S")
		time
	end

	def get_sdoid(source_data_org)
		db = MyCoolClass.new
		mysql1 = "select sdoid from source_data_orgs where name = '"+ source_data_org + "';"
		#connect to sql db
		sdoid  = ''
		begin
		mydb =  db.connect_to_sqldb
		rs =  mydb.query(mysql1)
		rs.each_hash do |row|
   			sdoid = row['sdoid']
		end
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end
		return sdoid
	end

	def grab_the_date
		require 'date'
		date = DateTime.now
		dateyear = date.year.to_s 
		datemonth  = date.month.to_s
		dateday = date.day.to_s
		if datemonth.size == 1 
			datemonth = "0" + datemonth
		end
		if dateday.size == 1 
			dateday = "0" + dateday
		end
		todays_date = dateyear + datemonth + dateday
		todays_date
	end

	def get_browswer(url)
		#create the browser instance
		@url = url
		#actually start the browser now!
		@b = Watir::Browser.start @url
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
		date = DateTime.now
		dateyear = date.year.to_s 
		datemonth  = date.month.to_s
		dateday = date.day.to_s
		if datemonth.size == 1 
			datemonth = "0" + datemonth
		end
		if dateday.size == 1 
			dateday = "0" + dateday
		end
		todays_date = dateyear + datemonth + dateday
		todays_date
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

		#get the woeid's for the hottrends countries; returns a dictionary of woeids
	def get_woeids (countries_to_grab)
		countries_to_grab = countries_to_grab
		mysql_qr =  'select distinct woeid, name from country where '
		countries_to_grab.each do |g|
			mysql_qr = mysql_qr + "name = \'" + g + "\' or "
		end
		mysql_qr = mysql_qr[0..-5] + ";"
		require_relative './MyCoolClasses.rb'
		##make a dictionary to store the results
		my_country_dict = Hash.new
		#connect to sql db
		begin
		mydb =  connect_to_sqldb
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

  def ch_directory_exists(directory)
    cool = File.directory?(directory)
    if not cool
      require 'fileutils'
      FileUtils::mkdir_p directory
    end
  end


    
end



