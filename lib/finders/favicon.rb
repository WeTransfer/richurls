module RichUrls
  module Finders
    module Favicon
      ATTRIBUTE = 'favicon'.freeze
      KEYWORDS = ['shortcut icon', 'icon shortcut', 'icon'].freeze

      def self.find(elem)
        return unless elem.tag == :link &&
                      KEYWORDS.include?(elem.attributes[:rel])

        elem.attributes[:href]
      end
    end
  end
end
