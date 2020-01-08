module UrlHelper
  def self.url_for(domain, url)
    return if url.nil?
    return url if url =~ URI::DEFAULT_PARSER.make_regexp

    uri = URI(domain)
    base = uri.scheme + '://' + uri.host

    if url.start_with?('/')
      base + url
    else
      base + uri.path + '/' + url
    end
  end
end
