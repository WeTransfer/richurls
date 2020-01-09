module Parsers
  class EmbedParser
    class Base
      def initialize(uri)
        @uri = uri
      end

      private

      def query
        @query ||= Hash[URI.decode_www_form(@uri.query)]
      end
    end
  end
end
