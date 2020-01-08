ENV.store('RACK_ENV', 'test')

Bundler.require(:default, :test)

# require the app
require_relative '../lib/richurls.rb'

RSpec.configure do |config|
  config.before(:suite) do
    Redis.new.flushall
  end
end
