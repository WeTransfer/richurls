module RichUrls
  module Finders
    module Description
      ATTRIBUTE = 'description'.freeze

      def self.find(elem)
        elem.tag == :p && elem.text
      end
    end
  end
end
