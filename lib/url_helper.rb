require 'addressable'

module UrlHelper
  def self.url_for(domain, url)
    return if url.nil?
    return url if valid_url?(url)

    domain_uri = URI(domain)
    base = domain_uri.scheme + '://' + domain_uri.host
    escaped_url = Addressable::URI.escape(url)

    if url.start_with?('/')
      base + escaped_url
    else
      base + domain_uri.path + '/' + escaped_url
    end
  end

  def self.valid_url?(url)
    url.start_with?('//') || url =~ URI::DEFAULT_PARSER.make_regexp
  end
end
