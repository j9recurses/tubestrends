
#!/usr/local/bin/ruby
require_relative './MyCoolClasses.rb'
require_relative './google_get_hot_trends.rb'

class DisgracebookTrends < GoogleTrendsWWW
	def login
		url = "http://www.facebook.com"
		myhome = ''
		begin 
			@b = get_browswer(url)
    		sleep(15)
    		loginform = @b.form(:id => "login_form")    		
			myemail = loginform.input(:id => "email").to_subtype.set "bobcoolio13@yahoo.com"
			mypass  = loginform.input(:id => "pass").to_subtype.set "Chichi13"

			#@weirdst =  grab_html(loginform)
			#puts @weirdst
			@cool = @b.button(:type => "submit")
			@cool.click
			
			###find the home page for the user....need to do this to get around facebook shit to make friends
			getaround = @b.li(:id => "navHome").link.click
			#myhome = getaround.a(:class => "navLink bigPadding")
			#myhome = getaround.link.href
			#@getaround
			#@b.link(:text => getaround).click
			##@b.goto(myhome)
			#myhome = grab_html(myhome).to_s
			#search_home =  'www.facebook.com\S+"'
			#myhome =  myhome.match(search_home )
			#	if search_home 
			#		myhome = myhome.to_s
			#		myhome = myhome[0..-2]
				#end
			myhome = myhome.to_s
		rescue Exception=>e
			puts e
			puts "something weird happened"
		end
		@b
	end

	##grab the trends--> get the trend rank and then grab the html href on facebook for the trend. Then dump it into an dictionary. 
	def get_facebook_shit(b)
		@b = b
		puts @b.text
		trenddict = Hash.new
		begin
			@trendbox_wait =  @b.div(:id  => "pagelet_trending_tags_and_topics").wait_until_present
			if @trendbox_wait
				@trendbox =  @b.div(:id  => "pagelet_trending_tags_and_topics")
				puts @trendbox.text
				doc = grab_html(@trendbox)
				nodes = doc.search("//ul")
				nodes.each do |node|
					trendlistitemz = node
					listitems = trendlistitemz.search("//li")
					listitems.each do |new_node|
						new_node =  new_node.to_s
						#grab the rank
						search_rank = '\D+data-position="\d+'
						rank =  new_node.match(search_rank)
						if rank
							rank = rank.to_s
							rank = rank[/\d+/]
						end
						#grab the href link to mine pics and other info
						search_link = 'href=\S+"'
						hlink = new_node.match(search_link)
						if hlink
							hlink = hlink.to_s
							hlink = hlink[6..-1]
							hlink = hlink.sub( '"', "" )
							hlink = "https://www.facebook.com" + hlink
						end
						trenddict[rank] = hlink
					end
				end
			end
			rescue Exception=>e
				puts e
				puts "something weird happened"
		end
			[trenddict, b]
	end

	def get_the_goodies(trenddict, b)
		my_facebook_json = Array.new
		trenddict.each do |key, value|
			mylist = Array.new
			mylistdb = Array.new
			#browser.link(:text => /text010120121134/).click
			#@b.link(:text => value).click
			browser_loaded=0
			while (browser_loaded == 0)
				begin
					browser_loaded=1
 					Timeout::timeout(10) do
  					@b = get_browswer(value) # goto or click a link
 				end
 				rescue Timeout::Error => e
 					puts ;Page load timed out: #{e}”
  					browser_loaded=0
  				retry
 				end
				end

			puts "puts broke at collection"

			#insert the date and sdoid
			mylist << grab_the_date
			mylistdb << grab_the_date
			sdoid, mydb = get_sdoid('facebook')
			mylist << sdoid
			mylistdb << sdoid

			####grab facebook's data
			headerbox  =  @b.div(:class => "uiHeader _5xia")
			#get the title
			title = headerbox.h2(:class => "uiHeaderTitle").text
			title =  mysanitize(title)
			mylist <<  title
			mylistdb << "'" + title + "'"

			#insert the trend rank
			mylist << key
			mylistdb << key
			
			#grab the description
			headerinfobox = @b.div(:class => "clearfix _4h5 _gxb _5qv8")
			description =  headerinfobox.span(:class => "fwb") 
			description = description.text
			description =  mysanitize(description)
			mylist << description 
			mylistdb << "'"+ description +"'"
		
			#grab the picture
			pict = headerinfobox.span(:class => "_4q4 _5ok photoWrap") 
			img =  pict.img(:class => "_42xb img")
			img_html = grab_html(img).to_s
			img_regex = 'http%.+.jpg'
			img_link = img_html.match(img_regex)
			if img_link
				img_link = img_link.to_s
				img_link = img_link.sub( 'http%3A%2F', "" )
				img_link = img_link.gsub( '%2F', "/" )
				img_link = img_link.sub( '/', "" )
				img_link = mysanitize(img_link)
				mylist << img_link
				mylistdb << "'"+ img_link +"'"
			else
				mylist << '00'
				mylistdb << '00'
			end

			#grab the link to the story
			story_link = headerinfobox.a(:class=> "_5xi9 rfloat _ohf")
			story_link  = grab_html(story_link).to_s
			link_regex = 'onmouseover=\'LinkshimAsyncLink.swap\(this, \"http:\\\/\\\/\S+"'
			story_link = story_link.match(link_regex)
			if story_link
				story_link = story_link.to_s
				story_link = story_link.sub('onmouseover=\'LinkshimAsyncLink.swap(this, "http:\/\/', "" )
				story_link = story_link.sub('"', "" )
				story_link = story_link.gsub('\\/', "/" )
				story_link =  mysanitize(story_link)
				mylist << story_link
				mylistdb << "'"+story_link +"'"
			end
			trend_row =  mylistdb.join (", ")
  			mysql2 =  "insert into `tubes_trends`.`facebook_trends` (the_date, sdoid,  title, rank, description, image_url, url) select " + trend_row + ";"
			generic_insert(mysql2, mydb)
			##also make a json object
  			trend_json_line = make_facebook_json_obj(mylist)
  			my_facebook_json << trend_json_line
		end
		my_facebook_json
	end

	def make_facebook_json_obj(trend_line)
		if trend_line.size == 7
			fields = ['the_date', 'sdoid', 'rank', 'title', 'description', 'image_url', 'url',  'timestamp']
			trend_line << get_timestamp
			my_facbook_hash = Hash[fields.zip(trend_line)]
			my_facebook_hash = my_facebook_hash.to_json
		end
		return my_facbook_hash
	end


	def disgracebookmain
		begin
			b =  login
			filename = '../json_data/facebook/facebook_trends_' + grab_the_date + '.json'
				trenddict, b = get_facebook_shit(b)
				my_facebook_json = get_the_goodies(trenddict, b)
				write_trend_rows_to_file2(filename, my_facebook_json)
		rescue Exception=>e
			puts e
			puts "something weird happened"
		end
	end
end


#to use
dt =  DisgracebookTrends.new
dt.disgracebookmain