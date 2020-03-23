module RichUrls
  module Parsers
    Url = ->(content, url) { UrlHelper.url_for(url, content) }
  end
end
