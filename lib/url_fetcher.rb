require 'patron'

module RichUrls
  class UrlFetcher
    DEFAULT_TIMEOUT = 10 # seconds

    class UrlFetcherError < StandardError; end

    def self.fetch(url, attributes = [])
      new(url, attributes).fetch
    end

    private_class_method :new

    def initialize(url, attributes)
      @url = url
      @attributes = attributes
    end

    def fetch
      cached = RichUrls.cache.get(digest)

      if cached
        RichUrls.cache.extend(digest)
        Oj.load(cached)
      else
        patron_call
      end
    end

    private

    def digest
      @digest ||= Digest::MD5.hexdigest(@url + @attributes.sort.join('-'))
    end

    def patron_call
      session = Patron::Session.new(timeout: DEFAULT_TIMEOUT)
      response = session.get(@url)

      if response.status < 400
        decorated = BodyDecorator.decorate(
          response.url, response.body, @attributes
        )
        RichUrls.cache.set(digest, Oj.dump(decorated))
        decorated
      else
        raise UrlFetcherError, 'url cannot be found'
      end
    end
  end
end
