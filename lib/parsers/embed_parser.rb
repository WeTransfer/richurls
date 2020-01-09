module Parsers
  class EmbedParser
    require_relative 'embed_parsers/base'
    require_relative 'embed_parsers/youtube'
    require_relative 'embed_parsers/youtube_short'
    require_relative 'embed_parsers/paste'
    require_relative 'embed_parsers/spotify'

    PARSERS = [
      Youtube,
      YoutubeShort,
      Paste,
      Spotify
    ].freeze

    def self.call(_, url)
      uri = URI(url)

      PARSERS.each do |parser|
        embed_parser = parser.new(uri)

        return embed_parser.parse if embed_parser.match?
      end

      nil
    end
  end
end
