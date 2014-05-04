 #!/usr/bin/env ruby
#####Script to get twitter trends######

require 'rubygems'
require 'oauth'
require 'json'

class TwitterTrends
  def initialize
    #Change the following values to those provided on dev.twitter.com
    # The consumer key identifies the application making the request.
    # The access token identifies the user making the request. 
    #for places
    @consumer_key_places = 'V2IMHyJ9trKa2ynGk1iyg'
    @consumer_secret_places = 'Q5e2ULy2Q2ALk8Oa99bfBw1E09hifI8XuA8jXGLc3jo'
    @access_token_places = '351064202-MQMWA7tjAIUgl7jJ1vdEWChtTJCJFp75zpbUT4Q1'
    @access_token_secret_places = 'GSyrdheQcgHvNNXEQg7Ii57hxkmcECfEd9NOTDLcompAg'
    @consumer_key_places = OAuth::Consumer.new( @consumer_key_places, @consumer_secret_places)
    @access_token_places = OAuth::Token.new(@access_token_places, @access_token_secret_places)

    #for countries
    @consumer_key_country = 'JKCXRoK0X5tDGRX5IcYhprQbY'
    @consumer_secret_country = 'S0hQ49mfqmsHiacRJDojNE1eUvu61MtRGyMvkCcince61W5SJo'
    @access_token_country = '2436491167-oj3ndDDqjJGFCCNNldUoYY7Aqh3yqpSAeKKQQez'
    @access_token_secret_country = 'ZaqZrsAZVOiTINAE90xfa0DZjpZ64TXJj3CiVn3HDJfVr'
    @consumer_key_country = OAuth::Consumer.new( @consumer_key_country, @consumer_secret_country)
    @access_token_country = OAuth::Token.new(@access_token_country, @access_token_secret_country)

    @baseurl = "https://api.twitter.com"
  end

  #creates the request for twitter trend availibile
  def make_request_get_response_trend_availible
    @path_trend_availible = '/1.1/trends/available.json'
    @address_trend_availible = URI("#{@baseurl}#{@path_trend_availible}")
    # Set up HTTP. Need ssL to make the connection
    @request_trend_availible = Net::HTTP::Get.new @address_trend_availible.request_uri
    @http             = Net::HTTP.new @address_trend_availible.host, @address_trend_availible.port
    @http.use_ssl     = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    # Issue the request.
    @request_trend_availible.oauth! @http, @consumer_key_country, @access_token_country
    @http.start
    @response_trend_availible = @http.request @request_trend_availible
    @response_trend_availible
  end

  ##parse the response into json for avail. places
  def parse_trend_availible(response_trend_availible)
    @response_trend_availible = response_trend_availible
    @tweets_avail = JSON.parse(@response_trend_availible.body)
    @tweets_avail
  end

  #parse the response object for trend avail into lines for array of csv lines
  def parse_trend_tweets_availible (tweets_availible)
    @tweets = tweets_availible
    @trend_rows = Array.new
    @string_rows =  Array.new
    for tweet in @tweets
      @trend_row = Array.new
      @country = tweet["country"]
      @trend_row << @country 
      @countrycode = tweet["countryCode"]
      @trend_row << @coun
      @name = tweet["name"]
      @trend_row << @name
      @placetypecodename = tweet["placeType"]["name"]
      @trend_row << @placetypecodename
      @placetypecode = tweet["placeType"]["code"]
      @trend_row <<  @placetypecode 
      @url = tweet["url"]
      @trend_row << @url
      @woeid = tweet["woeid"]
      @trend_row << @woeid
      @stringrow = @trend_row.join("|")
      @trend_rows << @trend_row 
      @string_rows << @stringrow
    end
    @trend_rows
  end

   #creates the request for twitter trend place
  def make_request_get_response_trend_place(woeid, country)
    #EX: #https://api.twitter.com/1.1/trends/place.json?id=woeid
    @path_trend_place = "/1.1/trends/place.json?id="
    @country =  @country
    #woeid is the where in the world yahoo place id 
    @woeid = woeid
    @address_trend_place = URI("#{@baseurl}#{@path_trend_place}#{@woeid}")
    @request_trend_place = Net::HTTP::Get.new @address_trend_place.request_uri
    @http             = Net::HTTP.new @address_trend_place.host, @address_trend_place.port
    @http.use_ssl     = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    # Issue the request.
    if @country == 'cntry'
      @request_trend_place.oauth! @http, @consumer_key_country, @access_token_country
      @http.start
      @response_trend_place = @http.request @request_trend_place
      @response_trend_place

    elsif @country != 'cntry'
      @request_trend_place.oauth! @http, @consumer_key_places, @access_token_places
      @http.start
      @response_trend_place = @http.request @request_trend_place
      @response_trend_place
    end
    @response_trend_place
  end

  #parse the response object for trend places into json
  def parse_trend_places(response_trend_place)
    @response_trend_place = response_trend_place
    @tweets = JSON.parse(@response_trend_place.body)
    @tweets
  end

  def get_date
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

#parse json place data into real pieces/plain text csv array of rows
  def parse_trend_tweets_place (tweets_place)
    @todays_date = get_date
    @tweets = tweets_place
    @trend_rows =  Array.new
    @trend_rows_string =  Array.new
    @trends = @tweets[0]['trends']
    @as_of = @tweets[0]['as_of']
    @as_of = @as_of.chomp("Z") 
    #@as_of =  @as_of.gsub(/:/, '-')
    @location = @tweets[0]["locations"]
    #@location_name = @location[0]["name"]
    @location_woeid = @location[0]["woeid"]
    ###dump each record into a csv row
    @trends.each do |trend|
      @tweet_row = Array.new
      @tweet_row << @location_woeid.to_s
      @todays_date = get_date
      @tweet_row << @todays_date.to_s
      @tweet_row <<  "1"
      @tweet_row << @as_of.to_s
      #@tweet_row << @location_name
      @name = trend["name"]
      @url =  trend["url"]
      @tweet_row << @name
      @tweet_row << @url
      @trend_rows <<  @tweet_row
      @stringrow = @tweet_row.join("|")
      @trend_rows_string << @stringrow
    end
  return [ @trend_rows, @trend_rows_string ]
  end
end












