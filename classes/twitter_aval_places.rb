 #!/usr/bin/env ruby
####class to load up location data from twttter and yahoo. 


class GetWoeidInfo
	##take a list of woeids and then populate a table; 
	def initialize
		require 'rubygems'
		require 'open-uri'
		#gem install nokogiri
		require 'open-uri'
		require 'nokogiri'
		@api_id = 'JJGO2rnV34E1f_wVM0AwMp0u5d0AB0pEUxPipNRCYKor6h4RiYd5swDa8l71MW32GCo-]'
		@basepage =  'http://where.yahooapis.com/v1/place/'
		@syntax =  '?appid=['
	end

	def get_avail_twitterz_places
		##get a list of places that are trending on twitter; uses this for the base of the project
		require_relative './twitter_get_trends.rb'
		@t = TwitterTrends.new
		@response_trend_availible = @t.make_request_get_response_trend_availible
		@tweets_availible  = @t.parse_trend_availible(@response_trend_availible)
		@twavail = @t.parse_trend_tweets_availible (@tweets_availible)
		@woeids =  Array.new()
		@twavail.each do |c | 
			@woeids << c[6]
		end
		return @woeids
	end

	def get_date
		#function to get the date --> need to put this into the universal methods class at a later point...
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
    return @todays_date
    end
		
		
	def getwoeidinfo(woeid, table_type)
		#method to grab woeid from the yahoo API, depending on the table that you're grabbing info for. 
		@woeid =  woeid
		@table_type  = table_type
		@apiquery =  @basepage + @woeid.to_s + @syntax + @api_id + "]"
		##call yahoo woeid api here:
		@doc = Nokogiri.XML(open(@apiquery).read)
		@place_arry =  Array.new
		##woeid
	 	@woeid =  @doc.xpath('//xmlns:woeid')[0].content
	 	@place_arry << @woeid 
	 	@todays_date = get_date
		@place_arry << @todays_date
		##source data org--> yahoo = 3 
		@place_arry << '3'
	 	#place info
	 	#@placetype =  @doc.xpath('//xmlns:placeTypeName')[0].content
	 	if @table_type  != 'timezone'
	 		@pt  = @doc.xpath('//xmlns:timezone')[0]
  			if ! @pt.nil? 
  				@placetype  =  @doc.xpath('//xmlns:placeTypeName')[0].content
  				@place_arry << @placetype 
  			else
  				@timezone = '0000'
  				@place_arry << @placetype 
  			end
  		end
  		if @table_type  == 'timezone'
  			@place_arry << "TimeZone"
  		end
		#place name
   		@name = @doc.xpath('//xmlns:name')[0].content
   		@place_arry << @name
   		#country --> grab it for the places, don't grab it if we are getting country data
   		if @table_type != 'country'
   			begin
  				@ct = @doc.xpath('//xmlns:country')
  				@ct = @ct[0].attr("woeid")
  				@place_arry << @ct
  			rescue Exception=>e
  				@ct = '0'
  				@place_arry << @ct
  			end
  		end
  		##countrycode
  		begin
  			@ct = @doc.xpath('//xmlns:country')
  			@ct = @ct[0].attr("code")
  			@ct =  "'" + @ct + "'"
  			@place_arry << @ct
  		rescue Exception=>e
  			@ct = "'0'"
  			@place_arry << @ct
  		end
   		#lat/long info
		@latcent = @doc.xpath('//xmlns:latitude')[0].content
		@place_arry << @latcent
  		@longcent =  @doc.xpath('//xmlns:longitude')[0].content
  		@place_arry << @longcent
  		#lat binding
  		@latsw = @doc.xpath('//xmlns:latitude')[1].content
		@place_arry << @latsw
  		@longsw=  @doc.xpath('//xmlns:longitude')[1].content
  		@place_arry << @longsw
  		@latne = @doc.xpath('//xmlns:latitude')[2].content
		@place_arry << @latne
  		@longne =  @doc.xpath('//xmlns:longitude')[2].content
  		@place_arry << @longne
  		#pop rank
  		@poprank = @doc.xpath('//xmlns:popRank')[0].content
  		@place_arry << @poprank
  		#area rank
  		@arearank =  @doc.xpath('//xmlns:areaRank')[0].content
  		@place_arry << @arearank
  		#timezzone 
  		if @table_type  != 'timezone'
  			@tz = @doc.xpath('//xmlns:timezone')[0]
  			if ! @tz.nil? 
  				@timezone =  @doc.xpath('//xmlns:timezone')[0].attr("woeid")
  				@place_arry << @timezone
  			else
  				@timezone = '0000'
  				@place_arry << @timezone
  			end
  		end
  		#place admin
  		begin
  			@admin1type =  @doc.xpath('//xmlns:admin1')
  			@admin1type = @admin1[0].attr("type")
  			@admin1 =  @doc.xpath('//xmlns:admin1')[0].content
  			@place_arry << @admin1type
  			@place_arry << @admin1
  		rescue Exception=>e
  			@admin1type = ''
  			@admin1 = ''
  			@place_arry << @admin1type
  			@place_arry << @admin1
  		end
  		begin
  			@admin2type =  @doc.xpath('//xmlns:admin2')
  			@admin2type = @admin2[0].attr("type")
  			@admin2 =  @doc.xpath('//xmlns:admin2')[0].content
  			@place_arry << @admin2type
  			@place_arry << @admin2
  		rescue Exception=>e
  			@admin2type = ''
  			@admin2 = ''
  			@place_arry << @admin2type
  			@place_arry << @admin2
  		end
  		begin
  			@admin3type =  @doc.xpath('//xmlns:admin3')
  			@admin3type = @admin3[0].attr("type")
  			@admin3 =  @doc.xpath('//xmlns:admin3')[0].content
  			@place_arry << @admin3type
  			@place_arry << @admin3
  		rescue Exception=>e
  			@admin3type = ''
  			@admin3 = ''
  			@place_arry << @admin3type
  			@place_arry << @admin
  		end
  		#@place_arry_str = @place_arry.join("|")
  		##last write the xml object of the api request to used later.
		#write_woeids_to_file2(@file_name, @doc)
  		#return [ @place_arry, @place_arry_str ]
  		return [ @place_arry, @doc]
	end

	def get_woeids_all(woeids, table_type)
		#method to create an array of woeids as arrays and as strings
		@table_type = table_type
		@woeids = woeids
		@woeid_info_all = Array.new
		@woeid_info_all_docs = Array.new
		@woeids.each do | w | 
			@myfinw, @my_doc = getwoeidinfo(w, @table_type)
			@woeid_info_all << @myfinw
			@woeid_info_all_docs << @my_doc
		end
		return [ @woeid_info_all, @woeid_info_all_docs  ]
	end

	def check_woeids_in_db(woeids)
		#method to see if the woeids are already in the places table, don't want duplicates
		@woeids = woeids
		@selectq =  'select woeid from `tubes_trends`.`twitter_available_places`;'
		@new_woeids = Array.new
		begin
			require_relative './MyCoolClasses.rb'
			@db = MyCoolClass.new
			#connect to sql db
			@mydb =  @db.connect_to_sqldb
			@res = @mydb.query(@selectq)
			@dbwoeids = Array.new
			while @row = @res.fetch_hash do
     			@dbwoeids << @row["woeid"]
   			end
   			@res.free
   			@woeids.each do |w|
   				if ! @dbwoeids.include? w
   					@new_woeids << w
   				else
   					next
   				end
   			end
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end
		return @new_woeids
	end

	def insert_twavail_woeids_into_db(woeids)
		##insert the twtter avalible data into the db
		@woeids = woeids
		@todays_date = get_date
		@insertst =  'insert into `tubes_trends`.`twitter_available_places` (woeid, the_date, sdoid ) VALUES '
		begin
			require_relative './MyCoolClasses.rb'
			@db = MyCoolClass.new
			#connect to sql db
			@mydb =  @db.connect_to_sqldb
			@woeids.each do |w| 
				@insertst = @insertst + "( "+ w.to_s + " , " + @todays_date.to_s + ", 1),"
			end
			@insertst = @insertst.chop + ";"
			@mydb.query(@insertst)
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end
	end

	def mysanitize(string)
		##function to santitze strings to prevent sql injections
   		safe_string = string.gsub(/'/, '')
   		return safe_string
 	end

	def insert_woeids_place_all_info(woeid_info_all, table_type)
		#insert yahoo location data into the data; also have to clean it up a little
		@woeids = woeid_info_all
		@table_name = table_type
		if @table_name == 'places'
			@insertst_orig =  'insert into tubes_trends.' + @table_name + '( woeid , the_date, sdoid, placetype, 
			name, country, countrycode, latcent , longcent  , latsw  ,  longsw  , latne , longne , poprank ,  
			arearank ,  timezone, admin1type,  admin1 , admin2type, admin2 , admin3type, admin3 ) VALUES '
 		end
 		if @table_name == 'country'
 			@insertst_orig =  'insert into tubes_trends.' +  @table_name + '( woeid , the_date, sdoid, placetype, 
			name, countrycode, latcent , longcent  , latsw  ,  longsw  , latne , longne , poprank ,  
			arearank ,  timezone, admin1type,  admin1 , admin2type, admin2 , admin3type, admin3 ) VALUES '
 		end
 		if  @table_name == 'timezone'
			@insertst_orig =  'insert into tubes_trends.' + @table_name + '( woeid , the_date, sdoid, placetype, 
			name, country,  countrycode, latcent , longcent  , latsw  ,  longsw  , latne , longne , poprank ,  
			arearank , admin1type,  admin1 , admin2type, admin2 , admin3type, admin3 ) VALUES '
 		end
		begin
			require_relative './MyCoolClasses.rb'
			@db = MyCoolClass.new
			#connect to sql db
			@mydb =  @db.connect_to_sqldb
			@woeids.each do |w|
				#transform certain woeids to sql strings, so you won't have insert problems
				##strings in array that need to be transformed are: [3,4, 13, 15, 16, 17, 18, 19, 20]
				@insertst = @insertst_orig + " ( "
				@mystringnumbs = [3,4,  13, 14, 15, 16, 17, 18, 19, 20]
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
 			#puts @insertst
			@mydb.query(@insertst)
			end
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end
	end

	def write_woeids_to_file(filename, woeid_info_all_docs)
		##write data to a file as a backup copy
  		require_relative './MyCoolClasses.rb'
		wl = MyCoolClass.new
		wl.write_trend_rows_to_file2(filename, woeid_info_all_docs)
	end

	def do_all_the_stuff_for_setup(file_dir_for_data)
		@table_type =  'places'
		@filename = file_dir_for_data + 'places_woeids_raw_data.txt'
		@woeid_gt = get_avail_twitterz_places
		@woeids = check_woeids_in_db(@woeid_gt)
		@woeidsize =  @woeids.size 
		if @woeidsize != 0
			insert_twavail_woeids_into_db(@woeids)
			@woeid_info_all, @woeid_info_all_docs = get_woeids_all(@woeids, @table_type)
			write_woeids_to_file(@filename, @woeid_info_all_docs)
			insert_woeids_place_all_info(@woeid_info_all, @table_type)
		end
	end

