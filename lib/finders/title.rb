module RichUrls
  module Finders
    module Title
      ATTRIBUTE = :title

      def self.found?(el)
        el.tag == :title
      end

      def self.content(el)
        el.text
      end
    end
  end
end
