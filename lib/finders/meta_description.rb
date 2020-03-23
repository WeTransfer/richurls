module RichUrls
  module Finders
    module MetaDescription
      ATTRIBUTE = 'description'.freeze

      def self.find(elem)
        return unless elem.tag == :meta &&
                      elem.attributes[:property] == 'og:description'

        elem.attributes[:content]
      end
    end
  end
end
