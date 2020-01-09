module Parsers
  class EmbedParser
    class Youtube < Base
      URL = /http(s)?\:\/\/(www\.)?(youtube\.com|youtu\.be)\//.freeze
      TEMPLATE = '<iframe width="560" height="315" src="%s" frameborder="0" '\
                 'allow="accelerometer; autoplay; encrypted-media; '\
                 'gyroscope; picture-in-picture" allowfullscreen>'\
                 '</iframe>'.freeze

      # Turns:
      #   https://www.youtube.com/watch?v=ONYyFiKjJ20
      # Into:
      #   https://www.youtube.com/embed/ONYyFiKjJ20
      def embed_url_for
        @url.sub(/watch\?v=/, 'embed/')
      end
    end
  end
end
