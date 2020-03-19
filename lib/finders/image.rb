module RichUrls
  module Finders
    module Image
      ATTRIBUTE = 'image'.freeze

      def self.found?(elem)
        elem.tag == :img
      end

      def self.content(elem)
        elem.attributes[:src]
      end
    end
  end
end
