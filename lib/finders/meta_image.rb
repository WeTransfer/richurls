module RichUrls
  module Finders
    module MetaImage
      ATTRIBUTE = :image

      def self.found?(el)
        el.tag == :meta && el.attributes[:property] == 'og:image'
      end

      def self.content(el)
        el.attributes[:content]
      end
    end
  end
end
