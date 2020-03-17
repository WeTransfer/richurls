require 'spec_helper'

RSpec.describe RichUrls::QueryInterface do
  it 'registers elements' do
    query_interface = RichUrls::QueryInterface.new
    query_interface.start(:p)
    query_interface.start(:img)
    expect(query_interface.elements.length).to eq(2)
  end

  it 'does not add non-whitelisted start elements' do
    query_interface = RichUrls::QueryInterface.new
    query_interface.start(:t)
    query_interface.attr(:x, 'y')
    query_interface.text('list of text')
    query_interface.end(:t)

    expect(query_interface.elements.length).to eq(0)
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
    query_interface = RichUrls::QueryInterface.new
    query_interface.start(:p)
    query_interface.text("Start")
    query_interface.start(:p)
    query_interface.text("Mid start")
    query_interface.start(:a)
    query_interface.text("link mid mid")
    query_interface.end(:a)
    query_interface.text("mid end")
    query_interface.start(:unknown_el)
    query_interface.text("unknown")
    query_interface.end(:unknown_el)
    query_interface.end(:p)
    query_interface.text("End")
    query_interface.end(:p)

    expect(query_interface.elements[0].attributes[:text])
      .to eq('Start Mid start link mid mid mid end unknown End')
  end

  describe 'attributes' do
    it 'adds attributes' do
      query_interface = RichUrls::QueryInterface.new
      query_interface.start(:img)
      query_interface.attr(:src, 'cats.jpg')

      expect(query_interface.elements[0].attributes[:src]).to eq('cats.jpg')
    end

    it 'does not add unknown attributes' do
      query_interface = RichUrls::QueryInterface.new
      query_interface.start(:p)
      query_interface.attr(:x, 'y')

      expect(query_interface.elements[0].attributes[:x]).to eq(nil)
    end
  end
end
