module RichUrls
  module Finders
    module MetaImage
      def self.find(elem)
        return unless elem.tag == :meta &&
                      elem.attributes[:property] == 'og:image'

        elem.attributes[:content]
      end
    end
  end
end
