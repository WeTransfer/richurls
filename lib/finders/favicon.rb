module RichUrls
  module Finders
    module Favicon
      ATTRIBUTE = 'favicon'.freeze
      KEYWORDS = ['shortcut icon', 'icon shortcut', 'icon'].freeze

      def self.found?(elem)
        elem.tag == :link && KEYWORDS.include?(elem.attributes[:rel])
      end

      def self.content(elem)
        elem.attributes[:href]
      end
    end
  end
end
