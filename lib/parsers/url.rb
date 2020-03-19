module RichUrls
  module Parsers
    module Url
      def self.call(content, url)
        UrlHelper.url_for(url, content)
      end
    end
  end
end
