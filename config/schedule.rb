# Use this file to easily define all of your cron jobs.

##instagram
every '0 */4 * * *' do
  command "ruby /home/ubuntu/tubes_trends/classes/instagram_get_popular.rb >> /home/ubuntu/tubes_trends/logs/instagram_log.txt"
end

#yahoo
every '0 */4 * * *' do
	command "ruby /home/ubuntu/tubes_trends/classes/yahoo_get_trends.rb >> /home/ubuntu/tubes_trends/logs/yahoo_log.txt"
end

#youtube
every '0 */4 * * *' do
	command "ruby /home/ubuntu/tubes_trends/classes/youtube_get_trends.rb >> /home/ubuntu/tubes_trends/logs/youtube_log.txt"
end

#twitter country
every '0 */4 * * *' do
	command "ruby /home/ubuntu/tubes_trends/classes/twitter_get_tr_topcountries.rb >> /home/ubuntu/tubes_trends/logs/twitter_country.txt"
end

#twitter place
every '0 */7 * * *' do
	command "ruby /home/ubuntu/tubes_trends/classes/twitter_get_tr_restoworld.rb >> /home/ubuntu/tubes_trends/logs/twitter_restoworld.txt"
end

#google
every '0 */4 * * *' do
	command "ruby /home/ubuntu/tubes_trends/classes/google_get_hot_trends.rb >> /home/ubuntu/tubes_trends/logs/google_log.txt"
end

##backup everything onto s3 every 6 hours
every '0 */6 * * *' do
	command "rsync -rtavz /mnt/s3/tubes_trends_orig/ /mnt/s3/real_backup"
end



#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
