
#!/usr/local/bin/ruby
####class to twitter request calls#####
<<<<<<< HEAD
class GetTwiterCurrentTrend
	def initialize 
		@yes =  "yes"
=======
require_relative './MyCoolClasses.rb'

class GetTwiterCurrentTrend < MyCoolClass
	def initialize 
		yes =  "yes"
>>>>>>> a1f2c31dab110704c5c4ab478a514e2384d1d87f
	end

	def getwoeidstolookup
		require_relative './MyCoolClasses.rb'
<<<<<<< HEAD
		@db = MyCoolClass.new
		@selectq =  "select woeid from places"
		@woeids = Array.new
		#connect to sql db
		@mydb =  @db.connect_to_sqldb
		@res = @mydb.query(@selectq)
		while @row = @res.fetch_hash do
     		@woeids << @row["woeid"]
   		end
   		@selectq =  "select woeid from country"
		#connect to sql db
		@mydb =  @db.connect_to_sqldb
		@res = @mydb.query(@selectq)
		while @row = @res.fetch_hash do
     		@woeids << @row["woeid"]
   		end
   		return @woeids
   	end

   	def mysanitize(string)
   		@string = string
		##function to santitze strings to prevent sql injections
   		@safe_string = string.gsub(/'/, '')
   		return @safe_string
 	end
 
	def insert_twitter_trend_rows_into_the_db(twitter_all_trends, country )
		@country = country
		puts @country
		@twitter_all_trends = twitter_all_trends
		begin
			require_relative './MyCoolClasses.rb'
			@db = MyCoolClass.new
			#connect to sql db
			@mydb =  @db.connect_to_sqldb
			@selectq =  "select woeid from country"
			@woeidscntry = Array.new
			@res = @mydb.query(@selectq)
			while @row = @res.fetch_hash do
     			@woeidscntry << @row["woeid"]
   			end
			@twitter_all_trends.each do |w|
				## check to see if the trend is a place or a country: 
				if @country == 'all' 
					@insertst_orig = 'insert into twitter_trends_places (' 
					if @woeidscntry.include?(w)
						@insertst_orig = 'insert into twitter_trends_country (' 
					end
				elsif @country == 'cntry'
					@insertst_orig = 'insert into twitter_trends_country (' 
				end
					@insertst_orig = @insertst_orig  + "woeid, the_date, sdoid, as_of, name, url) VALUES"
				##do some data cleaning
				@insertst = @insertst_orig + " ( "
				@insertst = @insertst_orig + " ( "
				@mystringnumbs = [3,4,5]
				@mystringnumbs.each do |i| 
					@ststf = w[i] 
					if ! @ststf.nil?
						@ststf = mysanitize(@ststf)
						w[i] = "'" + @ststf + "'"
=======
		db = MyCoolClass.new
		selectq =  "select distinct woeid from places where woeid in (select woeid from twitter_available_places);"
		woeids = Array.new
		#connect to sql db
		mydb =  db.connect_to_sqldb
		res = mydb.query(selectq)
		while row = res.fetch_hash do
     		woeids << row["woeid"]
   		end
   		selectq =  "select distinct woeid from country where woeid in (select woeid from twitter_available_places);"
		#connect to sql db
		mydb =  db.connect_to_sqldb
		res = mydb.query(selectq)
		while row = res.fetch_hash do
     		woeids << row["woeid"]
   		end
   		return woeids
   	end

   	def mysanitize(string)
   		string = string
		##function to santitze strings to prevent sql injections
   		safe_string = string.gsub(/'/, '')
   		return safe_string
 	end
 
	def insert_twitter_trend_rows_into_the_db(twitter_all_trends, country )
		country = country
		twitter_all_trends = twitter_all_trends
		begin
			require_relative './MyCoolClasses.rb'
			db = MyCoolClass.new
			#connect to sql db
			mydb =  db.connect_to_sqldb
			selectq =  "select woeid from country"
			woeidscntry = Array.new
			res = mydb.query(selectq)
			while row = res.fetch_hash do
     			woeidscntry << row["woeid"]
   			end
			twitter_all_trends.each do |w|
				## check to see if the trend is a place or a country: 
				if country == 'all' 
					insertst_orig = 'insert into twitter_trends_places (' 
					if woeidscntry.include?(w)
						insertst_orig = 'insert into twitter_trends_country (' 
					end
				elsif country == 'cntry'
					insertst_orig = 'insert into twitter_trends_country (' 
				end
					insertst_orig = insertst_orig  + "woeid, the_date, sdoid, as_of, title, url) VALUES"
				##do some data cleaning
				insertst = insertst_orig + " ( "
				insertst = insertst_orig + " ( "
				mystringnumbs = [3,4,5]
				mystringnumbs.each do |i| 
					ststf = w[i] 
					if ! ststf.nil?
						ststf = mysanitize(ststf)
						w[i] = "'" + ststf + "'"
>>>>>>> a1f2c31dab110704c5c4ab478a514e2384d1d87f
					end
				end
				w.each do |w2|
					###make sure to escape all the weird chars; Don't want a sql injection atttack on the db
					if w2.nil?
						w2 = " '',"
<<<<<<< HEAD
						@insertst = @insertst + w2 
					else
						@insertst = @insertst + w2 + ","
					end
				end
				@insertst = @insertst.chop + "); "
			@mydb.query(@insertst)
=======
						insertst = insertst + w2 
					else
						insertst = insertst + w2 + ","
					end
				end
				insertst = insertst.chop + "); "
			mydb.query(insertst)
>>>>>>> a1f2c31dab110704c5c4ab478a514e2384d1d87f
			end
		rescue Exception=>e 
			puts "Something went wrong! Could not insert data for " + country
		end	
	end
	
<<<<<<< HEAD

   	def write_tw_trends_to_file(filename, trend_rows_string)
    	##write data to a file as a backup copy
      	require_relative './MyCoolClasses.rb'
    	wl = MyCoolClass.new
    	wl.write_trend_rows_to_file2(filename, woeid_info_all_strings)
  	end
=======
	def make_twitter_json_obj(twitter_all_trends, filename)
		fields = [ 'woeid' , 'the_date', 'sdoid' , 'as_of', 'title', 'url', 'timestamp']
		twitter_json_arry = Array.new
		twitter_all_trends.each do | g|
			g << get_timestamp
			my_twitter_hash = Hash[fields.zip(g)]
			my_twitter_hash = my_twitter_hash.to_json
			twitter_json_arry << my_twitter_hash
		end
		write_trend_rows_to_file2( filename, twitter_json_arry)
	end
>>>>>>> a1f2c31dab110704c5c4ab478a514e2384d1d87f
end










	