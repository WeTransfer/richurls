require 'ox'

require_relative 'xml_handler'
require_relative 'url_helper'
require_relative 'parsers/title_parser'
require_relative 'parsers/description_parser'
require_relative 'parsers/image_parser'
require_relative 'parsers/embed_parser'
require_relative 'parsers/provider_display_parser'
require_relative 'parsers/favicon_parser'

module RichUrls
  class BodyDecorator
    NoXMLError = Class.new(StandardError)

    PARSERS = {
      'title' => Parsers::TitleParser,
      'description' => Parsers::DescriptionParser,
      'image' => Parsers::ImageParser,
      'provider_display' => Parsers::ProviderDisplayParser,
      'favicon' => Parsers::FaviconParser,
      'embed' => Parsers::EmbedParser
    }.freeze

    def self.decorate(url, body)
      new(url, body).decorate
    end

    private_class_method :new

    def initialize(url, body)
      @url = url
      @xml = XMLHandler.new

      Ox.sax_html(@xml, StringIO.new(body))

      unless @xml.elements.any?
        raise NoXMLError,
              'document is not proper XML'
      end
    rescue XMLHandler::StopParsingError
    end

    def decorate
      PARSERS.transform_values do |parser|
        parser.call(@xml, @url)&.force_encoding('UTF-8')
      end
    end
  end
end
