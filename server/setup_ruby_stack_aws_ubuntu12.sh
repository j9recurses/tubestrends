
#!/usr/bin/bash

#janine heiser
##bonus goodies for the info 257 projedct

#######SETUP INSTRUCTIONS FOR A PHP RAILS MYSQL APACHE NGINX STACK ######
###NOTE: SERVER INSTANCE FLAVOR IS Ubuntu Server 12.04.3 LTS ####

###From your amazon ec2 account, click, Lauch instance
###The following page, Step 1: Choose an Amazon Machine Image (AMI) will pop up
### SELECT: Ubuntu Server 12.04.3 LTS--> you want the 32 bit one, (ami-68ad3358)

####Next, in that series of setup questions, make sure to open up your http port and your ssh point so you can connect to the server; 
##to find where to open the ports up, go to: Security Group, and click on the one that matches your instance--> launch-wizard-8
#in order to get apache to run you will need to add inbuound rules the security rules; 
#the inbound tab, then click on the drop down "create new rule"; add 80 (http) and #3306 (mysql- if you also want to be able to access the mysql server from outside the server) 
#add the rules, and then click apply rule change; if you dont click apply rulechange then amazon wont apply the rules


###*****DON'T be an idiot like me and loose your private key! If you lost the .pem file for the server instance
##you'll be totally f**'d like you won't be able to access the server at all. :(  

###To connecting to the amazon stack: ssh -i cactus1treeaws.pem.pem ubuntu@54.201.93.215 -----> 
##once logged into the stack, copy this script over to your aws serve to the /home/ubuntu directory
##then, change the perms of this file to: chmod 777 setup_ruby_stack_aws_ubuntu12.sh
### And then run it as UBUNTU by just executing it as ./setup.sh
### Normally, its a bad idea to change a file perms to 777, but in this case, we have no choice;
##If you run the file as root instead of unbuntu, the rvm gets all messed up and you won't be able to install any gems. 
##Once you run the script, and its finished, changed the perms of the file to 755.
###And last but not least, you'll need to edit the config file for nginx manually- instructions to do this are at the bottom. 

############Begin script############################
#update ubuntu
sudo apt-get update
#install the lamp stack
sudo apt-get install lamp-server^
#you will be prompted to enter a root password for mysql

#in order to get apache to run you will need to add inbuound rules the security rules; in the aws console, at the bottom, go to 
the inbound tab, then click on the drop down "create new rule"; add 80 (http) and #3306 (mysql- if you also want to be able to access the mysql server from outside the server) 
#add the rules, and then click apply rule change; if you dont click apply rulechange then amazon wont apply the rules


#make sure that curl is installed
sudo apt-get install curl

#get the rvm (ruby version manager)
curl -L get.rvm.io | sudo bash -s stable
#This will install RVM to /usr/local/rvm instead of a hidden folder in your home directory, which is what occurs during a Single-User install.The installation of RVM will create an rvm group, you should add #yourself and any users that need Ruby access on the machine to this group with
sudo adduser ubuntu rvm

#load the rvms; Put this in your ~/.bash_login file 
#note: the .bash_login file doesnt exist by default; aka there is nothing there when you do a ls -a; basically the .bash_login is setting the env. rvm variables when you first login to the bash shell

#vim ~/.bash_login
#echo "[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" " >> ~/.bash_login



#run this to refresh rvm:
rvm reload

# Load RVM into a shell session *as a function*
#RVM can be run in two different modes - by default, if the rvm binary is available in your path / is used with an absolute path, 
#RVM will run as a binary. This means that rvm can do 
#the vast majority of most operations (e.g. installing rubies, etc) but certain things (like switching 
#the current ruby) will fail as it cannot change the environment it operates in. 
#SO- WE NEED TO LOAD RVM LIKE THIS TO RUN IT AS A BASH SCRIPT
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then

  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"

elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"

