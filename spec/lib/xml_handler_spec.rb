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

  it 'finds 10 elements' do
    expect(xml_handler.elements.length).to eq(10)
  end

  describe '#find' do
    it 'does not parse div elements' do
      expect(xml_handler.find(:div)).to eq(nil)
    end

    it 'does parse unknown meta elements' do
      expect(xml_handler.find(:meta, property: 'og:trash'))
        .to be_kind_of(RichUrls::XMLHandler::El)
    end

    it 'finds both meta:title and meta:description' do
      title = xml_handler.find(:meta, property: 'og:title')
      description = xml_handler.find(:meta, property: 'og:description')

      expect(title.attributes[:content]).to eq('This is a title')
      expect(description.attributes[:content]).to eq('This is a description')
    end
  end
end
