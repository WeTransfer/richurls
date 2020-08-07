require 'patron'

module RichUrls
  class UrlFetcher
    DEFAULT_TIMEOUT = 10 # seconds

    class UrlFetcherError < StandardError; end

    def self.fetch(
      url,
      attributes = [],
      browser: PatronBrowser.new,
      cache_time: nil
    )
      new(url, attributes, browser, cache_time).fetch
    end

    private_class_method :new

    def initialize(url, attributes, browser, cache_time)
      @url = url
      @attributes = attributes
      @browser = browser
      @cache_time = cache_time
    end

    def fetch
      cached = RichUrls.cache.get(digest)

      if cached
        RichUrls.cache.extend(digest, @cache_time)
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
      status, return_url, body = @browser.remote_call(@url)

      if status < 400
        decorated = BodyDecorator.decorate(return_url, body, @attributes)
        RichUrls.cache.set(digest, Oj.dump(decorated), @cache_time)
        decorated
      else
        raise UrlFetcherError, 'url cannot be found'
      end
    end
  end
end
