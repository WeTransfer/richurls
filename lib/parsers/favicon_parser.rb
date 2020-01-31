module Parsers
  module FaviconParser
    KEYWORDS = ['shortcut icon', 'icon shortcut', 'icon'].freeze

    def self.call(document, url)
      KEYWORDS.each do |rel|
        found_document = document.find(:link, rel: rel)

        if found_document
          @el = found_document
          break
        end
      end

      @el && UrlHelper.url_for(url, @el.attributes[:href])
    end
  end
end