end


#this class makes calls to yahoo to get the woeids for a place
class Get_all_avail_coutries  < GetWoeidInfo

	## get a list woeids for a certain geographic demension based on a specific demension
	def get_woeids_for_something(table_type_to,table_type_from)
		require_relative './MyCoolClasses.rb'
		@table_type_to =  table_type_to
		@table_type_from = table_type_from
		@woeids_stuff_list = Array.new
		@db = MyCoolClass.new
		#connect to sql db
		@mydb =  @db.connect_to_sqldb
		@sql1 =  'select distinct ' + @table_type_to + ' from ' + @table_type_from +' where ' + @table_type_to + " is not null and " + @table_type_to + " != '0' and " + table_type_to + "!= 0000;"
		begin
			@rs =  @mydb.query(@sql1)
			@n_rows = @rs.num_rows
			@n_rows.times do
				@woeids_stuff_list << @rs.fetch_row[0]
			end
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end
		@woeids_stuff_list
	end

	##look up each country and get yahoo location data
	def look_up_country_woeid (file_dir_for_data)
		@table_type =  'country'
		@file_dir_for_data = file_dir_for_data
		@table_type_from =  'places'
		##file name to output raw api data to
		@filename = @file_dir_for_data + "country_woeids_raw_data.txt"
		#grab a list of the countries in the data base
		@woeids_country_list  =  get_woeids_for_something(@table_type, @table_type_from)
		##get extra country woeids needed for yoube and google trends
		@extra_countries =  get_extra_countries 
		@woeids_country_list = @woeids_country_list + @extra_countries
		#then get the woeids for all the countries
		@woeid_info_all,@woeid_info_all_docs = get_woeids_all(@woeids_country_list, @table_type)
		#write a xml objects to a file
		write_woeids_to_file(@filename, @woeid_info_all_docs)
		#insert country woeid info into the db.
		insert_woeids_place_all_info(@woeid_info_all, @table_type)
		#clean up the db now that where done
		clean_up_db
	end

	#some countries needed for google hot trends and youtube trens not in the twitter aval. places
	def get_extra_countries
		@place_arry =  Array.new
		@extra_countries_to_get = ['Earth', 'Finland', 'Indonesia', 'Hungary', 'Indonesia', 'Romania', 'Hong+Kong', 'Morocco', 'Czech+Republic', 'Taiwan']
			@extra_countries_to_get.each do | myc |
			##call yahoo woeid api here:
			@apiquery = 'http://where.yahooapis.com/v1/places.q(' + myc +');count=5?appid=[JJGO2rnV34E1f_wVM0AwMp0u5d0AB0pEUxPipNRCYKor6h4RiYd5swDa8l71MW32GCo-'
			@doc = Nokogiri.XML(open(@apiquery).read)
			##woeid
	 		@woeid =  @doc.xpath('//xmlns:woeid')[0].content
	 		@place_arry << @woeid 
	 	end
	 	@place_arry
	end	

	#normalizes the db and removes the countries from the places table
	def clean_up_db
		@mysql_del = "DELETE FROM places where country in (select woeid from country) and placetype = 'Country'"
		@mysql_update1 = "update country set name = 'Indonesia' where name = 'Republik Indonesia'"
		@mysql_update2 = "update country set placetype = 'Country' where name = 'Hong Kong' and placetype = 'Special Administrative Region'"
		@stmts = [@mysql_del, @mysql_update1, @mysql_update2]
		require_relative './MyCoolClasses.rb'
		@db = MyCoolClass.new
		#connect to sql db
		@mydb =  @db.connect_to_sqldb
		@stmts.each do |s|
			begin
				@rs =  @mydb.query(s)
				#@n_rows = @rs.num_rows
				#@n_rows.times do
				#	@woeids_stuff_list << @rs.fetch_row[0]
				#end
			rescue Exception=>e 
				puts "Something went wrong! Could not connect to DB"
				puts e
			end
		end
	end
