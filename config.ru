require 'environment'
require 'rack'

if ENV['RACK_ENV'] == 'development'
  log = File.new("log/development.log", "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

require 'omniauth/oauth'

use Rack::Static, :urls => ["/stylesheets", "/images", "/javascripts"], :root => "public"
use Rack::Session::Cookie
use OmniAuth::Strategies::Twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']

run Rack::Cascade.new([
  ConfAsk::Application,
  ConfAsk::API
])