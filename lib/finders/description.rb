module RichUrls
  module Finders
    module Description
      def self.find(elem)
        elem.tag == :p && elem.text
      end
    end
  end
end
