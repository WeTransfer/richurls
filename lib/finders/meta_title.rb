module RichUrls
  module Finders
    module MetaTitle
      ATTRIBUTE = 'title'.freeze

      def self.found?(elem)
        elem.tag == :meta && elem.attributes[:property] == 'og:title'
      end

      def self.content(elem)
        elem.attributes[:content].force_encoding('UTF-8')
      end
    end
  end
end
