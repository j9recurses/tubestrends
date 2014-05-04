#!/usr/bin/env ruby
####class to grab popular data from instagram######. 
require_relative './MyCoolClasses.rb'


class GetInstagramPopular < MyCoolClass
  def initialize 
    require "rubygems"
    require 'json'
    #gem install instagram
    require "net/https"
    require "uri"
    @clientid =  'de0a241ffff34828b50d2d3248234c23'
    @clientsecret = '1a0f7ec565ca4cb4bcc67c71db78a47e'
    #awesome website helper: http://jelled.com/instagram/access-token#access_token
    @respsonepage = 'http://jelled.com/instagram/access-token'
    @accesstoken =  '278072007.de0a241.20378d43a0524359840fea0c45e2618b'
  end

  def makegetpoprequest 
    @uri = URI.parse("https://api.instagram.com//v1/media/popular?access_token=#{@accesstoken}")
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @request = Net::HTTP::Get.new(@uri.request_uri)
    @response = @http.request(@request)
    return @response
  end

  def get_date
    #function to get the date
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

  def mysanitize(string)
    @string = string
    ##function to santitze strings to prevent sql injections
      @safe_string = @string.gsub(/'/, '')
      return @safe_string
  end

  def parsebody(response)
    ###Need to use a a bunch of trys and catches because the data may or not be there
    ###method parses instagram json data
    @response = response
    @body = JSON.parse( @response.body )[ "data" ]
    @instagram_row_all = Array.new
    @instagram_row_all_string = Array.new
    @body.each do |item| 
      @instagram_row = Array.new
      @the_date = get_date
      @instagram_row << @the_date
      @instagram_row << "4"
      begin
        @lat = item["location"]["latitude"].to_s
        @instagram_row << @lat
      rescue Exception=>e 
        @lat =  ''
        @instagram_row << @lat
      end
      begin
        @longst = item["location"]["longitude"].to_s
        @instagram_row << @longst
      rescue Exception=>e 
        @longst =  ''
        @instagram_row << @longst
      end
      @link = item["link"]
      @instagram_row << @link
      @thumbimage = item["images"]["thumbnail"]["url"]
      @instagram_row << @thumbimage
      @regimage = item["images"]["standard_resolution"]["url"]
      @instagram_row <<  @regimage 
      begin
        @tags = item["tags"]
        @tags = @tags.join("-")
        @instagram_row <<  @tags
      rescue Exception=>e 
        @tags =  ''
        @instagram_row <<  @tags
      end
      @filter = item["filter"]
      @instagram_row <<  @filter
      begin
        @as_of =  item["caption"]["created_time"]
        @instagram_row <<  @as_of.to_s
      rescue Exception=>e 
        @tags =  ''
         @instagram_row <<  ''
      end
      begin
        @caption = item["caption"]["text"]
        @instagram_row <<  @caption
       rescue Exception=>e 
        @caption =  ''
        @instagram_row <<  @caption
      end
      @likescnt = item['likes']["count"].to_s
      @instagram_row <<  @likescnt
      @content_type = item["type"]
      @instagram_row <<  @content_type
      @instagram_row_all << @instagram_row 
      @instagram_row_string =  @instagram_row.join("|")
      @instagram_row_all_string << @instagram_row_string
    end
    return [ @instagram_row_all,  @instagram_row_all_string ]
  end

  def insert_woeids_info_to_db(instagram_row_all)
    #insert yahoo location data into the data; also have to clean it up a little
    @woeids = instagram_row_all
    @insertst_orig =  'insert into tubes_trends.instgm_popular ( the_date, sdoid , lat, longt, link, thumbimage, regimage, 
    tags, camera_filter, as_of, caption, likes_count, content_type ) VALUES'
    begin
      require_relative './MyCoolClasses.rb'
      @db = MyCoolClass.new
      #connect to sql db
      @mydb =  @db.connect_to_sqldb
      @woeids.each do |w|
        #transform certain woeids to sql strings, so you won't have insert problems
        ##strings in array that need to be transformed are: [3,4, 13, 15, 16, 17, 18, 19, 20]
        @insertst = @insertst_orig + " ( "
        @mystringnumbs = [4,5,6,7,8,10, 12]
        @mystringnumbs.each do |i| 
          @ststf = w[i] 
          if ! @ststf.nil?
            @ststf = mysanitize(@ststf)
            w[i] = "'" + @ststf + "'"
          end
        end
        w.each do |w2|
          ##puts w2
          wordsize =  w2.to_s.size
          ###make sure to escape all the weird chars; Don't want a sql injection atttack on the db
          if w2.nil?
            w2 = " '',"
            @insertst = @insertst + w2 
          elsif wordsize == 0 
            w2 = " '',"
            @insertst = @insertst + w2 
          else
            @insertst = @insertst + w2 + ","
          end
        end
      @insertst = @insertst.chop + "); "
       @mydb.query(@insertst)
      end
    rescue Exception=>e 
      puts "Something went wrong! Could not connect to DB"
      puts e
    end
  end

 

  def make_istagramg_json_obj(instagram_row_all, filename)
    fields = [ 'the_date', 'sdoid' , 'lat', 'longt', 'link', 'thumbimage', 'regimage',  'title', 'camera_filter', 'as_of', 'caption', 'likes_count', 'content_type' ]
    insta_json_arry = Array.new
    instagram_row_all.each do | g|
      my_insta_hash = Hash[fields.zip(g)]
      my_insta_hash = my_insta_hash.to_json
      insta_json_arry << my_insta_hash
    end
    write_trend_rows_to_file2( filename, insta_json_arry,)
  end

  def main_instagram
    body = makegetpoprequest 
    instagram_row_all, instagram_row_all_string = parsebody(body)
    puts "getting instagram trends on " + get_date.to_s
    #insert_woeids_info_to_db(instagram_row_all)
    ##name of file to write the trend data too; will need to write the file 
    #check and create dir structure
    today =  grab_the_date
    basedir =  '/mnt/s3/tubes_trends_orig/json_data/'
    network = 'instagram/'
    today_dir = today + "/"
    file_dir = basedir+network +today_dir
    ch_directory_exists(file_dir)

    #create a unique file name
    counter = 0
    letter_array =  ('a'..'z').to_a
    insta_trends_file = file_dir + "instagram_trends_" + grab_the_date + "_" + letter_array[counter]+ ".json"
      

    while (  File.exist?insta_trends_file)
      insta_trends_file = file_dir + "instagram_trends_" + grab_the_date + "_" + letter_array[counter]+ ".json"
      counter = counter + 1 
    end

 
    make_istagramg_json_obj(instagram_row_all, insta_trends_file)
  end


end

##################main###########################=
gpi = GetInstagramPopular.new
gpi.main_instagram





