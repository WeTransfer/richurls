module RichUrls
  module Finders
    module Title
      ATTRIBUTE = 'title'.freeze

      def self.found?(elem)
        elem.tag == :title
      end

      def self.content(elem)
        elem.text
      end
    end
  end
end
