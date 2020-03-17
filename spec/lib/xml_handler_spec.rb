require 'spec_helper'

RSpec.describe RichUrls::XMLHandler do
  let(:body) { File.binread('./spec/fixtures/xml_handler.html') }
  let(:xml_handler) {
    begin
      xml = RichUrls::XMLHandler.new
      Ox.sax_html(xml, StringIO.new(body))
      xml
    rescue RichUrls::XMLHandler::StopParsingError
      xml
    end
  }

  it 'parses xml' do
    expect(xml_handler).to be_a(RichUrls::XMLHandler)
  end
end
