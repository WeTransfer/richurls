module RichUrls
  module Finders
    module Title
      ATTRIBUTE = 'title'

      def self.found?(el)
        el.tag == :title
      end

      def self.content(el)
        el.text.force_encoding('UTF-8')
      end
    end
  end
end
