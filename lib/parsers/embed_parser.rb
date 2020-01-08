module Parsers
  require_relative 'embed_parser/base'
  require_relative 'embed_parser/youtube'
  require_relative 'embed_parser/paste'

  class EmbedParser
    def self.call(_, url)
      case url
      when Youtube::URL
        Youtube.generate_embed(url)
      when Paste::URL
        Paste.generate_embed(url)
      end
    end
  end
end
