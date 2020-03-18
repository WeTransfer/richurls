require 'spec_helper'

RSpec.describe RichUrls::XMLHandler do
  describe 'real life example' do
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

    it 'parses xml and returns some elements' do
      expect(xml_handler.elements.length).to eq(10)
    end
  end

  describe 'manual calls' do
    it 'registers elements' do
      xml_handler = RichUrls::XMLHandler.new
      xml_handler.start_element(:p)
      xml_handler.start_element(:img)
      expect(xml_handler.elements.length).to eq(2)
    end

    it 'does not add non-whitelisted start elements' do
      xml_handler = RichUrls::XMLHandler.new
      xml_handler.start_element(:t)
      xml_handler.attr(:x, 'y')
      xml_handler.text('list of text')
      xml_handler.end_element(:t)

      expect(xml_handler.elements.length).to eq(0)
    end

    # structure is like:
    # <p>
    #   Start
    #   <p>
    #     Mid start
    #     <a>link mid mid</a>
    #     mid end
    #     <unknown_el>Some text</unknown_el>
    #   </p>
    #   End
    # </p>
    it 'chains text attributes together' do
      xml_handler = RichUrls::XMLHandler.new
      xml_handler.start_element(:p)
      xml_handler.text('Start')
      xml_handler.start_element(:p)
      xml_handler.text('Mid start')
      xml_handler.start_element(:a)
      xml_handler.text('link mid mid')
      xml_handler.end_element(:a)
      xml_handler.text('mid end')
      xml_handler.start_element(:unknown_el)
      xml_handler.text('unknown')
      xml_handler.end_element(:unknown_el)
      xml_handler.end_element(:p)
      xml_handler.text('End')
      xml_handler.end_element(:p)

      expect(xml_handler.elements[0].attributes[:text])
        .to eq('Start Mid start link mid mid mid end unknown End ')
    end

    describe 'attributes' do
      it 'adds attributes' do
        xml_handler = RichUrls::XMLHandler.new
        xml_handler.start_element(:img)
        xml_handler.attr(:src, 'cats.jpg')

        expect(xml_handler.elements[0].attributes[:src]).to eq('cats.jpg')
      end

      it 'does not add unknown attributes' do
        xml_handler = RichUrls::XMLHandler.new
        xml_handler.start_element(:p)
        xml_handler.attr(:x, 'y')

        expect(xml_handler.elements[0].attributes[:x]).to eq(nil)
      end
    end
  end
end
