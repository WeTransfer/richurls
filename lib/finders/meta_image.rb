module RichUrls
  module Finders
    module MetaImage
      def self.call(elem)
        return unless elem.tag == :meta &&
                      elem.attributes[:property] == 'og:image'

        elem.attributes[:content]
      end
    end
  end
end
