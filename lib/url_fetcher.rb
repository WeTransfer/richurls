require 'patron'

module RichUrls
  class UrlFetcher
    DEFAULT_TIMEOUT = 10 # seconds
    CACHE_TIME = 60 * 60 # 1 hour

    class UrlFetcherError < StandardError; end

    def self.fetch(url)
      new(url).fetch
    end

    private_class_method :new

    def initialize(url)
      @url = url
    end

    def fetch
      cached = redis.get(digest)

      (cached && Oj.load(cached)) || patron_call
    end

    private

    def redis
      @redis ||= Redis.new
    end

    def digest
      @digest ||= Digest::MD5.hexdigest(@url)
    end

    def patron_call
      session = Patron::Session.new(timeout: DEFAULT_TIMEOUT)
      response = session.get(@url)

      if response.status < 400
        decorated = BodyDecorator.new(@url, response.body).decorate
        redis.set(digest, Oj.dump(decorated), ex: CACHE_TIME)
        decorated
      else
        raise UrlFetcherError, 'url cannot be found'
      end
    end
  end
end
