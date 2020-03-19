module RichUrls
  module Finders
    module Description
      ATTRIBUTE = 'description'.freeze

      def self.found?(elem)
        elem.tag == :p
      end

      def self.content(elem)
        elem.text
      end
    end
  end
end