end

#this class makes calls to yahoo to get the woeids for time
class Get_timezone_info < Get_all_avail_coutries
	def look_up_timezone_woeid (file_dir_for_data)
		@table_type =  'timezone'
		@file_dir_for_data = file_dir_for_data
		@table_type_from =  'places'
		##file name to output raw api data to
		@filename = @file_dir_for_data + "timezone_woeids_raw_data.txt"
		#grab a list of the countries in the data base
		@woeids_timezone_list  =  get_woeids_for_something(@table_type, @table_type_from)
		@woeid_info_all, @woeid_info_all_docs = get_woeids_all(@woeids_timezone_list, @table_type)
		#write a xml objects to a file
		write_woeids_to_file(@filename, @woeid_info_all_docs)
		#insert country woeid info into the db.
		insert_woeids_place_all_info(@woeid_info_all, @table_type)
	end
end


#file_dir_for_data = '../json_data/places/'
#pl = GetWoeidInfo.new
#pl.do_all_the_stuff_for_setup(file_dir_for_data)
#cts = Get_all_avail_coutries.new
#country_stuff = cts.look_up_country_woeid(file_dir_for_data)
#tz  =  Get_timezone_info.new
#timezones =  tz.look_up_timezone_woeid(file_dir_for_data)


#to use

#puts "done with twitter on to youtube"


#yt = YoutubeTrends_setup.new
#yt.youtube_setup_main


