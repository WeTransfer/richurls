module RichUrls
  module Finders
    module MetaDescription
      ATTRIBUTE = 'description'

      def self.found?(el)
        el.tag == :meta && el.attributes[:property] == 'og:description'
      end

      def self.content(el)
        el.attributes[:content]
      end
    end
  end
end
