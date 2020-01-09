module Parsers
  class EmbedParser
    class YoutubeShort < Base
      def match?
        @uri.host == 'youtu.be'
      end

      def parse
        path = @uri.path
        path[0] = ''

        Youtube::IFRAME % path
      end
    end
  end
end
