#####MAIN#######
t = TwitterTrends.new
response_trend_place =  t.make_request_get_response_trend_place(2487956)
tweets_place  = t.parse_trend_places(response_trend_place)
trend_row = t.parse_trend_tweets_place (tweets_place)
puts trend_row





###need to grab closet api feed; will need this so you can grab the twitter closet to the ip add?
###seems like the only free ip address look up is by country, so twitter closet not neccessary.
####http://ruby.about.com/od/gems/a/geoip.htm
#$ sudo gem install geoip
#Successfully installed geoip-0.8.0
#1 gem installed
#Installing ri documentation for geoip-0.8.0...
#Installing RDoc documentation for geoip-0.8.0...


##data is in array objs; now you can either write to a text file or load directly to the website
