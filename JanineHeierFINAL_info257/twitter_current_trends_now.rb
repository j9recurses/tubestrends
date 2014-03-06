
#!/usr/local/bin/ruby
####class to twitter request calls#####
class GetTwiterCurrentTrend
	def initialize
		@my =  ""
	end
	
	def getwoeidstolookup
		require_relative './MyCoolClasses.rb'
		@db = MyCoolClass.new
		@selectq =  "select woeid from places"
		@woeids = Array.new
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
		if @country == 'all' 
			@insertst_orig = 'insert into twitter_trends_places (' 
		elsif @country = 'cntry'
			@insertst_orig = 'insert into twitter_trends_country (' 
		end
		insert into twitter_trends
		@twitter_all_trends = twitter_all_trends
		@insertst_orig = @insertst_orig  + "woeid, the_date, sdoid, as_of, name, url) VALUES"
			begin
			require_relative './MyCoolClasses.rb'
			@db = MyCoolClass.new
			#connect to sql db
			@mydb =  @db.connect_to_sqldb
			@twitter_all_trends.each do |w|
				@insertst = @insertst_orig + " ( "
				@insertst = @insertst_orig + " ( "
				@mystringnumbs = [3,4,5]
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
			puts 'inserted some stuff'
			end
		rescue Exception=>e 
			puts "Something went wrong! Could not connect to DB"
			puts e
		end	
	end
	

   	def write_tw_trends_to_file(filename, trend_rows_string)
    	##write data to a file as a backup copy
      	require_relative './MyCoolClasses.rb'
    	wl = MyCoolClass.new
    	wl.write_trend_rows_to_file2(filename, woeid_info_all_strings)
  	end
end










	