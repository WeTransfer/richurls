module RichUrls
  module Parsers
    module Property
      def self.call(property, _)
        property&.force_encoding('UTF-8')
      end
    end
  end
end
