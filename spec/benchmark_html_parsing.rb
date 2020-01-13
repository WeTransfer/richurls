require 'benchmark/ips'
require 'pry'
require 'nokogiri'
require 'ox'
require 'oga'
require 'hpricot'
require 'libxml' # LibXML parsing doesn't seem to do the trick
require 'xml'

require_relative '../lib/xml_handler'
require_relative './experimental_xml_handler'

Ox.default_options = {
  mode: :generic,
  effort: :tolerant,
  smart: true
}

body = File.read('fixtures/youtube_video.html')
answer = 'My Indiana Jones Movies - Hilariocity Review - YouTube'

Benchmark.ips do |x|
  x.report('nokogiri html parsing') do
    doc = Nokogiri::HTML(body)
    title = doc.at_css('title').content
    unless title == answer
      raise "wrong title: #{title.inspect}"
    end
  end

  x.report('oga html parsing') do
    parsed = Oga.parse_xml(body)
    title = parsed.css('title').text

    unless title == answer
      raise "wrong title: #{title.inspect}"
    end
  end

  x.report('hpricot html parsing') do
    parsed = Hpricot(body)
    title = parsed.at('title').inner_html

    unless title == answer
      raise "wrong title: #{title.inspect}"
    end
  end

  x.report('ox html parsing') do
    handler = RichUrls::XMLHandler.new
    Ox.sax_html(handler, StringIO.new(body))
    title = handler.find(:title).attributes[:text]
    unless title == answer
      raise "wrong title: #{title.inspect}"
    end
  end

  x.report('ox html parsing (experimental)') do
    handler = ExperimentalXMLHandler.new
    Ox.sax_html(handler, StringIO.new(body))
    title = handler.find(:title).attributes[:text]
    unless title == answer
      raise "wrong title: #{title.inspect}"
    end
  end

  x.compare!
end
