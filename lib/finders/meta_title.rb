module RichUrls
  module Finders
    module MetaTitle
      ATTRIBUTE = 'title'

      def self.found?(el)
        el.tag == :meta && el.attributes[:property] == 'og:title'
      end

      def self.content(el)
        el.attributes[:content].force_encoding('UTF-8')
      end
    end
  end
end
