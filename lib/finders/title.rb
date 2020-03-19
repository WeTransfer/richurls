module RichUrls
  module Finders
    module Title
      ATTRIBUTE = 'title'.freeze

      def self.find(elem)
        elem.tag == :title && elem.text
      end
    end
  end
end
