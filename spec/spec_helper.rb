ENV.store('RACK_ENV', 'test')

Bundler.require(:default, :test)

# require the app
require_relative '../lib/richurls.rb'
require 'redis'

module RichUrls
  module Cache
    class RedisWrapper < Wrapper
      DEFAULT_CACHE_TIME = 60 * 60 # 1 hour

      def redis
        @redis ||= Redis.new
      end

      def initialize(time: DEFAULT_CACHE_TIME)
        @time = time
      end

      def get(key)
        redis.get(key)
      end

      def set(key, value, time)
        return if time && time <= 0

        redis.set(key, value, ex: time || @time)
      end

      def extend(key, time)
        return if time && time < 0

        redis.expire(key, time || @time)
      end
    end
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
