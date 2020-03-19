module RichUrls
  module Finders
    module MetaImage
      ATTRIBUTE = 'image'.freeze

      def self.find(elem)
        return unless elem.tag == :meta &&
                      elem.attributes[:property] == 'og:image'

        elem.attributes[:content]
      end
    end
  end
end
