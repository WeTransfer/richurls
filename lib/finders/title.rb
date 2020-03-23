module RichUrls
  module Finders
    module Title
      def self.find(elem)
        elem.tag == :title && elem.text
      end
    end
  end
end
