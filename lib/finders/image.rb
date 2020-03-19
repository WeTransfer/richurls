module RichUrls
  module Finders
    module Image
      ATTRIBUTE = 'image'

      def self.found?(el)
        el.tag == :img
      end

      def self.content(el)
        el.attributes[:src]
      end
    end
  end
end
