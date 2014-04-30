#!/usr/local/bin/ruby

require 'json'
coo = Dir['./*.json'].map{ |f| JSON.parse File.read(f) }
puts coo
