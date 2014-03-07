
class GetFeeds
	#usage
	#url = youtube  ='http://gdata.youtube.com/feeds/api/standardfeeds/AE/most_popular?v=2'
	#g = GoogleTrends.new(url)
	#contents = g.get_feed_contents
	#g.parse_entry_contents

	def initialize(url)

		require 'rubygems'
		require 'json'
		#willl use a html parser; rss feed is only for USA
		#gem install feedzirra
		require 'feedzirra'
		@url = url
		#grab the feed info
		@feed = Feedzirra::Feed.fetch_and_parse(url)
	end

	def get_feed_contents
		#grab feed entries
		@entry = @feed.entries.first
		@entry = @entry.content.sanitize!
		@last_updated =  @feed.last_modified
		@entry  #returns rss feed contents as a string
	end

	def parse_entry_contents
		#@entry = entry
		require 'open-uri'
		@doc = open(youtubelink) { |f| Hpricot(f) }
		puts @doc
	end
end

##note: I did have a chance to completely implement this script because I ran out of time. 
country = [array of countries]
for country each do | c |
	youtube  ='http://gdata.youtube.com/feeds/api/standardfeeds/' + c '/most_popular?v=2'
	gf =  GetFeeds.new(youtube)
	cnts = gf.get_feed_contents


