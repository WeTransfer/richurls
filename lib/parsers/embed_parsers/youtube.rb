module Parsers
  class EmbedParser
    class Youtube < Base
      IFRAME = '<iframe width="560" height="315" '\
               'src="https://www.youtube.com/embed/%s" frameborder="0" '\
               'allow="accelerometer; autoplay; encrypted-media; '\
               'gyroscope; picture-in-picture" allowfullscreen>'\
               '</iframe>'.freeze

      def match?
        @uri.host == 'www.youtube.com' &&
          @uri.path == '/watch' &&
          query.key?('v')
      end

      def parse
        IFRAME % query.fetch('v')
      end
    end
  end
end
