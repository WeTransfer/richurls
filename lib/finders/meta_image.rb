module RichUrls
  module Finders
    module MetaImage
      ATTRIBUTE = 'image'.freeze

      def self.found?(elem)
        elem.tag == :meta && elem.attributes[:property] == 'og:image'
      end

      def self.content(elem)
        elem.attributes[:content]
      end
    end
  end
end
