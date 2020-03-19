module RichUrls
  module Finders
    module Favicon
      ATTRIBUTE = :favicon
      KEYWORDS = ['shortcut icon', 'icon shortcut', 'icon'].freeze

      def self.found?(el)
        el.tag == :link && KEYWORDS.include?(el.attributes[:rel])
      end

      def self.content(el)
        el.attributes[:href]
      end
    end
  end
end
