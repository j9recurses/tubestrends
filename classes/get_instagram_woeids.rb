 require_relative './twiter_get_trends.rb'

 ###get the nearest woeids for the instagram lat and long
  def get_the_woeids(lat, long)
    tt = TwitterTrends.new
    baseurl, consumer_key_country ,  consumer_key_country , access_token_country   access_token_secret_country ,  consumer_key_country,   access_token_country  = tt.return_initials
  en
    #creates the request for twitter trend place
    path_trend_place = "/1.1/trends/closest.json?"
    latlong = "lat="+ lat +"&long=" + long
    address_trend_place = URI("#{baseurl}#{path_trend_place}#{latlong}")
    @request_trend_place = Net::HTTP::Get.new @address_trend_place.request_uri
    @http             = Net::HTTP.new @address_trend_place.host, @address_trend_place.port
    @http.use_ssl     = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    @country == 'cntry'
    # Issue the request.
    if @country == 'cntry'
      @request_trend_place.oauth! @http, @consumer_key_country, @access_token_country
      @http.start
      @response_trend_place = @http.request @request_trend_place
      @response_trend_place
  end

    #parse the response object for trend places into json
  def parse_trend_places(response_trend_place)
    @response_trend_place = response_trend_place
    @tweets = JSON.parse(@response_trend_place.body)
    puts @tweets
    @tweets
  end