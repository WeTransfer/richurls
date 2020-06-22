require 'oj'
require 'uri'
require 'digest'

require_relative 'cache'
require_relative 'url_fetcher'
require_relative 'body_decorator'

module RichUrls
  DEFAULT_USER_AGENT = 'richurls'.freeze
  class MalformedURLError < StandardError; end

  def self.cache
    @cache || Cache::None.new
  end

  def self.cache=(wrapper)
    unless wrapper.is_a? Cache::Wrapper
      raise ArgumentError,
            'caching wrapper needs to be an instance of Cache::Wrapper'
    end

    @cache ||= wrapper
  end

  def self.user_agent=(user_agent)
    @user_agent ||= user_agent
  end

  def self.user_agent
    @user_agent || DEFAULT_USER_AGENT
  end

  def self.enrich(url, filter: [], cache_time: nil)
    unless URI::DEFAULT_PARSER.make_regexp.match?(url)
      raise MalformedURLError, "this url is malformed: #{url}"
    end

    UrlFetcher.fetch(url, filter, cache_time)
  end
end
