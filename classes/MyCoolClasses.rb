#!/usr/local/bin/ruby

###class to where functions can be used over and over again

class MyCoolClass
	def initialize
		require 'rubygems'
		#db parameters: 
		@user = 'j9'
		@password =  'chichi13'
		@database =  'tubes_trends'
		@host = 'localhost'
	end

	def connect_to_sqldb
		#gem install mysql
		require 'mysql'
		begin
  		@db = Mysql.new(@host, @user, @password, @database)
		rescue Mysql::Error
  		puts "Oh noes! We could not connect to our database. -_-;;"
 		exit 1
		end
	end


	def write_trend_rows_to_file (filename, list)
  		@filename = filename
  		@list = list
  		begin
  			# Create a new file and write to it  
			@myfile = File.open(@filename, 'a')
			@list.each do |trend| 
				trend.each do |t|
					@myfile.puts(t)
				end
			end
  		end
	end	

	def write_trend_rows_to_file2 (filename, list)
  		@filename = filename
  		@list = list
  		begin
  			# Create a new file and write to it  
			@myfile = File.open(@filename, 'a')
			@list.each do |trend| 
				@myfile.puts(trend)
				end
  		end
	end
    
end



