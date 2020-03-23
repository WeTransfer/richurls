module RichUrls
  module Finders
    module Image
      def self.find(elem)
        elem.tag == :img && elem.attributes[:src]
      end
    end
  end
end