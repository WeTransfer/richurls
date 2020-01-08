ENV.store('RACK_ENV', 'test')

Bundler.require(:default, :test)

# require the app
require_relative '../lib/richurls.rb'

module RSpecMixin
  include Rack::Test::Methods

  def app
    RichUrls
  end
end

RSpec.configure { |c| c.include RSpecMixin }

RSpec.configure do |config|
  config.before(:suite) do
    Redis.new.flushall
  end
end
