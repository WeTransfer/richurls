require 'oj'
require 'uri'
require 'digest'

require_relative 'cache'
require_relative 'url_fetcher'
require_relative 'body_decorator'
require_relative 'patron_browser'

module RichUrls
  class MalformedURLError < StandardError; end

  def self.cache
    @cache || Cache::None.new
  end

  def self.browser=(browser)
    unless browser.is_a? Browser
      raise ArgumentError,
            'browser needs to be of a RichUrls::Browser type'
    end

    @browser ||= browser
  end

  def self.browser
    @browser || PatronBrowser.new
  end

  def self.cache=(wrapper)
    unless wrapper.is_a? Cache::Wrapper
      raise ArgumentError,
            'caching wrapper needs to be an instance of Cache::Wrapper'
    end

    @cache ||= wrapper
  end

  def self.headers=(headers)
    @headers ||= headers
  end

  def self.headers
    @headers || {}
  end

  def self.enrich(url, filter: [], cache_time: nil)
    unless URI::DEFAULT_PARSER.make_regexp.match?(url)
      raise MalformedURLError, "this url is malformed: #{url}"
    end

    UrlFetcher.fetch(url, filter, browser, cache_time)
  end
end
