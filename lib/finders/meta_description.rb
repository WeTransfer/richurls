module RichUrls
  module Finders
    module MetaDescription
      ATTRIBUTE = 'description'.freeze

      def self.found?(elem)
        elem.tag == :meta && elem.attributes[:property] == 'og:description'
      end

      def self.content(elem)
        elem.attributes[:content]
      end
    end
  end
end
