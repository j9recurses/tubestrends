
class GetFeeds
	#usage
	
	#g = GoogleTrends.new(url)
	#contents = g.get_feed_contents
	#g.parse_entry_contents

	def initialize
		require 'rubygems'
		require 'json'
		#willl use a html parser; rss feed is only for USA
		#gem install feedzirra
		require 'feedzirra'
		require 'feedjira'
	end

	def myfeed(url)
		@url = url
		#grab the feed info
		@feed = Feedzirra::Feed.fetch_and_parse(url)
		@entry = @entry.content.sanitize!
		@last_updated =  @feed.last_modified
		@entry  #returns rss feed contents as a str
	end

	def get_feed_contents(feed)
		#grab feed entries
		@feed = feed
		puts @feed.feed_url
		
		puts entry.title 
		@last_updated =  @feed.last_modified
		  #returns rss feed contents as a string
	end

	def parse_entry_contents
		#@entry = entry
		require 'open-uri'
		@doc = open(youtubelink) { |f| Hpricot(f) }
		puts @doc
	end

	def included_country_places
		@excludeplaces =  ['United States', 'Argentina', 'Austria', 'Australia', 'Belgium', 'Brazil', 'Canada', 'Colombia', 'Chile', 'Czech Republic', 'Denmark', 'France', 'Egypt', 'Finland', 'Germany','Greece','Hong Kong', 'Hungary', 'India', 'Indonesia', 'Israel', 'Italy', 'Japan', 'Kenya', 'Malaysia','Mexico', 'Netherlands', 'Nigeria', 'Norway', 'Philippines', 'Poland', 'Portugal', 'Romania', 'Russia', 'Saudi Arabia', 'Singapore', 'South Africa', 'South Korea', 'Sweden', 'Spain', 'Sweden', 'Switzerland', 'Taiwan', 'Thailand', 'Turkey', 'Ukraine', 'United Kingdom', 'Vietnam' ]
		require_relative './MyCoolClasses.rb'
		@woeids_stuff_list = Array.new
		@db = MyCoolClass.new
		#connect to sql db
		@mydb =  @db.connect_to_sqldb
		@excludeplaces.each do |s|
			begin
				@mys = "select countrycode from country where name = '" + s + "';"
				@rs  =  @mydb.query(@mys)
				@n_rows = @rs.num_rows
				@n_rows.times do
					@woeids_stuff_list << @rs.fetch_row[0]
				end
			rescue Exception=>e 
				puts "Something went wrong! Could not connect to DB"
				puts e
			end
		end
		puts @woeids_stuff_list
		return @woeids_stuff_list
	end


end

require 'rss'
myf = GetFeeds.new
country = myf.included_country_places
country.each do | c |
	begin
		#url  ='http://gdata.youtube.com/feeds/api/standardfeeds/' + c  +'/most_popular?v=2'
		url = "http://gdata.youtube.com/feeds/api/videos?/" +c + "/orderby=viewCount"
		rss = RSS::Parser.parse(url, false)
		#case rss.feed_type
			#when 'rss'
    			#rss.items.each { |item|puts item.title }
    		#	rss.items.each { |item|puts item }
    			
  			#when 'atom'
    			#rss.items.each { |item |puts item.title.content }
    		#	rss.items.each { |item |puts item.title}
    	#end
    	feed = Feedjira::Feed.fetch_and_parse(url)
    	puts feed.title          # => "Paul Dix Explains Nothing"
		puts feed_url            # => "http://www.pauldix.net"
		puts feed.etag           # => "GunxqnEP4NeYhrqq9TyVKTuDnh0"
		puts feed.last_modified 

	rescue Exception=>e 
		puts "Something went wrong! Could not connect to DB"
		puts e
	end
end



