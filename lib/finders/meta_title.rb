module RichUrls
  module Finders
    module MetaTitle
      ATTRIBUTE = 'title'.freeze

      def self.find(elem)
        return unless elem.tag == :meta &&
                      elem.attributes[:property] == 'og:title'

        elem.attributes[:content]
      end
    end
  end
end
