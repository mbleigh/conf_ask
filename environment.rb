require 'rubygems'
require 'bundler'

Bundler.setup :default, (ENV['RACK_ENV'] || 'development')

require 'mongo_mapper'
require 'application'
require 'api'
require 'models'

if ENV['MONGOHQ_URL']
  MongoMapper.config = {ENV['RACK_ENV'] => {'uri' => ENV['MONGOHQ_URL']}}
else
  MongoMapper.config = {ENV['RACK_ENV'] => {'uri' => 'mongodb://localhost/confask'}}
end

MongoMapper.connect(ENV['RACK_ENV'])