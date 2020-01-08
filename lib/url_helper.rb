module UrlHelper
  def self.url_for(domain, url)
    return if url.nil?
    return url if url =~ URI::DEFAULT_PARSER.make_regexp

    uri = URI(domain)

    if url.start_with?('/')
      uri.scheme + '://' + uri.host + url
    else
      uri.scheme + '://' + uri.host + uri.path + '/' + url
    end
  end
end
