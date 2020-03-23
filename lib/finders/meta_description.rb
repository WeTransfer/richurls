module RichUrls
  module Finders
    module MetaDescription
      def self.call(elem)
        return unless elem.tag == :meta &&
                      elem.attributes[:property] == 'og:description'

        elem.attributes[:content]
      end
    end
  end
end
