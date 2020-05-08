require 'addressable'

class UrlHelper
  def self.url_for(domain, url)
    new(domain, url).url
  end

  private_class_method :new

  def initialize(domain, url)
    @domain = domain

    # In some rare cases it appears to be that URL's are ending with a
    # single whitespace character resulting in an invalid URL.
    @url = url&.strip
  end

  def url
    return if @url.nil?
    return Addressable::URI.escape(@url) if valid_url?

    domain_uri = URI(@domain)
    base = domain_uri.scheme + '://' + domain_uri.host
    escaped_url = Addressable::URI.escape(@url)

    if @url.start_with?('/')
      base + escaped_url
    else
      base + domain_uri.path + '/' + escaped_url
    end
  end

  private

  def valid_url?
    @url.start_with?('//') || @url =~ URI::DEFAULT_PARSER.make_regexp
  end
end
