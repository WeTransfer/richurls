module Parsers
  class EmbedParser
    class Paste < Base
      URL = /http(s)?\:\/\/(www\.)?pasteapp\.com\//.freeze
      TEMPLATE = '<iframe src="%s" width="480" height="480" scrolling="no" frameborder="0" allowfullscreen></iframe>'.freeze

      # Turns:
      #   https://pasteapp.com/p/jbYfTeB8726?view=xhund8bMW4W
      # Into:
      #   https://pasteapp.com/p/jbYfTeB8726/embed?view=xhund8bMW4W
      def embed_url_for
        @url.sub(/\?view=/, '/embed?view=')
      end
    end
  end
end
