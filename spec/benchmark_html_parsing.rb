require 'benchmark/ips'
require 'nokogiri'
require 'ox'

Ox.default_options = {
  mode: :generic,
  effort: :tolerant,
  smart:  true
}

body = File.read('fixtures/youtube_video.html')

class Handler < ::Ox::Sax
  El = Struct.new(:name, :attributes)

  attr_accessor :elements

  def initialize
    @elements = []
  end

  def start_element(element_name)
    @elements << El.new(element_name, {})
  end

  def attr(name, str)
    el = @elements.last
    el.attributes[name] = str
  end

  def text(str)
    if el = @elements.last
      el.attributes['text'] = str
    end
  end
end

Benchmark.ips do |x|
  x.report('nokogiri html parsing') do
    doc = Nokogiri::HTML(body)
    doc.at_css('title').content
  end

  x.report('ox html parsing') do
    handler = Handler.new
    Ox.sax_html(handler, StringIO.new(body))
    handler.elements.detect { |t| t.name == :title }.attributes['text']
  end

  x.compare!
end
