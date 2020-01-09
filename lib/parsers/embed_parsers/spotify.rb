module Parsers
  class EmbedParser
    class Spotify < Base
      IFRAME = '<iframe src="https://open.spotify.com/embed/%s/%s" '\
               'width="300" height="380" frameborder="0" '\
               'allowtransparency="true" allow="encrypted-media">'\
               '</iframe>'.freeze

      SCOPES = %w[
        album
        track
        playlist
      ].freeze

      def match?
        valid_path = SCOPES.any? do |path|
          @uri.path.start_with?("/#{path}")
        end

        @uri.host == 'open.spotify.com' && valid_path
      end

      def parse
        path = @uri.path
        path[0] = ''

        IFRAME % path.split('/')
      end
    end
  end
end
