require 'benchmark/ips'
require 'nokogiri'
require 'ox'
require 'hpricot'

require_relative '../lib/xml_handler'
require_relative './experimental_xml_handler'

Ox.default_options = {
  mode: :generic,
  effort: :tolerant,
  smart: true
}

benchmark_cycles = {
  'fixtures/wetransfer_static.html' =>
    'WeTransfer',
  'fixtures/youtube_video.html' =>
    'My Indiana Jones Movies - Hilariocity Review - YouTube'
}

benchmark_cycles.each_pair do |file_name, answer|
  puts "----- cycle for #{file_name} -----"
  body = File.read(file_name)
  Benchmark.ips do |x|
    x.report('nokogiri html parsing') do
      doc = Nokogiri::HTML(body)
      title = doc.at_css('title').content

      raise "wrong title: #{title.inspect}" unless title == answer
    end

    x.report('hpricot html parsing') do
      parsed = Hpricot(body)
      title = parsed.at('title').inner_html

      raise "wrong title: #{title.inspect}" unless title == answer
    end

    x.report('ox html parsing') do
      handler = RichUrls::XMLHandler.new
      Ox.sax_html(handler, StringIO.new(body))
      title = handler.find(:title).attributes[:text]

      raise "wrong title: #{title.inspect}" unless title == answer
    rescue RichUrls::XMLHandler::StopParsingError
    end

    x.report('ox html parsing (old)') do
      handler = ExperimentalXMLHandler.new
      Ox.sax_html(handler, StringIO.new(body))
      title = handler.find(:title).attributes[:text]

      raise "wrong title: #{title.inspect}" unless title == answer
    rescue ExperimentalXMLHandler::StopParsingError
    end

    x.compare!
  end
end
