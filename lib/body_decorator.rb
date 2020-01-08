require 'ox'

require_relative 'xml_handler'
require_relative 'parsers/title_parser'
require_relative 'parsers/description_parser'
require_relative 'parsers/image_parser'
require_relative 'parsers/embed_parser'

class RichUrls
  class BodyDecorator
    NoXMLError = Class.new(StandardError)

    PARSERS = {
      'title' => Parsers::TitleParser,
      'description' => Parsers::DescriptionParser,
      'image' => Parsers::ImageParser,
      'embed' => Parsers::EmbedParser
    }.freeze

    def initialize(url, body)
      @url = url
      @xml = XMLHandler.new

      Ox.sax_html(@xml, StringIO.new(body))

      unless @xml.elements.any?
        raise NoXMLError,
              'document is not proper XML'
      end
    end

    def decorate
      PARSERS.each_with_object({}) do |(key, parser), object|
        object[key] = parser.call(@xml, @url)
      end
    end
  end
end
