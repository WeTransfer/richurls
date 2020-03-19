module RichUrls
  module Finders
    module Description
      ATTRIBUTE = :description

      def self.found?(el)
        el.tag == :p
      end

      def self.content(el)
        el.text
      end
    end
  end
end
