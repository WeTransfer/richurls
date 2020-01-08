module Parsers
  class EmbedParser
    class Base
      def self.generate_embed(url)
        new(url).generate_embed
      end

      private_class_method :new

      def initialize(url)
        @url = url
      end

      def generate_embed
        self.class::TEMPLATE % embed_url_for
      end

      def embed_url_for
        raise NotImplementedError, 'sub-class should implement embed_url_for'
      end

      def template
        raise NotImplementedError, 'sub-class should implement template'
      end
    end
  end
end