else

  printf "ERROR: An RVM installation was not found.\n"

fi

#check to see that you have the rvm reqs.
rvm requirements

#install git
sudo apt-get install git

#install a bunch of other stuff/dependencies
sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config

#now we can finally install ruby
rvm install 1.9.3

#tell rvm to use ruby 1.9.3 by default
rvm use 1.9.3 --default
##note, not sure if above command executes right--> could cause a snag if it doesn't ...

#now we need to check which gems are installed!! 
#need to get the gems to install rails

rvm rubygems current

#install rails
gem install rails

#install homebrew for linux! this optional, I ended up not needing linux brew...at least for now
#homebrew is a convient package manager....
#git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
# add this to profile_login file:
#export PATH=~/.linuxbrew/bin:$PATH
#export LD_LIBRARY_PATH=~/.linuxbrew/lib

#well, since we have a lamp stack and ruby on rails, might as well as install nginx server and Phusion Passenger, just so we can be hardcore...
##stop apache; we need to stop apache in order to start nginx
#you can have both running but i didn't want to bother configuring them at this point

#install nginx first
sudo apt-get install nginx

##replace the init scripts with ones that are easier to use:

cd ~
git clone git://github.com/jnstq/rails-nginx-passenger-ubuntu.git
#nginx init script by Jason Giedymin helps us to administer web server easily
sudo mv rails-nginx-passenger-ubuntu/nginx/nginx /etc/init.d/nginx
sudo chown root:root /etc/init.d/nginx


#start up nginx
sudo service nginx start

#to make sure its working, go to your browser and hit the addr of your website
#ex:http://ec2-54-201-93-215.us-west-2.compute.amazonaws.com/
#your webpage should have something that says "welcome to nginx"

#see if everything is working:
ifconfig eth0 | grep inet | awk '{ print $2 }'

#To ensure that nginx will be up after reboots, it’s best to add it to the startup.
update-rc.d nginx defaults

#if you get the error msg: System start/stop links for /etc/init.d/nginx already exist. 
#then you are fine, its just telling you that nginx is running

#now let's install node js (dependency to create rails app)
sudo apt-get install nodejs

#install another dependency that you need for the passenger nginx rails module
apt-get install libcurl4-openssl-dev

##amazon has almost no virtual memory, so add some to hit the recomm. amt:
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap
sudo swapon /swap


#install the passenger module for nginx:
rvmsudo passenger-install-nginx-module
#there may be dependencies that passender finds, so you may have to approve them

#start up nginx again
sudo service nginx start 

### install a bunch of gems used for the data collection scripts
###install a dependency for mysql gem
sudo apt-get install libmysql++-dev
gem install mysql
gem install jason
gem install oauth
# nokogiri requirements
sudo apt-get install libxslt-dev libxml2-dev
gem install nokogiri
gem install watir-webdriver
## get dependency for headless
sudo apt-get install xvfb
sudo apt-get install firefox
gem install headless


#create a separate dir for your rails projects
mkdir /home/ubuntu/rails_projects
# for php projects
mkdir /home/ubuntu/php_projects 
#for mysql stuff
mkdir mysql_projects 

#create your rails app for final project
rails new /home/ubuntu/final_project/rails/tubes_trend
###make project directories to store different project files
mkdir /home/ubuntu/final_project/db_scripts
mkdir /home/ubuntu/final_project/getdata_scripts
mkdir /home/ubuntu/final_project/getdata_scripts/mydata
mkdir /home/ubuntu/final_project/logs

###last but not least: configure nginx
#config the conf file
#sudo vim /opt/nginx/conf/nginx.conf

#Set the root to the public directory of your new rails project.
#Your config should then look something like this:
#server { 
#listen 80; 
#server_name example.com; 
#passenger_enabled on; 
#root /var/www/my_awesome_rails_app/public; (whatever the dir of yr rails app)
#}
#note: when you write the above conf, take out the ##
