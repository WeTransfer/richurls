module RichUrls
  module Parsers
    class EmbedParser
      class Paste < Base
        IFRAME = '<iframe src="https://pasteapp.com/p/%s/embed?view=%s" '\
                 'width="480" height="480" scrolling="no" '\
                 'frameborder="0" allowfullscreen></iframe>'.freeze

        def match?
          @uri.host == 'pasteapp.com' &&
            @uri.path =~ /\/p\/[a-zA-Z0-9]+/ &&
            !@uri.query.nil?
        end

        def parse
          path_id = @uri.path.sub(/\/p\//, '')

          IFRAME % [path_id, query.fetch('view')]
        end
      end
    end
  end
end
