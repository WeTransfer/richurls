module Cache
  def self.for(method)
    case method
    when 'redis' then RedisWrapper
    when 'none' then NoneWrapper
    end
  end

  module RedisWrapper
    def self.redis
      @redis ||= Redis.new
    end

    def self.get(key)
      redis.get(key)
    end

    def self.set(key, value, time)
      redis.set(key, value, ex: time)
    end

    def self.extend(key, time)
      redis.expire(key, time)
    end
  end

  module NoneWrapper
    def self.get(_key); end
    def self.set(_key, _value, _time); end
    def self.extend(_key, _time); end
  end
end
