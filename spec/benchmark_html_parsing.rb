require 'benchmark/ips'
require 'nokogiri'
require 'ox'
require_relative '../lib/xml_handler'

Ox.default_options = {
  mode: :generic,
  effort: :tolerant,
  smart: true
}

class ExperimentalXMLHandler < ::Ox::Sax
  WHITELISTED_EL_NAMES = %i[
    html
    head
    title
    meta
    link
    img
  ].freeze

  WHITELISTED_ATTRS = %i[
    property
    content
    rel
    href
    src
  ].freeze

  El = Struct.new(:name, :attributes)

  attr_accessor :elements

  def initialize
    @elements = []
  end

  def find(name, attributes = {})
    @elements.detect do |el|
      matching_attributes = attributes.all? do |key, val|
        el.attributes[key] == val
      end

      el.name == name && matching_attributes
    end
  end

  def start_element(element_name)
    return unless WHITELISTED_EL_NAMES.include?(element_name)

    @elements << El.new(element_name, {})
  end

  def attr(name, str)
    return unless WHITELISTED_ATTRS.include?(name)

    el = @elements.last
    el.attributes[name] = str
  end

  def text(str)
    el = @elements.last
    el && el.attributes[:text].nil? && el.attributes[:text] = str
  end
end

body = File.read('fixtures/youtube_video.html')

Benchmark.ips do |x|
  x.report('nokogiri html parsing') do
    doc = Nokogiri::HTML(body)
    doc.at_css('title').content
  end

  x.report('ox html parsing') do
    handler = RichUrls::XMLHandler.new
    Ox.sax_html(handler, StringIO.new(body))
    handler.find(:title).attributes['text']
  end

  x.report('ox html parsing (experimental)') do
    handler = ExperimentalXMLHandler.new
    Ox.sax_html(handler, StringIO.new(body))
    handler.find(:title).attributes['text']
  end

  x.compare!
end
