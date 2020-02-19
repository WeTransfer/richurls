ENV.store('RACK_ENV', 'test')

Bundler.require(:default, :test)

# require the app
require_relative '../lib/richurls.rb'

class Cache::RedisWrapper < Cache::Wrapper
  def self.redis
    @redis ||= Redis.new
  end

  def get(key)
		self.class.redis.get(key)
  end

  def set(key, value, time)
    self.class.redis.set(key, value, ex: time)
  end

  def extend(key, time)
    self.class.redis.expire(key, time)
	end
end

RSpec.configure do |config|
  config.before(:suite) do
    Redis.new.flushall
  end

  config.before(:each) do
    if RichUrls.instance_variable_get(:@cache)
      RichUrls.remove_instance_variable(:@cache)
    end
  end
end
