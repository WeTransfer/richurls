require 'ox'

require_relative 'xml_handler'
require_relative 'url_helper'
require_relative 'parsers/property'
require_relative 'parsers/url'
require_relative 'parsers/embed_parser'
require_relative 'parsers/provider_display_parser'

module RichUrls
  class BodyDecorator
    NoXMLError = Class.new(StandardError)

    PARSERS = {
      'title' => Parsers::Property,
      'description' => Parsers::Property,
      'image' => Parsers::Url,
      'favicon' => Parsers::Url,
      'provider_display' => Parsers::ProviderDisplayParser,
      'embed' => Parsers::EmbedParser
    }.freeze

    def self.decorate(url, body, filter = [])
      new(url, body, filter).decorate
    end

    private_class_method :new

    def initialize(url, body, filter)
      @url = url
      @filter = filter
      @xml = XMLHandler.new(filter)

      Ox.sax_html(@xml, StringIO.new(body))

      unless @xml.elements.any?
        raise NoXMLError,
              'document is not proper XML'
      end
    rescue XMLHandler::StopParsingError
    end

    def decorate
      parsers.each_with_object({}) do |(key, parser), object|
        object[key] = parser.call(@xml.properties[key], @url)
      end
    end

    private

    def parsers
      return PARSERS if @filter.empty?

      PARSERS.slice(*@filter)
    end
  end
end
